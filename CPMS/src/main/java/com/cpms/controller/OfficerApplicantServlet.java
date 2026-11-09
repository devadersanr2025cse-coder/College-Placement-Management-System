package com.cpms.controller;

import com.cpms.model.Application;
import com.cpms.model.Job;
import com.cpms.service.OfficerService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/officer/applicants")
public class OfficerApplicantServlet extends HttpServlet {

    private OfficerService officerService;

    @Override
    public void init() {
        officerService = new OfficerService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int jobId = 0;
        try {
            jobId = Integer.parseInt(request.getParameter("jobId"));
        } catch (NumberFormatException ignored) {}

        if (jobId <= 0) {
            response.sendRedirect(request.getContextPath() + "/officer/jobs");
            return;
        }

        Job job = officerService.getJobById(jobId);
        List<Application> applicants = officerService.getJobApplicants(jobId);

        request.setAttribute("job", job);
        request.setAttribute("applicants", applicants);
        request.getRequestDispatcher("/officer/applicants.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("userId");

        int applicationId = Integer.parseInt(request.getParameter("applicationId"));
        int jobId = Integer.parseInt(request.getParameter("jobId"));
        String newStatus = request.getParameter("status"); // SHORTLISTED, REJECTED, SELECTED, UNDER_REVIEW

        boolean updated = officerService.updateApplicantStatus(applicationId, newStatus, userId);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/officer/applicants?jobId=" + jobId + "&success=status");
        } else {
            request.setAttribute("errorMessage", "Failed to update applicant status.");
            doGet(request, response);
        }
    }
}

