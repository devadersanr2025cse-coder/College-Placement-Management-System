package com.cpms.controller;

import com.cpms.dao.DepartmentDAO;
import com.cpms.dao.JobDAO;
import com.cpms.dao.PlacementOfficerDAO;
import com.cpms.model.Department;
import com.cpms.model.Job;
import com.cpms.model.Recruiter;
import com.cpms.service.RecruiterService;

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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/recruiter/jobs")
public class RecruiterJobServlet extends HttpServlet {

    private RecruiterService recruiterService;
    private DepartmentDAO departmentDAO;
    private JobDAO jobDAO;

    @Override
    public void init() {
        recruiterService = new RecruiterService();
        departmentDAO = new DepartmentDAO();
        jobDAO = new JobDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("userId");
        Recruiter recruiter = recruiterService.getRecruiterByUserId(userId);

        if (recruiter == null) {
            response.sendRedirect(request.getContextPath() + "/recruiter/dashboard");
            return;
        }

        List<Job> jobs = recruiterService.getCompanyJobs(recruiter.getCompanyId());
        List<Department> departments = departmentDAO.getAllDepartments();

        request.setAttribute("recruiter", recruiter);
        request.setAttribute("jobs", jobs);
        request.setAttribute("departments", departments);

        request.getRequestDispatcher("/recruiter/jobs.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("userId");
        Recruiter recruiter = recruiterService.getRecruiterByUserId(userId);

        if (recruiter == null) {
            response.sendRedirect(request.getContextPath() + "/recruiter/dashboard");
            return;
        }

        String jobTitle = request.getParameter("jobTitle");
        String jobDescription = request.getParameter("jobDescription");
        String jobType = request.getParameter("jobType");
        String location = request.getParameter("location");
        String minCgpaStr = request.getParameter("minCgpa");
        String maxBacklogsStr = request.getParameter("maxBacklogs");
        String packageLpaStr = request.getParameter("packageLpa");
        String deadlineStr = request.getParameter("applicationDeadline");

        String[] deptParam = request.getParameterValues("departmentIds");
        List<Integer> departmentIds = new ArrayList<>();
        if (deptParam != null) {
            for (String d : deptParam) {
                try { departmentIds.add(Integer.parseInt(d)); } catch (NumberFormatException ignored) {}
            }
        }

        Job job = new Job();
        job.setCompanyId(recruiter.getCompanyId());
        job.setPostedBy(1); // Standard default placement cell officer ID
        job.setJobTitle(jobTitle);
        job.setJobDescription(jobDescription);
        job.setJobType(jobType != null ? jobType : "FULL_TIME");
        job.setLocation(location);
        job.setMinCgpa(minCgpaStr != null && !minCgpaStr.isBlank() ? new BigDecimal(minCgpaStr) : BigDecimal.ZERO);
        job.setMaxBacklogs(maxBacklogsStr != null && !maxBacklogsStr.isBlank() ? Integer.parseInt(maxBacklogsStr) : 0);
        job.setPackageLpa(packageLpaStr != null && !packageLpaStr.isBlank() ? new BigDecimal(packageLpaStr) : null);

        if (deadlineStr != null && !deadlineStr.isBlank()) {
            try {
                LocalDateTime ldt;
                if (deadlineStr.contains("T")) {
                    ldt = LocalDateTime.parse(deadlineStr);
                } else {
                    ldt = LocalDateTime.parse(deadlineStr + "T23:59:59");
                }
                job.setApplicationDeadline(Timestamp.valueOf(ldt));
            } catch (Exception ignored) {}
        }
        job.setJobStatus("OPEN");

        int jobId = jobDAO.createJob(job, departmentIds);
        if (jobId > 0) {
            response.sendRedirect(request.getContextPath() + "/recruiter/jobs?success=created");
        } else {
            request.setAttribute("errorMessage", "Failed to post job listing.");
            doGet(request, response);
        }
    }
}

