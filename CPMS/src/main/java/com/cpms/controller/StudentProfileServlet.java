package com.cpms.controller;

import com.cpms.model.Student;
import com.cpms.service.StudentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet("/student/profile")
public class StudentProfileServlet extends HttpServlet {

    private StudentService studentService;

    @Override
    public void init() {
        studentService = new StudentService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        Student student = studentService.getStudentProfile(userId);

        if (student == null) {
            request.setAttribute("errorMessage", "Student profile not found.");
        }

        request.setAttribute("student", student);
        request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String phone = request.getParameter("phone");
        String dobValue = request.getParameter("dateOfBirth");
        String address = request.getParameter("address");

        LocalDate dateOfBirth = null;
        try {
            if (dobValue != null && !dobValue.isBlank()) {
                dateOfBirth = LocalDate.parse(dobValue);
            }
        } catch (DateTimeParseException e) {
            request.setAttribute("errorMessage", "Invalid date format. Use YYYY-MM-DD.");
            doGet(request, response);
            return;
        }

        boolean updated = studentService.updateContactDetails(userId, phone, dateOfBirth, address);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/student/profile?success=true");
        } else {
            request.setAttribute("errorMessage", "Profile update failed. Ensure phone number contains 10-15 digits.");
            doGet(request, response);
        }
    }
}
