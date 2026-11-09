package com.cpms.dao;

import com.cpms.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReportDAO {

    public Map<String, Object> getOverallPlacementStats() {
        Map<String, Object> stats = new HashMap<>();
        String sql = """
            SELECT
                (SELECT COUNT(*) FROM students) as total_students,
                (SELECT COUNT(*) FROM students WHERE user_id IS NOT NULL) as registered_students,
                (SELECT COUNT(DISTINCT student_id) FROM applications WHERE application_status = 'SELECTED') as placed_students,
                (SELECT COUNT(*) FROM jobs WHERE job_status = 'OPEN') as active_jobs,
                (SELECT COUNT(*) FROM companies WHERE is_active = TRUE) as total_companies,
                (SELECT COUNT(*) FROM applications) as total_applications,
                (SELECT COUNT(*) FROM academic_updates WHERE status = 'PENDING') as pending_verifications,
                (SELECT COUNT(*) FROM interviews WHERE interview_datetime >= NOW()) as upcoming_interviews
        """;

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            if (rs.next()) {
                int totalStudents = rs.getInt("total_students");
                int registeredStudents = rs.getInt("registered_students");
                int placedStudents = rs.getInt("placed_students");
                int activeJobs = rs.getInt("active_jobs");
                int totalCompanies = rs.getInt("total_companies");
                int totalApplications = rs.getInt("total_applications");
                int pendingVerifications = rs.getInt("pending_verifications");
                int upcomingInterviews = rs.getInt("upcoming_interviews");

                double placementPercentage = 0.0;
                if (registeredStudents > 0) {
                    placementPercentage = ((double) placedStudents / registeredStudents) * 100.0;
                }

                stats.put("totalStudents", totalStudents);
                stats.put("registeredStudents", registeredStudents);
                stats.put("placedStudents", placedStudents);
                stats.put("activeJobs", activeJobs);
                stats.put("totalCompanies", totalCompanies);
                stats.put("totalApplications", totalApplications);
                stats.put("pendingVerifications", pendingVerifications);
                stats.put("upcomingInterviews", upcomingInterviews);
                stats.put("placementPercentage", Math.round(placementPercentage * 100.0) / 100.0);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public List<Map<String, Object>> getDepartmentWisePlacementStats() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT d.department_id, d.department_name, d.department_code,
                   COUNT(s.student_id) as total_students,
                   COUNT(CASE WHEN s.user_id IS NOT NULL THEN 1 END) as registered_students,
                   COUNT(DISTINCT CASE WHEN a.application_status = 'SELECTED' THEN s.student_id END) as placed_students
            FROM departments d
            LEFT JOIN students s ON d.department_id = s.department_id
            LEFT JOIN applications a ON s.student_id = a.student_id
            GROUP BY d.department_id, d.department_name, d.department_code
            ORDER BY d.department_name ASC
        """;

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("departmentName", rs.getString("department_name"));
                map.put("departmentCode", rs.getString("department_code"));
                int total = rs.getInt("total_students");
                int registered = rs.getInt("registered_students");
                int placed = rs.getInt("placed_students");
                map.put("totalStudents", total);
                map.put("registeredStudents", registered);
                map.put("placedStudents", placed);
                double pct = registered > 0 ? ((double) placed / registered) * 100.0 : 0.0;
                map.put("placementPercentage", Math.round(pct * 10.0) / 10.0);
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getCompanyWisePlacements() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT c.company_name, c.industry,
                   COUNT(DISTINCT j.job_id) as jobs_posted,
                   COUNT(a.application_id) as total_applicants,
                   COUNT(CASE WHEN a.application_status = 'SELECTED' THEN 1 END) as hired_count,
                   MAX(j.package_lpa) as highest_package
            FROM companies c
            LEFT JOIN jobs j ON c.company_id = j.company_id
            LEFT JOIN applications a ON j.job_id = a.job_id
            GROUP BY c.company_id, c.company_name, c.industry
            ORDER BY hired_count DESC, c.company_name ASC
        """;

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("companyName", rs.getString("company_name"));
                map.put("industry", rs.getString("industry"));
                map.put("jobsPosted", rs.getInt("jobs_posted"));
                map.put("totalApplicants", rs.getInt("total_applicants"));
                map.put("hiredCount", rs.getInt("hired_count"));
                map.put("highestPackage", rs.getBigDecimal("highest_package"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean logReportHistory(int generatedBy, String reportType, String format, String filePath) {
        String sql = "INSERT INTO report_history (generated_by, report_type, report_format, file_path) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, generatedBy);
            ps.setString(2, reportType);
            ps.setString(3, format);
            ps.setString(4, filePath);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}

