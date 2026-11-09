package com.cpms.controller;

import com.cpms.dao.InterviewDAO;
import com.cpms.model.Interview;
import com.cpms.model.Recruiter;
import com.cpms.service.RecruiterService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/recruiter/interviews")
public class RecruiterInterviewServlet extends HttpServlet {

    private RecruiterService recruiterService;
    private InterviewDAO interviewDAO;

    @Override
    public void init() {
        recruiterService = new RecruiterService();
        interviewDAO = new InterviewDAO();
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

        List<Interview> interviews = recruiterService.getCompanyInterviews(recruiter.getCompanyId());

        request.setAttribute("interviews", interviews);
        request.setAttribute("recruiter", recruiter);
        request.getRequestDispatcher("/recruiter/interviews.jsp").forward(request, response);
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

        int interviewId = Integer.parseInt(request.getParameter("interviewId"));
        String result = request.getParameter("result");
        String notes = request.getParameter("notes");

        // Verify interview belongs to this recruiter's company
        Interview iv = interviewDAO.findById(interviewId);
        if (iv == null || iv.getCompanyId() != recruiter.getCompanyId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied.");
            return;
        }

        boolean updated = interviewDAO.updateInterviewResult(interviewId, result, notes);
        if (updated) {
            response.sendRedirect(request.getContextPath() + "/recruiter/interviews?success=result");
        } else {
            request.setAttribute("errorMessage", "Failed to update interview evaluation.");
            doGet(request, response);
        }
    }
}

