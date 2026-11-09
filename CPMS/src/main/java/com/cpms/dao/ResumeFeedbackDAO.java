package com.cpms.dao;

import com.cpms.model.ResumeFeedback;
import com.cpms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ResumeFeedbackDAO {

    public boolean addFeedback(ResumeFeedback f) {
        String sql = """
            INSERT INTO resume_feedbacks (resume_id, student_id, officer_id, feedback_type, comments)
            VALUES (?, ?, ?, ?, ?)
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, f.getResumeId());
            ps.setInt(2, f.getStudentId());
            ps.setInt(3, f.getOfficerId());
            ps.setString(4, f.getFeedbackType());
            ps.setString(5, f.getComments());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<ResumeFeedback> getFeedbacksByStudent(int studentId) {
        List<ResumeFeedback> list = new ArrayList<>();
        String sql = """
            SELECT rf.*, u.full_name as officer_name, po.designation as officer_designation,
                   r.file_name as resume_file_name
            FROM resume_feedbacks rf
            JOIN placement_officers po ON rf.officer_id = po.officer_id
            JOIN users u ON po.user_id = u.user_id
            JOIN resumes r ON rf.resume_id = r.resume_id
            WHERE rf.student_id = ?
            ORDER BY rf.created_at DESC
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapFeedback(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ResumeFeedback> getFeedbacksByResume(int resumeId) {
        List<ResumeFeedback> list = new ArrayList<>();
        String sql = """
            SELECT rf.*, u.full_name as officer_name, po.designation as officer_designation,
                   r.file_name as resume_file_name
            FROM resume_feedbacks rf
            JOIN placement_officers po ON rf.officer_id = po.officer_id
            JOIN users u ON po.user_id = u.user_id
            JOIN resumes r ON rf.resume_id = r.resume_id
            WHERE rf.resume_id = ?
            ORDER BY rf.created_at DESC
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, resumeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapFeedback(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private ResumeFeedback mapFeedback(ResultSet rs) throws SQLException {
        ResumeFeedback f = new ResumeFeedback();
        f.setFeedbackId(rs.getInt("feedback_id"));
        f.setResumeId(rs.getInt("resume_id"));
        f.setStudentId(rs.getInt("student_id"));
        f.setOfficerId(rs.getInt("officer_id"));
        f.setFeedbackType(rs.getString("feedback_type"));
        f.setComments(rs.getString("comments"));
        f.setCreatedAt(rs.getTimestamp("created_at"));
        f.setOfficerName(rs.getString("officer_name"));
        f.setOfficerDesignation(rs.getString("officer_designation"));
        f.setResumeFileName(rs.getString("resume_file_name"));
        return f;
    }
}

