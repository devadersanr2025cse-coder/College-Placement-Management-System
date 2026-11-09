package com.cpms.dao;

import com.cpms.model.AcademicUpdate;
import com.cpms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AcademicUpdateDAO {

    public boolean submitUpdate(AcademicUpdate u) {
        String sql = """
            INSERT INTO academic_updates (student_id, previous_cgpa, submitted_cgpa, previous_backlogs, submitted_backlogs, status, student_remarks)
            VALUES (?, ?, ?, ?, ?, 'PENDING', ?)
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, u.getStudentId());
            ps.setBigDecimal(2, u.getPreviousCgpa());
            ps.setBigDecimal(3, u.getSubmittedCgpa());
            ps.setInt(4, u.getPreviousBacklogs());
            ps.setInt(5, u.getSubmittedBacklogs());
            ps.setString(6, u.getStudentRemarks());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean hasPendingUpdate(int studentId) {
        String sql = "SELECT 1 FROM academic_updates WHERE student_id = ? AND status = 'PENDING'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<AcademicUpdate> getPendingUpdates() {
        List<AcademicUpdate> list = new ArrayList<>();
        String sql = """
            SELECT au.*, u.full_name as student_name, s.register_number, d.department_name,
                   u_off.full_name as officer_name
            FROM academic_updates au
            JOIN students s ON au.student_id = s.student_id
            JOIN users u ON s.user_id = u.user_id
            JOIN departments d ON s.department_id = d.department_id
            LEFT JOIN placement_officers po ON au.reviewed_by = po.officer_id
            LEFT JOIN users u_off ON po.user_id = u_off.user_id
            WHERE au.status = 'PENDING'
            ORDER BY au.submitted_at ASC
        """;

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                list.add(mapUpdate(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<AcademicUpdate> getHistoryByStudent(int studentId) {
        List<AcademicUpdate> list = new ArrayList<>();
        String sql = """
            SELECT au.*, u.full_name as student_name, s.register_number, d.department_name,
                   u_off.full_name as officer_name
            FROM academic_updates au
            JOIN students s ON au.student_id = s.student_id
            JOIN users u ON s.user_id = u.user_id
            JOIN departments d ON s.department_id = d.department_id
            LEFT JOIN placement_officers po ON au.reviewed_by = po.officer_id
            LEFT JOIN users u_off ON po.user_id = u_off.user_id
            WHERE au.student_id = ?
            ORDER BY au.submitted_at DESC
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapUpdate(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public AcademicUpdate findById(int updateId) {
        String sql = """
            SELECT au.*, u.full_name as student_name, s.register_number, d.department_name,
                   u_off.full_name as officer_name
            FROM academic_updates au
            JOIN students s ON au.student_id = s.student_id
            JOIN users u ON s.user_id = u.user_id
            JOIN departments d ON s.department_id = d.department_id
            LEFT JOIN placement_officers po ON au.reviewed_by = po.officer_id
            LEFT JOIN users u_off ON po.user_id = u_off.user_id
            WHERE au.update_id = ?
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, updateId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUpdate(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean reviewUpdate(int updateId, int officerId, String status, String remarks) {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // Fetch update details
            AcademicUpdate au = findById(updateId);
            if (au == null || !"PENDING".equals(au.getStatus())) {
                return false;
            }

            // Update academic_updates table
            String updateSql = """
                UPDATE academic_updates
                SET status = ?, reviewed_by = ?, review_date = NOW(), officer_remarks = ?
                WHERE update_id = ? AND status = 'PENDING'
            """;
            try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                ps.setString(1, status);
                ps.setInt(2, officerId);
                ps.setString(3, remarks);
                ps.setInt(4, updateId);
                ps.executeUpdate();
            }

            // If APPROVED, update official student academic record
            if ("APPROVED".equals(status)) {
                String updateStudentSql = "UPDATE students SET cgpa = ?, active_backlogs = ? WHERE student_id = ?";
                try (PreparedStatement psStu = con.prepareStatement(updateStudentSql)) {
                    psStu.setBigDecimal(1, au.getSubmittedCgpa());
                    psStu.setInt(2, au.getSubmittedBacklogs());
                    psStu.setInt(3, au.getStudentId());
                    psStu.executeUpdate();
                }
            }

            con.commit();
            return true;

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    public int countPendingUpdates() {
        String sql = "SELECT COUNT(*) FROM academic_updates WHERE status = 'PENDING'";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private AcademicUpdate mapUpdate(ResultSet rs) throws SQLException {
        AcademicUpdate au = new AcademicUpdate();
        au.setUpdateId(rs.getInt("update_id"));
        au.setStudentId(rs.getInt("student_id"));
        au.setPreviousCgpa(rs.getBigDecimal("previous_cgpa"));
        au.setSubmittedCgpa(rs.getBigDecimal("submitted_cgpa"));
        au.setPreviousBacklogs(rs.getInt("previous_backlogs"));
        au.setSubmittedBacklogs(rs.getInt("submitted_backlogs"));
        au.setStatus(rs.getString("status"));
        au.setStudentRemarks(rs.getString("student_remarks"));
        int reviewedBy = rs.getInt("reviewed_by");
        if (!rs.wasNull()) {
            au.setReviewedBy(reviewedBy);
        }
        au.setReviewDate(rs.getTimestamp("review_date"));
        au.setOfficerRemarks(rs.getString("officer_remarks"));
        au.setSubmittedAt(rs.getTimestamp("submitted_at"));

        au.setStudentName(rs.getString("student_name"));
        au.setRegisterNumber(rs.getString("register_number"));
        au.setDepartmentName(rs.getString("department_name"));
        au.setOfficerName(rs.getString("officer_name"));
        return au;
    }
}

