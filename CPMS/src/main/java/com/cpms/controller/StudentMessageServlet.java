package com.cpms.controller;

import com.cpms.dao.MessageDAO;
import com.cpms.model.Message;
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

@WebServlet("/student/messages")
public class StudentMessageServlet extends HttpServlet {

    private StudentService studentService;
    private MessageDAO messageDAO;

    @Override
    public void init() {
        studentService = new StudentService();
        messageDAO = new MessageDAO();
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

        // Mark as read if messageId passed
        String markReadId = request.getParameter("read");
        if (markReadId != null && !markReadId.isBlank()) {
            try {
                messageDAO.markAsRead(Integer.parseInt(markReadId), userId);
            } catch (NumberFormatException ignored) {}
        }

        List<Message> inbox = messageDAO.getInboxForUser(userId);
        List<Message> sent = messageDAO.getSentMessages(userId);

        request.setAttribute("student", student);
        request.setAttribute("inbox", inbox);
        request.setAttribute("sent", sent);
        request.getRequestDispatcher("/student/messages.jsp").forward(request, response);
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

        String subject = request.getParameter("subject");
        String content = request.getParameter("content");
        String category = request.getParameter("category");

        if (subject == null || subject.isBlank() || content == null || content.isBlank()) {
            request.setAttribute("errorMessage", "Subject and message content cannot be empty.");
            doGet(request, response);
            return;
        }

        Message m = new Message();
        m.setSenderId(userId);
        m.setReceiverId(null); // Direct message to Placement Cell / Officers
        m.setSubject(subject.trim());
        m.setContent(content.trim());
        m.setCategory(category != null ? category : "GENERAL");

        boolean sent = messageDAO.sendMessage(m);
        if (sent) {
            response.sendRedirect(request.getContextPath() + "/student/messages?success=sent");
        } else {
            request.setAttribute("errorMessage", "Failed to send message.");
            doGet(request, response);
        }
    }
}

