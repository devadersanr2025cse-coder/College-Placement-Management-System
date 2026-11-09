package com.cpms.controller;

import com.cpms.model.Interview;
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

@WebServlet("/student/interviews")
public class StudentInterviewServlet extends HttpServlet {

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

        List<Interview> interviews = studentService.getStudentInterviews(student.getStudentId());

        request.setAttribute("student", student);
        request.setAttribute("interviews", interviews);
        request.getRequestDispatcher("/student/interviews.jsp").forward(request, response);
    }
}

