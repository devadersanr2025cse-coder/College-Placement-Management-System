package com.cpms.controller;

import com.cpms.model.*;
import com.cpms.service.NotificationService;
import com.cpms.service.StudentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {

    private StudentService studentService;
    private NotificationService notificationService;

    @Override
    public void init() {
        studentService = new StudentService();
        notificationService = new NotificationService();
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
            request.setAttribute("errorMessage", "Student record not linked. Please contact the Placement Cell.");
            request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
            return;
        }

        // Cache studentId in session if not present
        session.setAttribute("studentId", student.getStudentId());

        List<Job> availableJobs = studentService.getAvailableJobs(student);
        List<Application> applications = studentService.getStudentApplications(student.getStudentId());
        List<Interview> interviews = studentService.getStudentInterviews(student.getStudentId());
        List<Notification> notifications = notificationService.getUserNotifications(userId, false);
        Resume activeResume = studentService.getActiveResume(student.getStudentId());
        List<AcademicUpdate> academicHistory = studentService.getAcademicHistory(student.getStudentId());

        // Compute application statistics
        int totalApps = applications.size();
        int shortlistedApps = 0;
        int selectedApps = 0;
        int rejectedApps = 0;

        for (Application app : applications) {
            String status = app.getApplicationStatus();
            if ("SHORTLISTED".equalsIgnoreCase(status)) shortlistedApps++;
            else if ("SELECTED".equalsIgnoreCase(status)) selectedApps++;
            else if ("REJECTED".equalsIgnoreCase(status)) rejectedApps++;
        }

        // Compute profile completion percentage
        int profilePoints = 0;
        if (student.getFullName() != null && !student.getFullName().isBlank()) profilePoints += 20;
        if (student.getPhone() != null && !student.getPhone().isBlank()) profilePoints += 20;
        if (student.getDateOfBirth() != null) profilePoints += 20;
        if (student.getAddress() != null && !student.getAddress().isBlank()) profilePoints += 20;
        if (activeResume != null) profilePoints += 20;

        request.setAttribute("student", student);
        request.setAttribute("availableJobs", availableJobs);
        request.setAttribute("applications", applications);
        request.setAttribute("interviews", interviews);
        request.setAttribute("notifications", notifications);
        request.setAttribute("activeResume", activeResume);
        request.setAttribute("academicHistory", academicHistory);
        request.setAttribute("totalApps", totalApps);
        request.setAttribute("shortlistedApps", shortlistedApps);
        request.setAttribute("selectedApps", selectedApps);
        request.setAttribute("rejectedApps", rejectedApps);
        request.setAttribute("profileCompletion", profilePoints);

        request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
    }
}

