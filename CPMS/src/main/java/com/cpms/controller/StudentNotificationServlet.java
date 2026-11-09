package com.cpms.controller;

import com.cpms.model.Notification;
import com.cpms.service.NotificationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/student/notifications")
public class StudentNotificationServlet extends HttpServlet {

    private NotificationService notificationService;

    @Override
    public void init() {
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

        String action = request.getParameter("action");
        if ("read".equalsIgnoreCase(action)) {
            try {
                int notifId = Integer.parseInt(request.getParameter("id"));
                notificationService.markRead(notifId, userId);
            } catch (NumberFormatException ignored) {}
            response.sendRedirect(request.getContextPath() + "/student/notifications");
            return;
        } else if ("readall".equalsIgnoreCase(action)) {
            notificationService.markAllRead(userId);
            response.sendRedirect(request.getContextPath() + "/student/notifications");
            return;
        }

        List<Notification> notifications = notificationService.getUserNotifications(userId, false);
        int unreadCount = notificationService.countUnread(userId);

        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);
        request.getRequestDispatcher("/student/notifications.jsp").forward(request, response);
    }
}

