package com.cpms.controller;

import com.cpms.dao.ApplicationDAO;
import com.cpms.dao.RecruiterDAO;
import com.cpms.dao.ResumeDAO;
import com.cpms.dao.StudentDAO;
import com.cpms.model.Application;
import com.cpms.model.Recruiter;
import com.cpms.model.Resume;
import com.cpms.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@WebServlet("/resume/download")
public class ResumeDownloadServlet extends HttpServlet {

    private ResumeDAO resumeDAO;
    private StudentDAO studentDAO;
    private RecruiterDAO recruiterDAO;
    private ApplicationDAO applicationDAO;

    @Override
    public void init() {
        resumeDAO = new ResumeDAO();
        studentDAO = new StudentDAO();
        recruiterDAO = new RecruiterDAO();
        applicationDAO = new ApplicationDAO();
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
        String role = (String) session.getAttribute("role");

        String resumeIdStr = request.getParameter("id");
        if (resumeIdStr == null || resumeIdStr.isBlank()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing resume ID parameter.");
            return;
        }

        int resumeId;
        try {
            resumeId = Integer.parseInt(resumeIdStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid resume ID.");
            return;
        }

        Resume resume = resumeDAO.findById(resumeId);
        if (resume == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Resume not found.");
            return;
        }

        Student student = studentDAO.findById(resume.getStudentId());
        if (student == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Associated student record not found.");
            return;
        }

        // Authorization checks
        boolean authorized = false;

        if ("OFFICER".equalsIgnoreCase(role)) {
            // Placement officers can review all student resumes
            authorized = true;

        } else if ("STUDENT".equalsIgnoreCase(role)) {
            // Students can only access their own resume
            if (student.getUserId() != null && student.getUserId() == userId) {
                authorized = true;
            }

        } else if ("RECRUITER".equalsIgnoreCase(role)) {
            // Recruiters can only access resume if student has applied to one of their company's jobs
            Recruiter recruiter = recruiterDAO.findByUserId(userId);
            if (recruiter != null) {
                List<Application> companyApps = applicationDAO.getApplicationsByCompany(recruiter.getCompanyId());
                boolean hasApplied = companyApps.stream().anyMatch(a -> a.getStudentId() == student.getStudentId());
                if (hasApplied) {
                    authorized = true;
                }
            }
        }

        if (!authorized) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. You are not authorized to view this candidate's resume.");
            return;
        }

        // Validate file path and prevent directory traversal
        Path filePath = Paths.get(resume.getFilePath()).normalize();
        File file = filePath.toFile();

        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Resume file does not exist on the server storage.");
            return;
        }

        String safeFileName = resume.getFileName() != null ? resume.getFileName().replaceAll("[^a-zA-Z0-9._-]", "_") : "resume.pdf";
        if (!safeFileName.toLowerCase().endsWith(".pdf")) {
            safeFileName += ".pdf";
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=\"" + safeFileName + "\"");
        response.setContentLengthLong(file.length());

        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            out.flush();
        }
    }
}

