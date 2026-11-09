package com.cpms.dao;

import com.cpms.model.Application;
import com.cpms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

    public boolean apply(int studentId, int jobId, Integer resumeId) {
        String sql = """
            INSERT INTO applications (student_id, job_id, resume_id, application_status)
            VALUES (?, ?, ?, 'APPLIED')
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, jobId);
            if (resumeId != null && resumeId > 0) {
                ps.setInt(3, resumeId);
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean withdraw(int applicationId, int studentId) {
        String sql = "UPDATE applications SET application_status = 'WITHDRAWN' WHERE application_id = ? AND student_id = ? AND application_status IN ('APPLIED', 'UNDER_REVIEW')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, applicationId);
            ps.setInt(2, studentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Application findByStudentAndJob(int studentId, int jobId) {
        String sql = """
            SELECT a.*, u.full_name as student_name, s.register_number, u.email as student_email,
                   d.department_name, s.batch_year, s.cgpa, s.active_backlogs,
                   j.job_title, c.company_name, j.package_lpa, j.location,
                   r.file_name as resume_file_name, r.file_path as resume_file_path
            FROM applications a
            JOIN students s ON a.student_id = s.student_id
            JOIN users u ON s.user_id = u.user_id
            JOIN departments d ON s.department_id = d.department_id
            JOIN jobs j ON a.job_id = j.job_id
            JOIN companies c ON j.company_id = c.company_id
            LEFT JOIN resumes r ON a.resume_id = r.resume_id
            WHERE a.student_id = ? AND a.job_id = ?
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, jobId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapApplication(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Application findById(int applicationId) {
        String sql = """
            SELECT a.*, u.full_name as student_name, s.register_number, u.email as student_email,
                   d.department_name, s.batch_year, s.cgpa, s.active_backlogs,
                   j.job_title, c.company_name, j.package_lpa, j.location,
                   r.file_name as resume_file_name, r.file_path as resume_file_path
            FROM applications a
            JOIN students s ON a.student_id = s.student_id
            JOIN users u ON s.user_id = u.user_id
            JOIN departments d ON s.department_id = d.department_id
            JOIN jobs j ON a.job_id = j.job_id
            JOIN companies c ON j.company_id = c.company_id
            LEFT JOIN resumes r ON a.resume_id = r.resume_id
            WHERE a.application_id = ?
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, applicationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapApplication(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Application> getApplicationsByStudent(int studentId) {
        List<Application> list = new ArrayList<>();
        String sql = """
            SELECT a.*, u.full_name as student_name, s.register_number, u.email as student_email,
                   d.department_name, s.batch_year, s.cgpa, s.active_backlogs,
                   j.job_title, c.company_name, j.package_lpa, j.location,
                   r.file_name as resume_file_name, r.file_path as resume_file_path
            FROM applications a
            JOIN students s ON a.student_id = s.student_id
            JOIN users u ON s.user_id = u.user_id
            JOIN departments d ON s.department_id = d.department_id
            JOIN jobs j ON a.job_id = j.job_id
            JOIN companies c ON j.company_id = c.company_id
            LEFT JOIN resumes r ON a.resume_id = r.resume_id
            WHERE a.student_id = ?
            ORDER BY a.applied_at DESC
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapApplication(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Application> getApplicationsByJob(int jobId) {
        List<Application> list = new ArrayList<>();
        String sql = """
            SELECT a.*, u.full_name as student_name, s.register_number, u.email as student_email,
                   d.department_name, s.batch_year, s.cgpa, s.active_backlogs,
                   j.job_title, c.company_name, j.package_lpa, j.location,
                   r.file_name as resume_file_name, r.file_path as resume_file_path
            FROM applications a
            JOIN students s ON a.student_id = s.student_id
            JOIN users u ON s.user_id = u.user_id
            JOIN departments d ON s.department_id = d.department_id
            JOIN jobs j ON a.job_id = j.job_id
            JOIN companies c ON j.company_id = c.company_id
            LEFT JOIN resumes r ON a.resume_id = r.resume_id
            WHERE a.job_id = ?
            ORDER BY a.applied_at DESC
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, jobId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapApplication(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Application> getApplicationsByCompany(int companyId) {
        List<Application> list = new ArrayList<>();
        String sql = """
            SELECT a.*, u.full_name as student_name, s.register_number, u.email as student_email,
                   d.department_name, s.batch_year, s.cgpa, s.active_backlogs,
                   j.job_title, c.company_name, j.package_lpa, j.location,
                   r.file_name as resume_file_name, r.file_path as resume_file_path
            FROM applications a
            JOIN students s ON a.student_id = s.student_id
            JOIN users u ON s.user_id = u.user_id
            JOIN departments d ON s.department_id = d.department_id
            JOIN jobs j ON a.job_id = j.job_id
            JOIN companies c ON j.company_id = c.company_id
            LEFT JOIN resumes r ON a.resume_id = r.resume_id
            WHERE j.company_id = ?
            ORDER BY a.applied_at DESC
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapApplication(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int applicationId, String status) {
        String sql = "UPDATE applications SET application_status = ? WHERE application_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, applicationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countTotalApplications() {
        String sql = "SELECT COUNT(*) FROM applications";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countPlacedStudents() {
        String sql = "SELECT COUNT(DISTINCT student_id) FROM applications WHERE application_status = 'SELECTED'";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Application mapApplication(ResultSet rs) throws SQLException {
        Application a = new Application();
        a.setApplicationId(rs.getInt("application_id"));
        a.setStudentId(rs.getInt("student_id"));
        a.setJobId(rs.getInt("job_id"));
        int resumeId = rs.getInt("resume_id");
        if (!rs.wasNull()) {
            a.setResumeId(resumeId);
        }
        a.setApplicationStatus(rs.getString("application_status"));
        a.setAppliedAt(rs.getTimestamp("applied_at"));
        a.setUpdatedAt(rs.getTimestamp("updated_at"));

        a.setStudentName(rs.getString("student_name"));
        a.setRegisterNumber(rs.getString("register_number"));
        a.setStudentEmail(rs.getString("student_email"));
        a.setDepartmentName(rs.getString("department_name"));
        a.setBatchYear(rs.getInt("batch_year"));
        a.setCgpa(rs.getBigDecimal("cgpa"));
        a.setActiveBacklogs(rs.getInt("active_backlogs"));

        a.setJobTitle(rs.getString("job_title"));
        a.setCompanyName(rs.getString("company_name"));
        a.setPackageLpa(rs.getBigDecimal("package_lpa"));
        a.setLocation(rs.getString("location"));

        a.setResumeFileName(rs.getString("resume_file_name"));
        a.setResumeFilePath(rs.getString("resume_file_path"));
        return a;
    }
}

