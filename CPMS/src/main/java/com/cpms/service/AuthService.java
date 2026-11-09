package com.cpms.service;

import com.cpms.dao.CompanyDAO;
import com.cpms.dao.PlacementOfficerDAO;
import com.cpms.dao.RecruiterDAO;
import com.cpms.dao.StudentDAO;
import com.cpms.dao.UserDAO;
import com.cpms.model.*;
import com.cpms.util.DBConnection;
import com.cpms.util.PasswordUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;

public class AuthService {

    private final UserDAO userDAO;
    private final StudentDAO studentDAO;
    private final RecruiterDAO recruiterDAO;
    private final CompanyDAO companyDAO;
    private final PlacementOfficerDAO officerDAO;
    private final NotificationService notificationService;

    // Secure officer invitation code required for officer onboarding
    private static final String OFFICER_INVITE_CODE =
            System.getenv().getOrDefault("CPMS_OFFICER_INVITE_CODE", "OFFICER2026");

    public AuthService() {
        this.userDAO = new UserDAO();
        this.studentDAO = new StudentDAO();
        this.recruiterDAO = new RecruiterDAO();
        this.companyDAO = new CompanyDAO();
        this.officerDAO = new PlacementOfficerDAO();
        this.notificationService = new NotificationService();
    }

    public User login(String email, String password) {
        if (email == null || email.trim().isEmpty()
                || password == null || password.isEmpty()) {
            return null;
        }

        User user = userDAO.findByEmail(email.trim());
        if (user == null || !user.isActive()) {
            return null;
        }

        if (!PasswordUtil.checkPassword(password, user.getPasswordHash())) {
            return null;
        }

        return user;
    }

