package com.cpms.service;

import com.cpms.dao.NotificationDAO;
import com.cpms.dao.UserDAO;
import com.cpms.model.Notification;
import com.cpms.model.User;
import com.cpms.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class NotificationService {

    private final NotificationDAO notificationDAO;

    public NotificationService() {
        this.notificationDAO = new NotificationDAO();
    }

    public boolean notifyUser(int userId, String title, String message, String type) {
        if (userId <= 0 || title == null || message == null) return false;
        return notificationDAO.createNotification(userId, title, message, type);
    }

    public void notifyAllOfficers(String title, String message, String type) {
        String sql = "SELECT user_id FROM users WHERE role = 'OFFICER' AND is_active = TRUE";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                notificationDAO.createNotification(rs.getInt("user_id"), title, message, type);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void notifyAllStudents(String title, String message, String type) {
        String sql = "SELECT user_id FROM users WHERE role = 'STUDENT' AND is_active = TRUE";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                notificationDAO.createNotification(rs.getInt("user_id"), title, message, type);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Notification> getUserNotifications(int userId, boolean unreadOnly) {
        return notificationDAO.getNotificationsForUser(userId, unreadOnly);
    }

    public boolean markRead(int notificationId, int userId) {
        return notificationDAO.markAsRead(notificationId, userId);
    }

    public boolean markAllRead(int userId) {
        return notificationDAO.markAllAsRead(userId);
    }

    public int countUnread(int userId) {
        return notificationDAO.countUnread(userId);
    }
}

