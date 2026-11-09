package com.cpms.dao;

import com.cpms.model.Recruiter;
import com.cpms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RecruiterDAO {

    public Recruiter findByUserId(int userId) {
        String sql = """
            SELECT r.recruiter_id, r.user_id, r.company_id, r.designation, r.created_at,
                   u.full_name, u.email, c.company_name
            FROM recruiters r
            JOIN users u ON r.user_id = u.user_id
            JOIN companies c ON r.company_id = c.company_id
            WHERE r.user_id = ?
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRecruiter(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Recruiter findById(int recruiterId) {
        String sql = """
            SELECT r.recruiter_id, r.user_id, r.company_id, r.designation, r.created_at,
                   u.full_name, u.email, c.company_name
            FROM recruiters r
            JOIN users u ON r.user_id = u.user_id
            JOIN companies c ON r.company_id = c.company_id
            WHERE r.recruiter_id = ?
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, recruiterId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRecruiter(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Recruiter> getRecruitersByCompany(int companyId) {
        List<Recruiter> list = new ArrayList<>();
        String sql = """
            SELECT r.recruiter_id, r.user_id, r.company_id, r.designation, r.created_at,
                   u.full_name, u.email, c.company_name
            FROM recruiters r
            JOIN users u ON r.user_id = u.user_id
            JOIN companies c ON r.company_id = c.company_id
            WHERE r.company_id = ?
            ORDER BY u.full_name ASC
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRecruiter(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean createRecruiter(Recruiter r, Connection con) throws SQLException {
        String sql = "INSERT INTO recruiters (user_id, company_id, designation) VALUES (?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, r.getUserId());
            ps.setInt(2, r.getCompanyId());
            ps.setString(3, r.getDesignation());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        r.setRecruiterId(rs.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    private Recruiter mapRecruiter(ResultSet rs) throws SQLException {
        Recruiter r = new Recruiter();
        r.setRecruiterId(rs.getInt("recruiter_id"));
        r.setUserId(rs.getInt("user_id"));
        r.setCompanyId(rs.getInt("company_id"));
        r.setDesignation(rs.getString("designation"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        r.setFullName(rs.getString("full_name"));
        r.setEmail(rs.getString("email"));
        r.setCompanyName(rs.getString("company_name"));
        return r;
    }
}

