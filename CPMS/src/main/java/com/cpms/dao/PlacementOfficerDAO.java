package com.cpms.dao;

import com.cpms.model.PlacementOfficer;
import com.cpms.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PlacementOfficerDAO {

    public PlacementOfficer findByUserId(int userId) {
        String sql = """
            SELECT po.officer_id, po.user_id, po.employee_code, po.designation,
                   u.full_name, u.email
            FROM placement_officers po
            JOIN users u ON po.user_id = u.user_id
            WHERE po.user_id = ?
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PlacementOfficer po = new PlacementOfficer();
                    po.setOfficerId(rs.getInt("officer_id"));
                    po.setUserId(rs.getInt("user_id"));
                    po.setEmployeeCode(rs.getString("employee_code"));
                    po.setDesignation(rs.getString("designation"));
                    po.setFullName(rs.getString("full_name"));
                    po.setEmail(rs.getString("email"));
                    return po;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public PlacementOfficer findById(int officerId) {
        String sql = """
            SELECT po.officer_id, po.user_id, po.employee_code, po.designation,
                   u.full_name, u.email
            FROM placement_officers po
            JOIN users u ON po.user_id = u.user_id
            WHERE po.officer_id = ?
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, officerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PlacementOfficer po = new PlacementOfficer();
                    po.setOfficerId(rs.getInt("officer_id"));
                    po.setUserId(rs.getInt("user_id"));
                    po.setEmployeeCode(rs.getString("employee_code"));
                    po.setDesignation(rs.getString("designation"));
                    po.setFullName(rs.getString("full_name"));
                    po.setEmail(rs.getString("email"));
                    return po;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean createOfficer(PlacementOfficer po, Connection con) throws SQLException {
        String sql = "INSERT INTO placement_officers (user_id, employee_code, designation) VALUES (?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, po.getUserId());
            ps.setString(2, po.getEmployeeCode());
            ps.setString(3, po.getDesignation());
            return ps.executeUpdate() > 0;
        }
    }
}

