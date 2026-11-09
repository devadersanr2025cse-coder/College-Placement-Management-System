package com.cpms.controller;

import com.cpms.dao.MessageDAO;
import com.cpms.dao.StudentDAO;
import com.cpms.model.Message;
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

@WebServlet("/officer/messages")
public class OfficerMessageServlet extends HttpServlet {

    private OfficerService officerService;
    private MessageDAO messageDAO;
    private StudentDAO studentDAO;

    @Override
    public void init() {
        officerService = new OfficerService();
        messageDAO = new MessageDAO();
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("userId");

        List<Message> inbox = messageDAO.getInboxForUser(userId);
        List<Message> sent = messageDAO.getSentMessages(userId);
        List<Student> students = studentDAO.searchStudents("", null, null);

        request.setAttribute("inbox", inbox);
        request.setAttribute("sent", sent);
        request.setAttribute("students", students);
        request.getRequestDispatcher("/officer/messages.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("userId");

        String receiverIdStr = request.getParameter("receiverId");
        Integer receiverId = null;
        if (receiverIdStr != null && !receiverIdStr.isBlank() && !receiverIdStr.equals("ALL")) {
            try {
                receiverId = Integer.parseInt(receiverIdStr);
            } catch (NumberFormatException ignored) {}
        }

        String subject = request.getParameter("subject");
        String content = request.getParameter("content");
        String category = request.getParameter("category");

        if (subject == null || subject.isBlank() || content == null || content.isBlank()) {
            request.setAttribute("errorMessage", "Subject and message content cannot be empty.");
            doGet(request, response);
            return;
        }

        boolean sent = officerService.sendStudentMessage(userId, receiverId, subject.trim(), content.trim(), category);

        if (sent) {
            response.sendRedirect(request.getContextPath() + "/officer/messages?success=sent");
        } else {
            request.setAttribute("errorMessage", "Failed to dispatch message.");
            doGet(request, response);
        }
    }
}

