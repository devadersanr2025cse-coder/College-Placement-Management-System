package com.cpms.controller;

import com.cpms.model.AcademicUpdate;
import com.cpms.model.Student;
import com.cpms.service.StudentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/student/academic")
public class StudentAcademicServlet extends HttpServlet {

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

        List<AcademicUpdate> history = studentService.getAcademicHistory(student.getStudentId());

        request.setAttribute("student", student);
        request.setAttribute("history", history);
        request.getRequestDispatcher("/student/academic.jsp").forward(request, response);
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

        String cgpaStr = request.getParameter("submittedCgpa");
        String backlogsStr = request.getParameter("submittedBacklogs");
        String remarks = request.getParameter("studentRemarks");

        BigDecimal submittedCgpa;
        int submittedBacklogs;

        try {
            submittedCgpa = new BigDecimal(cgpaStr);
            submittedBacklogs = Integer.parseInt(backlogsStr);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Invalid CGPA or backlog format.");
            doGet(request, response);
            return;
        }

        String result = studentService.submitAcademicUpdate(student.getStudentId(), submittedCgpa, submittedBacklogs, remarks);

        if ("SUCCESS".equals(result)) {
            response.sendRedirect(request.getContextPath() + "/student/academic?success=submitted");
        } else {
            request.setAttribute("errorMessage", result);
            doGet(request, response);
        }
    }
}