    public String registerStudent(String fullName, String email, String password,
                                  String confirmPassword, String registerNumber,
                                  int departmentId, int batchYear) {

        if (fullName == null || fullName.trim().isEmpty()) {
            return "Full name is required.";
        }
        if (email == null || email.trim().isEmpty() || !email.contains("@")) {
            return "A valid college email address is required.";
        }
        if (password == null || password.length() < 6) {
            return "Password must be at least 6 characters long.";
        }
        if (!password.equals(confirmPassword)) {
            return "Passwords do not match.";
        }
        if (registerNumber == null || registerNumber.trim().isEmpty()) {
            return "Register number is required.";
        }
        if (departmentId <= 0) {
            return "Please select a valid department.";
        }
        if (batchYear < 2020 || batchYear > 2035) {
            return "Please enter a valid graduation batch year.";
        }

        if (userDAO.emailExists(email)) {
            return "An account with this email already exists.";
        }

        // Validate register number against academic student record
        Student existingStudent = studentDAO.findByRegisterNumber(registerNumber.trim());

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // Create User account
            User user = new User();
            user.setFullName(fullName.trim());
            user.setEmail(email.trim().toLowerCase());
            user.setPasswordHash(PasswordUtil.hashPassword(password));
            user.setRole("STUDENT");
            user.setActive(true);

            int userId = userDAO.createUser(user, con);
            if (userId <= 0) {
                con.rollback();
                return "Failed to create user account.";
            }

            if (existingStudent != null) {
                // If student record already exists, ensure it is not already linked to another account
                if (existingStudent.getUserId() != null && existingStudent.getUserId() > 0) {
                    con.rollback();
                    return "Register number " + registerNumber.trim() + " is already linked to an active account.";
                }

                // Link existing student academic record to the newly registered user account
                boolean linked = studentDAO.linkUserToStudentRecord(existingStudent.getStudentId(), userId, con);
                if (!linked) {
                    con.rollback();
                    return "Failed to link your academic record with this account.";
                }
            } else {
                // Fallback: If not pre-seeded by department, create initial student record with default 0 CGPA / pending verification
                Student newStudent = new Student();
                newStudent.setUserId(userId);
                newStudent.setRegisterNumber(registerNumber.trim());
                newStudent.setDepartmentId(departmentId);
                newStudent.setBatchYear(batchYear);
                newStudent.setCgpa(BigDecimal.ZERO);
                newStudent.setActiveBacklogs(0);

                int studentId = studentDAO.createStudentRecord(newStudent, con);
                if (studentId <= 0) {
                    con.rollback();
                    return "Failed to create student academic profile.";
                }
            }

            con.commit();

            // Send welcome notification
            notificationService.notifyUser(userId, "Welcome to CPMS",
                    "Your student account has been created successfully. Please update your profile and upload your resume.",
                    "SYSTEM");

            return "SUCCESS";

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return "Registration error: " + e.getMessage();
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    public String registerRecruiter(String fullName, String email, String password,
                                    String confirmPassword, int companyId,
                                    String newCompanyName, String designation) {

        if (fullName == null || fullName.trim().isEmpty()) {
            return "Full name is required.";
        }
        if (email == null || email.trim().isEmpty() || !email.contains("@")) {
            return "A valid company email address is required.";
        }
        if (password == null || password.length() < 6) {
            return "Password must be at least 6 characters long.";
        }
        if (!password.equals(confirmPassword)) {
            return "Passwords do not match.";
        }
        if (designation == null || designation.trim().isEmpty()) {
            return "Designation is required.";
        }

        if (userDAO.emailExists(email)) {
            return "An account with this email already exists.";
        }

        int targetCompanyId = companyId;

        // Associate with a valid company
        if (targetCompanyId <= 0) {
            if (newCompanyName == null || newCompanyName.trim().isEmpty()) {
                return "Please select an existing company or provide a company name.";
            }

            // Check if company exists by name
            Company existingCo = companyDAO.findByName(newCompanyName.trim());
            if (existingCo != null) {
                targetCompanyId = existingCo.getCompanyId();
            } else {
                Company newCo = new Company();
                newCo.setCompanyName(newCompanyName.trim());
                newCo.setContactPerson(fullName.trim());
                newCo.setContactEmail(email.trim());
                newCo.setActive(true);
                targetCompanyId = companyDAO.createCompany(newCo);
                if (targetCompanyId <= 0) {
                    return "Failed to register company profile.";
                }
            }
        }

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            User user = new User();
            user.setFullName(fullName.trim());
            user.setEmail(email.trim().toLowerCase());
            user.setPasswordHash(PasswordUtil.hashPassword(password));
            user.setRole("RECRUITER");
            user.setActive(true);

            int userId = userDAO.createUser(user, con);
            if (userId <= 0) {
                con.rollback();
                return "Failed to create recruiter user account.";
            }

            Recruiter recruiter = new Recruiter();
            recruiter.setUserId(userId);
            recruiter.setCompanyId(targetCompanyId);
            recruiter.setDesignation(designation.trim());

            boolean created = recruiterDAO.createRecruiter(recruiter, con);
            if (!created) {
                con.rollback();
                return "Failed to associate recruiter with company.";
            }

            con.commit();

            notificationService.notifyUser(userId, "Welcome to CPMS Recruiter Portal",
                    "Your recruiter account is active. You can now post jobs and view candidate applications.",
                    "SYSTEM");

            return "SUCCESS";

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return "Registration error: " + e.getMessage();
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    public String registerOfficer(String fullName, String email, String password,
                                  String confirmPassword, String employeeCode,
                                  String designation, String inviteCode) {

        if (fullName == null || fullName.trim().isEmpty()) {
            return "Full name is required.";
        }
        if (email == null || email.trim().isEmpty() || !email.contains("@")) {
            return "A valid official email is required.";
        }
        if (password == null || password.length() < 6) {
            return "Password must be at least 6 characters long.";
        }
        if (!password.equals(confirmPassword)) {
            return "Passwords do not match.";
        }
        if (employeeCode == null || employeeCode.trim().isEmpty()) {
            return "Employee code is required.";
        }

        // Restrict unrestricted public officer registration
        if (inviteCode == null || !OFFICER_INVITE_CODE.equals(inviteCode.trim())) {
            return "Invalid Officer Invitation Code. Placement Officer registration requires an authorized administrator invite code.";
        }

        if (userDAO.emailExists(email)) {
            return "An account with this email already exists.";
        }

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            User user = new User();
            user.setFullName(fullName.trim());
            user.setEmail(email.trim().toLowerCase());
            user.setPasswordHash(PasswordUtil.hashPassword(password));
            user.setRole("OFFICER");
            user.setActive(true);

            int userId = userDAO.createUser(user, con);
            if (userId <= 0) {
                con.rollback();
                return "Failed to create officer user account.";
            }

            PlacementOfficer po = new PlacementOfficer();
            po.setUserId(userId);
            po.setEmployeeCode(employeeCode.trim());
            po.setDesignation(designation != null && !designation.isBlank() ? designation.trim() : "Placement Officer");

            boolean created = officerDAO.createOfficer(po, con);
            if (!created) {
                con.rollback();
                return "Failed to create placement officer profile.";
            }

            con.commit();
            return "SUCCESS";

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return "Officer registration error: " + e.getMessage();
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }
}
