package com.cpms.controller;

import com.cpms.model.Application;
import com.cpms.model.Job;
import com.cpms.model.Recruiter;
import com.cpms.model.Student;
import com.cpms.service.RecruiterService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/recruiter/candidates")
public class RecruiterCandidateServlet extends HttpServlet {

    private RecruiterService recruiterService;

    @Override
    public void init() {
        recruiterService = new RecruiterService();
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

        String viewStudentIdStr = request.getParameter("viewStudentId");
        if (viewStudentIdStr != null && !viewStudentIdStr.isBlank()) {
            int studentId = Integer.parseInt(viewStudentIdStr);
            Student candidate = recruiterService.getCandidateProfileForRecruiter(studentId, recruiter.getCompanyId());
            if (candidate == null) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied: Candidate has not applied to your company.");
                return;
            }
            request.setAttribute("candidate", candidate);
            request.getRequestDispatcher("/recruiter/candidate-detail.jsp").forward(request, response);
            return;
        }

        List<Application> applicants = recruiterService.getApplicantsForCompany(recruiter.getCompanyId());
        List<Job> companyJobs = recruiterService.getCompanyJobs(recruiter.getCompanyId());

        request.setAttribute("applicants", applicants);
        request.setAttribute("jobs", companyJobs);
        request.setAttribute("recruiter", recruiter);

        request.getRequestDispatcher("/recruiter/candidates.jsp").forward(request, response);
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

        int applicationId = Integer.parseInt(request.getParameter("applicationId"));
        String status = request.getParameter("status"); // SHORTLISTED, REJECTED, SELECTED, UNDER_REVIEW

        boolean updated = recruiterService.updateCandidateStatus(applicationId, recruiter.getCompanyId(), status);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/recruiter/candidates?success=status");
        } else {
            request.setAttribute("errorMessage", "Failed to update candidate status or unauthorized access.");
            doGet(request, response);
        }
    }
}

