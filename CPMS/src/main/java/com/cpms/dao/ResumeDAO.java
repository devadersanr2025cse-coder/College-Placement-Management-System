package com.cpms.dao;

import com.cpms.model.Resume;
import com.cpms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ResumeDAO {

    public int saveResume(int studentId, String fileName, String filePath) {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // Deactivate previous active resumes
            String deactSql = "UPDATE resumes SET is_active = FALSE WHERE student_id = ?";
            try (PreparedStatement psDeact = con.prepareStatement(deactSql)) {
                psDeact.setInt(1, studentId);
                psDeact.executeUpdate();
            }

            // Insert new active resume
            String insertSql = "INSERT INTO resumes (student_id, file_name, file_path, is_active) VALUES (?, ?, ?, TRUE)";
            int generatedId = -1;
            try (PreparedStatement psIns = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                psIns.setInt(1, studentId);
                psIns.setString(2, fileName);
                psIns.setString(3, filePath);
                psIns.executeUpdate();

                try (ResultSet rs = psIns.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                    }
                }
            }

            con.commit();
            return generatedId;

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return -1;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    public Resume getActiveResume(int studentId) {
        String sql = """
            SELECT r.*, u.full_name as student_name, s.register_number
            FROM resumes r
            JOIN students s ON r.student_id = s.student_id
            JOIN users u ON s.user_id = u.user_id
            WHERE r.student_id = ? AND r.is_active = TRUE
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResume(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Resume findById(int resumeId) {
        String sql = """
            SELECT r.*, u.full_name as student_name, s.register_number
            FROM resumes r
            JOIN students s ON r.student_id = s.student_id
            LEFT JOIN users u ON s.user_id = u.user_id
            WHERE r.resume_id = ?
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, resumeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResume(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Resume> getResumesByStudent(int studentId) {
        List<Resume> list = new ArrayList<>();
        String sql = """
            SELECT r.*, u.full_name as student_name, s.register_number
            FROM resumes r
            JOIN students s ON r.student_id = s.student_id
            LEFT JOIN users u ON s.user_id = u.user_id
            WHERE r.student_id = ?
            ORDER BY r.uploaded_at DESC
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResume(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Resume mapResume(ResultSet rs) throws SQLException {
        Resume r = new Resume();
        r.setResumeId(rs.getInt("resume_id"));
        r.setStudentId(rs.getInt("student_id"));
        r.setFileName(rs.getString("file_name"));
        r.setFilePath(rs.getString("file_path"));
        r.setUploadedAt(rs.getTimestamp("uploaded_at"));
        r.setActive(rs.getBoolean("is_active"));
        r.setStudentName(rs.getString("student_name"));
        r.setRegisterNumber(rs.getString("register_number"));
        return r;
    }
}

