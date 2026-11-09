package com.cpms.controller;

import com.cpms.dao.CompanyDAO;
import com.cpms.dao.DepartmentDAO;
import com.cpms.dao.PlacementOfficerDAO;
import com.cpms.model.*;
import com.cpms.service.OfficerService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/officer/jobs")
public class OfficerJobServlet extends HttpServlet {

    private OfficerService officerService;
    private DepartmentDAO departmentDAO;
    private CompanyDAO companyDAO;
    private PlacementOfficerDAO officerDAO;

    @Override
    public void init() {
        officerService = new OfficerService();
        departmentDAO = new DepartmentDAO();
        companyDAO = new CompanyDAO();
        officerDAO = new PlacementOfficerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String closeId = request.getParameter("close");
        if (closeId != null) {
            try {
                officerService.closeJob(Integer.parseInt(closeId));
                response.sendRedirect(request.getContextPath() + "/officer/jobs?success=closed");
                return;
            } catch (Exception ignored) {}
        }

        List<Job> jobs = officerService.getAllJobs();
        List<Department> departments = departmentDAO.getAllDepartments();
        List<Company> companies = companyDAO.getActiveCompanies();

        request.setAttribute("jobs", jobs);
        request.setAttribute("departments", departments);
        request.setAttribute("companies", companies);
        request.getRequestDispatcher("/officer/jobs.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("userId");
        PlacementOfficer officer = officerDAO.findByUserId(userId);
        int officerId = officer != null ? officer.getOfficerId() : 1;

        int jobId = 0;
        try {
            String jobIdStr = request.getParameter("jobId");
            if (jobIdStr != null && !jobIdStr.isBlank()) {
                jobId = Integer.parseInt(jobIdStr);
            }
        } catch (NumberFormatException ignored) {}

        int companyId = Integer.parseInt(request.getParameter("companyId"));
        String jobTitle = request.getParameter("jobTitle");
        String jobDescription = request.getParameter("jobDescription");
        String jobType = request.getParameter("jobType");
        String location = request.getParameter("location");
        String minCgpaStr = request.getParameter("minCgpa");
        String maxBacklogsStr = request.getParameter("maxBacklogs");
        String packageLpaStr = request.getParameter("packageLpa");
        String deadlineStr = request.getParameter("applicationDeadline");
        String jobStatus = request.getParameter("jobStatus");

        String[] deptParam = request.getParameterValues("departmentIds");
        List<Integer> departmentIds = new ArrayList<>();
        if (deptParam != null) {
            for (String d : deptParam) {
                try { departmentIds.add(Integer.parseInt(d)); } catch (NumberFormatException ignored) {}
            }
        }

        Job job = new Job();
        job.setJobId(jobId);
        job.setCompanyId(companyId);
        job.setPostedBy(officerId);
        job.setJobTitle(jobTitle);
        job.setJobDescription(jobDescription);
        job.setJobType(jobType != null ? jobType : "FULL_TIME");
        job.setLocation(location);
        job.setMinCgpa(minCgpaStr != null && !minCgpaStr.isBlank() ? new BigDecimal(minCgpaStr) : BigDecimal.ZERO);
        job.setMaxBacklogs(maxBacklogsStr != null && !maxBacklogsStr.isBlank() ? Integer.parseInt(maxBacklogsStr) : 0);
        job.setPackageLpa(packageLpaStr != null && !packageLpaStr.isBlank() ? new BigDecimal(packageLpaStr) : null);

        if (deadlineStr != null && !deadlineStr.isBlank()) {
            try {
                // Parse HTML5 datetime-local or yyyy-MM-dd
                LocalDateTime ldt;
                if (deadlineStr.contains("T")) {
                    ldt = LocalDateTime.parse(deadlineStr);
                } else {
                    ldt = LocalDateTime.parse(deadlineStr + "T23:59:59");
                }
                job.setApplicationDeadline(Timestamp.valueOf(ldt));
            } catch (Exception ignored) {}
        }

        job.setJobStatus(jobStatus != null ? jobStatus : "OPEN");

        boolean saved = officerService.saveJob(job, departmentIds);
        if (saved) {
            response.sendRedirect(request.getContextPath() + "/officer/jobs?success=saved");
        } else {
            request.setAttribute("errorMessage", "Failed to save job posting.");
            doGet(request, response);
        }
    }
}

