package com.cpms.controller;

import com.cpms.dao.PlacementOfficerDAO;
import com.cpms.dao.ResumeDAO;
import com.cpms.dao.ResumeFeedbackDAO;
import com.cpms.dao.StudentDAO;
import com.cpms.model.PlacementOfficer;
import com.cpms.model.Resume;
import com.cpms.model.ResumeFeedback;
import com.cpms.model.Student;
import com.cpms.service.OfficerService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/officer/resumes")
public class OfficerResumeServlet extends HttpServlet {

    private OfficerService officerService;
    private StudentDAO studentDAO;
    private ResumeDAO resumeDAO;
    private ResumeFeedbackDAO resumeFeedbackDAO;
    private PlacementOfficerDAO officerDAO;

    @Override
    public void init() {
        officerService = new OfficerService();
        studentDAO = new StudentDAO();
        resumeDAO = new ResumeDAO();
        resumeFeedbackDAO = new ResumeFeedbackDAO();
        officerDAO = new PlacementOfficerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String studentIdStr = request.getParameter("studentId");
        if (studentIdStr != null && !studentIdStr.isBlank()) {
            int studentId = Integer.parseInt(studentIdStr);
            Student student = studentDAO.findById(studentId);
            Resume resume = resumeDAO.getActiveResume(studentId);
            List<ResumeFeedback> feedbacks = resumeFeedbackDAO.getFeedbacksByStudent(studentId);

            request.setAttribute("student", student);
            request.setAttribute("resume", resume);
            request.setAttribute("feedbacks", feedbacks);
            request.getRequestDispatcher("/officer/resume-detail.jsp").forward(request, response);
            return;
        }

        List<Student> students = studentDAO.searchStudents("", null, null);
        request.setAttribute("students", students);
        request.getRequestDispatcher("/officer/resumes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("userId");
        PlacementOfficer officer = officerDAO.findByUserId(userId);
        int officerId = officer != null ? officer.getOfficerId() : 1;

        int resumeId = Integer.parseInt(request.getParameter("resumeId"));
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        String feedbackType = request.getParameter("feedbackType");
        String comments = request.getParameter("comments");

        if (comments == null || comments.isBlank()) {
            request.setAttribute("errorMessage", "Comments cannot be empty.");
            doGet(request, response);
            return;
        }

        boolean added = officerService.addResumeFeedback(resumeId, studentId, officerId, feedbackType, comments.trim());

        if (added) {
            response.sendRedirect(request.getContextPath() + "/officer/resumes?studentId=" + studentId + "&success=feedback");
        } else {
            request.setAttribute("errorMessage", "Failed to add resume feedback.");
            doGet(request, response);
        }
    }
}

