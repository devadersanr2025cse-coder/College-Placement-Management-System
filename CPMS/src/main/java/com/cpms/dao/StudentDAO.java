package com.cpms.dao;

import com.cpms.model.Student;
import com.cpms.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    public Student findByUserId(int userId) {
        String sql = """
            SELECT s.student_id, s.user_id, s.register_number,
                   s.department_id, s.batch_year, s.cgpa,
                   s.active_backlogs, s.phone, s.date_of_birth, s.address,
                   u.full_name, u.email, u.is_active as active_user,
                   d.department_name, d.department_code,
                   r.resume_id, r.file_name as resume_file_name, r.file_path as resume_file_path,
                   au.update_id as pending_update_id, au.submitted_cgpa, au.submitted_backlogs
            FROM students s
            JOIN users u ON s.user_id = u.user_id
            JOIN departments d ON s.department_id = d.department_id
            LEFT JOIN resumes r ON r.student_id = s.student_id AND r.is_active = TRUE
            LEFT JOIN academic_updates au ON au.student_id = s.student_id AND au.status = 'PENDING'
            WHERE s.user_id = ?
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapStudent(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Student findById(int studentId) {
        String sql = """
            SELECT s.student_id, s.user_id, s.register_number,
                   s.department_id, s.batch_year, s.cgpa,
                   s.active_backlogs, s.phone, s.date_of_birth, s.address,
                   u.full_name, u.email, u.is_active as active_user,
                   d.department_name, d.department_code,
                   r.resume_id, r.file_name as resume_file_name, r.file_path as resume_file_path,
                   au.update_id as pending_update_id, au.submitted_cgpa, au.submitted_backlogs
            FROM students s
            LEFT JOIN users u ON s.user_id = u.user_id
            JOIN departments d ON s.department_id = d.department_id
            LEFT JOIN resumes r ON r.student_id = s.student_id AND r.is_active = TRUE
            LEFT JOIN academic_updates au ON au.student_id = s.student_id AND au.status = 'PENDING'
            WHERE s.student_id = ?
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapStudent(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Student findByRegisterNumber(String registerNumber) {
        if (registerNumber == null) return null;

        String sql = """
            SELECT s.student_id, s.user_id, s.register_number,
                   s.department_id, s.batch_year, s.cgpa,
                   s.active_backlogs, s.phone, s.date_of_birth, s.address,
                   u.full_name, u.email, u.is_active as active_user,
                   d.department_name, d.department_code,
                   r.resume_id, r.file_name as resume_file_name, r.file_path as resume_file_path,
                   au.update_id as pending_update_id, au.submitted_cgpa, au.submitted_backlogs
            FROM students s
            LEFT JOIN users u ON s.user_id = u.user_id
            JOIN departments d ON s.department_id = d.department_id
            LEFT JOIN resumes r ON r.student_id = s.student_id AND r.is_active = TRUE
            LEFT JOIN academic_updates au ON au.student_id = s.student_id AND au.status = 'PENDING'
            WHERE UPPER(s.register_number) = UPPER(?)
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, registerNumber.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapStudent(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean linkUserToStudentRecord(int studentId, int userId, Connection con) throws SQLException {
        String sql = "UPDATE students SET user_id = ? WHERE student_id = ? AND user_id IS NULL";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, studentId);
            return ps.executeUpdate() > 0;
        }
    }

    public int createStudentRecord(Student s, Connection con) throws SQLException {
        String sql = """
            INSERT INTO students (user_id, register_number, department_id, batch_year, cgpa, active_backlogs, phone, date_of_birth, address)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;
        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (s.getUserId() != null) {
                ps.setInt(1, s.getUserId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, s.getRegisterNumber().trim());
            ps.setInt(3, s.getDepartmentId());
            ps.setInt(4, s.getBatchYear());
            ps.setBigDecimal(5, s.getCgpa());
            ps.setInt(6, s.getActiveBacklogs());
            ps.setString(7, s.getPhone());
            if (s.getDateOfBirth() != null) {
                ps.setDate(8, Date.valueOf(s.getDateOfBirth()));
            } else {
                ps.setNull(8, Types.DATE);
            }
            ps.setString(9, s.getAddress());

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    public boolean updateContactDetails(int userId, String phone, LocalDate dateOfBirth, String address) {
        String sql = """
            UPDATE students
            SET phone = ?, date_of_birth = ?, address = ?
            WHERE user_id = ?
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, phone);
            if (dateOfBirth != null) {
                ps.setDate(2, Date.valueOf(dateOfBirth));
            } else {
                ps.setNull(2, Types.DATE);
            }
            ps.setString(3, address);
            ps.setInt(4, userId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateAcademicDetails(int studentId, BigDecimal cgpa, int backlogs) {
        String sql = "UPDATE students SET cgpa = ?, active_backlogs = ? WHERE student_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setBigDecimal(1, cgpa);
            ps.setInt(2, backlogs);
            ps.setInt(3, studentId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Student> searchStudents(String query, Integer departmentId, Integer batchYear) {
        List<Student> students = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT s.student_id, s.user_id, s.register_number,
                   s.department_id, s.batch_year, s.cgpa,
                   s.active_backlogs, s.phone, s.date_of_birth, s.address,
                   u.full_name, u.email, u.is_active as active_user,
                   d.department_name, d.department_code,
                   r.resume_id, r.file_name as resume_file_name, r.file_path as resume_file_path,
                   au.update_id as pending_update_id, au.submitted_cgpa, au.submitted_backlogs
            FROM students s
            LEFT JOIN users u ON s.user_id = u.user_id
            JOIN departments d ON s.department_id = d.department_id
            LEFT JOIN resumes r ON r.student_id = s.student_id AND r.is_active = TRUE
            LEFT JOIN academic_updates au ON au.student_id = s.student_id AND au.status = 'PENDING'
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();
        if (query != null && !query.isBlank()) {
            sql.append(" AND (LOWER(u.full_name) LIKE ? OR LOWER(s.register_number) LIKE ? OR LOWER(u.email) LIKE ?)");
            String q = "%" + query.trim().toLowerCase() + "%";
            params.add(q);
            params.add(q);
            params.add(q);
        }
        if (departmentId != null && departmentId > 0) {
            sql.append(" AND s.department_id = ?");
            params.add(departmentId);
        }
        if (batchYear != null && batchYear > 0) {
            sql.append(" AND s.batch_year = ?");
            params.add(batchYear);
        }
        sql.append(" ORDER BY s.student_id DESC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    students.add(mapStudent(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return students;
    }

    public int countTotalStudents() {
        String sql = "SELECT COUNT(*) FROM students";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countVerifiedRegisteredStudents() {
        String sql = "SELECT COUNT(*) FROM students WHERE user_id IS NOT NULL";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Student mapStudent(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setStudentId(rs.getInt("student_id"));
        int userId = rs.getInt("user_id");
        if (!rs.wasNull()) {
            s.setUserId(userId);
        }
        s.setRegisterNumber(rs.getString("register_number"));
        s.setDepartmentId(rs.getInt("department_id"));
        s.setBatchYear(rs.getInt("batch_year"));
        s.setCgpa(rs.getBigDecimal("cgpa"));
        s.setActiveBacklogs(rs.getInt("active_backlogs"));
        s.setPhone(rs.getString("phone"));

        Date dob = rs.getDate("date_of_birth");
        if (dob != null) {
            s.setDateOfBirth(dob.toLocalDate());
        }

        s.setAddress(rs.getString("address"));

        // Joined
        s.setFullName(rs.getString("full_name"));
        s.setEmail(rs.getString("email"));
        s.setActiveUser(rs.getBoolean("active_user"));
        s.setDepartmentName(rs.getString("department_name"));
        s.setDepartmentCode(rs.getString("department_code"));

        int resumeId = rs.getInt("resume_id");
        if (!rs.wasNull()) {
            s.setActiveResumeId(resumeId);
            s.setResumeFileName(rs.getString("resume_file_name"));
            s.setResumeFilePath(rs.getString("resume_file_path"));
        }

        int pendingUpdateId = rs.getInt("pending_update_id");
        if (!rs.wasNull() && pendingUpdateId > 0) {
            s.setHasPendingUpdate(true);
            s.setPendingCgpa(rs.getBigDecimal("submitted_cgpa"));
            s.setPendingBacklogs(rs.getInt("submitted_backlogs"));
        } else {
            s.setHasPendingUpdate(false);
        }

        return s;
    }
}
