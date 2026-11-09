package com.cpms.dao;

import com.cpms.model.Message;
import com.cpms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {

    public boolean sendMessage(Message m) {
        String sql = """
            INSERT INTO messages (sender_id, receiver_id, subject, content, category, is_read)
            VALUES (?, ?, ?, ?, ?, FALSE)
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, m.getSenderId());
            if (m.getReceiverId() != null && m.getReceiverId() > 0) {
                ps.setInt(2, m.getReceiverId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, m.getSubject());
            ps.setString(4, m.getContent());
            ps.setString(5, m.getCategory());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Message> getInboxForUser(int userId) {
        List<Message> list = new ArrayList<>();
        String sql = """
            SELECT m.*, u_sen.full_name as sender_name, u_sen.role as sender_role,
                   u_rec.full_name as receiver_name
            FROM messages m
            JOIN users u_sen ON m.sender_id = u_sen.user_id
            LEFT JOIN users u_rec ON m.receiver_id = u_rec.user_id
            WHERE m.receiver_id = ? OR m.receiver_id IS NULL
            ORDER BY m.created_at DESC
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapMessage(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Message> getSentMessages(int senderId) {
        List<Message> list = new ArrayList<>();
        String sql = """
            SELECT m.*, u_sen.full_name as sender_name, u_sen.role as sender_role,
                   u_rec.full_name as receiver_name
            FROM messages m
            JOIN users u_sen ON m.sender_id = u_sen.user_id
            LEFT JOIN users u_rec ON m.receiver_id = u_rec.user_id
            WHERE m.sender_id = ?
            ORDER BY m.created_at DESC
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, senderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapMessage(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean markAsRead(int messageId, int userId) {
        String sql = "UPDATE messages SET is_read = TRUE WHERE message_id = ? AND (receiver_id = ? OR receiver_id IS NULL)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, messageId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Message mapMessage(ResultSet rs) throws SQLException {
        Message m = new Message();
        m.setMessageId(rs.getInt("message_id"));
        m.setSenderId(rs.getInt("sender_id"));
        int recId = rs.getInt("receiver_id");
        if (!rs.wasNull()) {
            m.setReceiverId(recId);
        }
        m.setSubject(rs.getString("subject"));
        m.setContent(rs.getString("content"));
        m.setCategory(rs.getString("category"));
        m.setRead(rs.getBoolean("is_read"));
        m.setCreatedAt(rs.getTimestamp("created_at"));
        m.setSenderName(rs.getString("sender_name"));
        m.setSenderRole(rs.getString("sender_role"));
        m.setReceiverName(rs.getString("receiver_name"));
        return m;
    }
}

