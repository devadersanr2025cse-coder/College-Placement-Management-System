package com.cpms.dao;

import com.cpms.model.Interview;
import com.cpms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InterviewDAO {

    public boolean scheduleInterview(Interview interview) {
        String sql = """
            INSERT INTO interviews (application_id, round_number, interview_datetime, mode, meeting_or_venue, scheduled_by, result, notes)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, interview.getApplicationId());
            ps.setInt(2, interview.getRoundNumber());
            ps.setTimestamp(3, interview.getInterviewDatetime());
            ps.setString(4, interview.getMode());
            ps.setString(5, interview.getMeetingOrVenue());
            ps.setInt(6, interview.getScheduledBy());
            ps.setString(7, interview.getResult());
            ps.setString(8, interview.getNotes());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateInterviewResult(int interviewId, String result, String notes) {
        String sql = "UPDATE interviews SET result = ?, notes = ? WHERE interview_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, result);
            ps.setString(2, notes);
            ps.setInt(3, interviewId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Interview findById(int interviewId) {
        String sql = """
            SELECT i.*, u_stu.full_name as student_name, s.register_number, u_stu.email as student_email,
                   s.student_id, j.job_id, j.job_title, c.company_id, c.company_name,
                   u_off.full_name as scheduled_by_name
            FROM interviews i
            JOIN applications a ON i.application_id = a.application_id
            JOIN students s ON a.student_id = s.student_id
            JOIN users u_stu ON s.user_id = u_stu.user_id
            JOIN jobs j ON a.job_id = j.job_id
            JOIN companies c ON j.company_id = c.company_id
            JOIN placement_officers po ON i.scheduled_by = po.officer_id
            JOIN users u_off ON po.user_id = u_off.user_id
            WHERE i.interview_id = ?
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, interviewId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapInterview(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Interview> getInterviewsByStudent(int studentId) {
        List<Interview> list = new ArrayList<>();
        String sql = """
            SELECT i.*, u_stu.full_name as student_name, s.register_number, u_stu.email as student_email,
                   s.student_id, j.job_id, j.job_title, c.company_id, c.company_name,
                   u_off.full_name as scheduled_by_name
            FROM interviews i
            JOIN applications a ON i.application_id = a.application_id
            JOIN students s ON a.student_id = s.student_id
            JOIN users u_stu ON s.user_id = u_stu.user_id
            JOIN jobs j ON a.job_id = j.job_id
            JOIN companies c ON j.company_id = c.company_id
            JOIN placement_officers po ON i.scheduled_by = po.officer_id
            JOIN users u_off ON po.user_id = u_off.user_id
            WHERE a.student_id = ?
            ORDER BY i.interview_datetime DESC
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapInterview(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Interview> getInterviewsByCompany(int companyId) {
        List<Interview> list = new ArrayList<>();
        String sql = """
            SELECT i.*, u_stu.full_name as student_name, s.register_number, u_stu.email as student_email,
                   s.student_id, j.job_id, j.job_title, c.company_id, c.company_name,
                   u_off.full_name as scheduled_by_name
            FROM interviews i
            JOIN applications a ON i.application_id = a.application_id
            JOIN students s ON a.student_id = s.student_id
            JOIN users u_stu ON s.user_id = u_stu.user_id
            JOIN jobs j ON a.job_id = j.job_id
            JOIN companies c ON j.company_id = c.company_id
            JOIN placement_officers po ON i.scheduled_by = po.officer_id
            JOIN users u_off ON po.user_id = u_off.user_id
            WHERE c.company_id = ?
            ORDER BY i.interview_datetime DESC
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapInterview(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Interview> getUpcomingInterviews(int limit) {
        List<Interview> list = new ArrayList<>();
        String sql = """
            SELECT i.*, u_stu.full_name as student_name, s.register_number, u_stu.email as student_email,
                   s.student_id, j.job_id, j.job_title, c.company_id, c.company_name,
                   u_off.full_name as scheduled_by_name
            FROM interviews i
            JOIN applications a ON i.application_id = a.application_id
            JOIN students s ON a.student_id = s.student_id
            JOIN users u_stu ON s.user_id = u_stu.user_id
            JOIN jobs j ON a.job_id = j.job_id
            JOIN companies c ON j.company_id = c.company_id
            JOIN placement_officers po ON i.scheduled_by = po.officer_id
            JOIN users u_off ON po.user_id = u_off.user_id
            WHERE i.interview_datetime >= NOW()
            ORDER BY i.interview_datetime ASC
            LIMIT ?
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, limit > 0 ? limit : 20);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapInterview(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countUpcomingInterviews() {
        String sql = "SELECT COUNT(*) FROM interviews WHERE interview_datetime >= NOW()";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Interview mapInterview(ResultSet rs) throws SQLException {
        Interview i = new Interview();
        i.setInterviewId(rs.getInt("interview_id"));
        i.setApplicationId(rs.getInt("application_id"));
        i.setRoundNumber(rs.getInt("round_number"));
        i.setInterviewDatetime(rs.getTimestamp("interview_datetime"));
        i.setMode(rs.getString("mode"));
        i.setMeetingOrVenue(rs.getString("meeting_or_venue"));
        i.setScheduledBy(rs.getInt("scheduled_by"));
        i.setResult(rs.getString("result"));
        i.setNotes(rs.getString("notes"));

        i.setStudentId(rs.getInt("student_id"));
        i.setStudentName(rs.getString("student_name"));
        i.setRegisterNumber(rs.getString("register_number"));
        i.setStudentEmail(rs.getString("student_email"));

        i.setJobId(rs.getInt("job_id"));
        i.setJobTitle(rs.getString("job_title"));
        i.setCompanyId(rs.getInt("company_id"));
        i.setCompanyName(rs.getString("company_name"));

        i.setScheduledByName(rs.getString("scheduled_by_name"));
        return i;
    }
}

