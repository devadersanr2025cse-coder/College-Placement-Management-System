package com.cpms.controller;

import com.cpms.model.*;
import com.cpms.service.RecruiterService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/recruiter/dashboard")
public class RecruiterDashboardServlet extends HttpServlet {

    private RecruiterService recruiterService;

    @Override
    public void init() {
        recruiterService = new RecruiterService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        Recruiter recruiter = recruiterService.getRecruiterByUserId(userId);

        if (recruiter == null) {
            request.setAttribute("errorMessage", "Recruiter profile not linked to a company.");
            request.getRequestDispatcher("/recruiter/dashboard.jsp").forward(request, response);
            return;
        }

        session.setAttribute("companyId", recruiter.getCompanyId());
        session.setAttribute("companyName", recruiter.getCompanyName());

        Map<String, Object> metrics = recruiterService.getRecruiterDashboardMetrics(recruiter.getCompanyId());
        List<Job> jobs = recruiterService.getCompanyJobs(recruiter.getCompanyId());
        List<Application> applicants = recruiterService.getApplicantsForCompany(recruiter.getCompanyId());
        List<Interview> interviews = recruiterService.getCompanyInterviews(recruiter.getCompanyId());

        request.setAttribute("recruiter", recruiter);
        request.setAttribute("metrics", metrics);
        request.setAttribute("jobs", jobs);
        request.setAttribute("applicants", applicants);
        request.setAttribute("interviews", interviews);

        request.getRequestDispatcher("/recruiter/dashboard.jsp").forward(request, response);
    }
}

