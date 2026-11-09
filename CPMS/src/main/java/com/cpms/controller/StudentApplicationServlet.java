package com.cpms.controller;

import com.cpms.model.Application;
import com.cpms.model.Student;
import com.cpms.service.StudentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/student/applications")
public class StudentApplicationServlet extends HttpServlet {

    private StudentService studentService;

    @Override
    public void init() {
        studentService = new StudentService();
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
        Student student = studentService.getStudentProfile(userId);
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
            return;
        }

        List<Application> applications = studentService.getStudentApplications(student.getStudentId());

        request.setAttribute("student", student);
        request.setAttribute("applications", applications);
        request.getRequestDispatcher("/student/applications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        Student student = studentService.getStudentProfile(userId);
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
            return;
        }

        String action = request.getParameter("action");

        if ("apply".equalsIgnoreCase(action)) {
            int jobId = 0;
            Integer resumeId = null;
            try {
                jobId = Integer.parseInt(request.getParameter("jobId"));
                String resumeIdStr = request.getParameter("resumeId");
                if (resumeIdStr != null && !resumeIdStr.isBlank()) {
                    resumeId = Integer.parseInt(resumeIdStr);
                }
            } catch (NumberFormatException ignored) {}

            String result = studentService.applyForJob(student.getStudentId(), jobId, resumeId);
            if ("SUCCESS".equals(result)) {
                response.sendRedirect(request.getContextPath() + "/student/applications?success=applied");
            } else {
                request.setAttribute("errorMessage", result);
                doGet(request, response);
            }

        } else if ("withdraw".equalsIgnoreCase(action)) {
            int applicationId = 0;
            try {
                applicationId = Integer.parseInt(request.getParameter("applicationId"));
            } catch (NumberFormatException ignored) {}

            boolean withdrawn = studentService.withdrawApplication(applicationId, student.getStudentId());
            if (withdrawn) {
                response.sendRedirect(request.getContextPath() + "/student/applications?success=withdrawn");
            } else {
                request.setAttribute("errorMessage", "Unable to withdraw this application.");
                doGet(request, response);
            }
        } else {
            doGet(request, response);
        }
    }
}

