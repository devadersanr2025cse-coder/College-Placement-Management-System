package com.cpms.controller;

import com.cpms.model.Resume;
import com.cpms.model.ResumeFeedback;
import com.cpms.model.Student;
import com.cpms.service.StudentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

@WebServlet("/student/resume")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1 MB
        maxFileSize = 5 * 1024 * 1024,         // 5 MB
        maxRequestSize = 10 * 1024 * 1024      // 10 MB
)
public class StudentResumeServlet extends HttpServlet {

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

        Resume activeResume = studentService.getActiveResume(student.getStudentId());
        List<ResumeFeedback> feedbacks = studentService.getResumeFeedbacks(student.getStudentId());

        request.setAttribute("student", student);
        request.setAttribute("activeResume", activeResume);
        request.setAttribute("feedbacks", feedbacks);
        request.getRequestDispatcher("/student/resume.jsp").forward(request, response);
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

        Part filePart = request.getPart("resumeFile");
        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("errorMessage", "Please select a PDF file to upload.");
            doGet(request, response);
            return;
        }

        String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String contentType = filePart.getContentType();

        // Strict PDF validation
        if (!submittedFileName.toLowerCase().endsWith(".pdf") ||
            (contentType != null && !contentType.equalsIgnoreCase("application/pdf") &&
             !contentType.equalsIgnoreCase("application/x-pdf") &&
             !contentType.equalsIgnoreCase("application/octet-stream"))) {
            request.setAttribute("errorMessage", "Invalid file type. Only PDF documents (.pdf) are permitted.");
            doGet(request, response);
            return;
        }

        // Validate max file size (5 MB)
        if (filePart.getSize() > 5 * 1024 * 1024) {
            request.setAttribute("errorMessage", "File size exceeds the 5 MB limit.");
            doGet(request, response);
            return;
        }

        // Configure upload directory safely
        String uploadDirProp = System.getenv("CPMS_UPLOAD_DIR");
        Path uploadDir;
        if (uploadDirProp != null && !uploadDirProp.isBlank()) {
            uploadDir = Paths.get(uploadDirProp, "resumes");
        } else {
            String appPath = request.getServletContext().getRealPath("");
            if (appPath != null) {
                uploadDir = Paths.get(appPath, "uploads", "resumes");
            } else {
                uploadDir = Paths.get(System.getProperty("user.home"), ".cpms", "uploads", "resumes");
            }
        }

        if (!Files.exists(uploadDir)) {
            Files.createDirectories(uploadDir);
        }

        // Prevent path traversal with UUID filename
        String safeUniqueFileName = "RESUME_" + student.getRegisterNumber() + "_" + UUID.randomUUID().toString().substring(0, 8) + ".pdf";
        Path targetPath = uploadDir.resolve(safeUniqueFileName);

        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, targetPath, StandardCopyOption.REPLACE_EXISTING);
        }

        boolean saved = studentService.saveUploadedResume(
                student.getStudentId(),
                submittedFileName,
                targetPath.toAbsolutePath().toString()
        );

        if (saved) {
            response.sendRedirect(request.getContextPath() + "/student/resume?success=uploaded");
        } else {
            request.setAttribute("errorMessage", "Failed to update resume record in database.");
            doGet(request, response);
        }
    }
}

