package com.cpms.controller;

import com.cpms.model.Application;
import com.cpms.model.Job;
import com.cpms.model.Resume;
import com.cpms.model.Student;
import com.cpms.service.StudentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/student/jobs")
public class StudentJobsServlet extends HttpServlet {

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

        List<Job> jobs = studentService.getAvailableJobs(student);
        List<Application> myApps = studentService.getStudentApplications(student.getStudentId());
        Resume activeResume = studentService.getActiveResume(student.getStudentId());

        Set<Integer> appliedJobIds = new HashSet<>();
        for (Application a : myApps) {
            if (!"WITHDRAWN".equalsIgnoreCase(a.getApplicationStatus())) {
                appliedJobIds.add(a.getJobId());
            }
        }

        request.setAttribute("student", student);
        request.setAttribute("jobs", jobs);
        request.setAttribute("appliedJobIds", appliedJobIds);
        request.setAttribute("activeResume", activeResume);

        request.getRequestDispatcher("/student/jobs.jsp").forward(request, response);
    }
}

