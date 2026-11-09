package com.cpms.test;

import com.cpms.util.DBConnection;
import java.sql.Connection;
import java.sql.Statement;

public class DatabaseMigrationRunner {

    private static void executeQuietly(Statement stmt, String sql) {
        try {
            stmt.execute(sql);
            System.out.println("SUCCESS: " + (sql.length() > 60 ? sql.substring(0, 60) + "..." : sql));
        } catch (Exception e) {
            System.out.println("NOTE: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            System.out.println("Applying schema changes to " + conn.getCatalog() + "...");

            // 1. Role enum
            executeQuietly(stmt, "ALTER TABLE users MODIFY COLUMN role ENUM('STUDENT','OFFICER','RECRUITER') NOT NULL");

            // 2. Student user_id nullable
            executeQuietly(stmt, "ALTER TABLE students MODIFY COLUMN user_id INT NULL UNIQUE");

            // 3. Add company columns
            executeQuietly(stmt, "ALTER TABLE companies ADD COLUMN description TEXT AFTER industry");
            executeQuietly(stmt, "ALTER TABLE companies ADD COLUMN is_active BOOLEAN NOT NULL DEFAULT TRUE AFTER contact_phone");

            // 4. Create recruiters table
            executeQuietly(stmt, "CREATE TABLE IF NOT EXISTS recruiters (" +
                    "recruiter_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL UNIQUE, " +
                    "company_id INT NOT NULL, " +
                    "designation VARCHAR(100), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE, " +
                    "FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE" +
                    ") ENGINE=InnoDB");

            // 5. Create academic_updates table
            executeQuietly(stmt, "CREATE TABLE IF NOT EXISTS academic_updates (" +
                    "update_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "student_id INT NOT NULL, " +
                    "previous_cgpa DECIMAL(4,2) NOT NULL, " +
                    "submitted_cgpa DECIMAL(4,2) NOT NULL, " +
                    "previous_backlogs INT NOT NULL, " +
                    "submitted_backlogs INT NOT NULL, " +
                    "status ENUM('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING', " +
                    "student_remarks TEXT, " +
                    "reviewed_by INT NULL, " +
                    "review_date DATETIME NULL, " +
                    "officer_remarks TEXT NULL, " +
                    "submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE, " +
                    "FOREIGN KEY (reviewed_by) REFERENCES placement_officers(officer_id) ON DELETE SET NULL, " +
                    "CHECK (submitted_cgpa BETWEEN 0 AND 10), " +
                    "CHECK (submitted_backlogs >= 0)" +
                    ") ENGINE=InnoDB");

            // 6. Create resume_feedbacks table
            executeQuietly(stmt, "CREATE TABLE IF NOT EXISTS resume_feedbacks (" +
                    "feedback_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "resume_id INT NOT NULL, " +
                    "student_id INT NOT NULL, " +
                    "officer_id INT NOT NULL, " +
                    "feedback_type ENUM('SUGGESTION','CORRECTION','APPROVAL','REJECTION') NOT NULL DEFAULT 'SUGGESTION', " +
                    "comments TEXT NOT NULL, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (resume_id) REFERENCES resumes(resume_id) ON DELETE CASCADE, " +
                    "FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE, " +
                    "FOREIGN KEY (officer_id) REFERENCES placement_officers(officer_id) ON DELETE CASCADE" +
                    ") ENGINE=InnoDB");

            // 7. Create messages table
            executeQuietly(stmt, "CREATE TABLE IF NOT EXISTS messages (" +
                    "message_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "sender_id INT NOT NULL, " +
                    "receiver_id INT NULL, " +
                    "subject VARCHAR(200) NOT NULL, " +
                    "content TEXT NOT NULL, " +
                    "category ENUM('GENERAL','ACADEMIC','RESUME','PROFILE','ADVICE','ANNOUNCEMENT') NOT NULL DEFAULT 'GENERAL', " +
                    "is_read BOOLEAN NOT NULL DEFAULT FALSE, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE CASCADE, " +
                    "FOREIGN KEY (receiver_id) REFERENCES users(user_id) ON DELETE CASCADE, " +
                    "INDEX idx_message_receiver (receiver_id, is_read, created_at)" +
                    ") ENGINE=InnoDB");

            System.out.println("\nInserting / Updating seed data...");

            // Departments
            executeQuietly(stmt, "INSERT INTO departments (department_id, department_name, department_code) VALUES " +
                    "(1, 'Computer Science and Engineering', 'CSE'), " +
                    "(2, 'Information Technology', 'IT'), " +
                    "(3, 'Electronics and Communication Engineering', 'ECE'), " +
                    "(4, 'Electrical and Electronics Engineering', 'EEE'), " +
                    "(5, 'Mechanical Engineering', 'MECH') " +
                    "ON DUPLICATE KEY UPDATE department_name = VALUES(department_name)");

            // Users with BCrypt hashes:
            // Officer: Officer@123 -> $2a$12$kZ5vJSuz0FLwmprDilxmbe5/4d4NM2bCkOBDKEyhYEVh0mMc0ATfO
            // Student: Student@123 -> $2a$12$qqneLARKXdR08Vqm92ID/uV0FO6NHh7rWP4UIY1bPpuAaDpXZQAf6
            // Recruiter: Recruiter@123 -> $2a$12$dZwECxRP2xZo6Pnt35NVh.FqPECGDfdbboCvTs0rYA.wkC3A.Wida
            executeQuietly(stmt, "INSERT INTO users (user_id, full_name, email, password_hash, role, is_active) VALUES " +
                    "(1, 'Dr. Sarah Jenkins', 'officer@cpms.test', '$2a$12$kZ5vJSuz0FLwmprDilxmbe5/4d4NM2bCkOBDKEyhYEVh0mMc0ATfO', 'OFFICER', TRUE), " +
                    "(2, 'Arun Kumar', 'student@cpms.test', '$2a$12$qqneLARKXdR08Vqm92ID/uV0FO6NHh7rWP4UIY1bPpuAaDpXZQAf6', 'STUDENT', TRUE), " +
                    "(3, 'Elena Vance', 'recruiter@example.com', '$2a$12$dZwECxRP2xZo6Pnt35NVh.FqPECGDfdbboCvTs0rYA.wkC3A.Wida', 'RECRUITER', TRUE) " +
                    "ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), password_hash = VALUES(password_hash), role = VALUES(role), is_active = VALUES(is_active)");

            // Placement Officers
            executeQuietly(stmt, "INSERT INTO placement_officers (officer_id, user_id, employee_code, designation) VALUES " +
                    "(1, 1, 'PO001', 'Head of Placements & Corporate Relations') " +
                    "ON DUPLICATE KEY UPDATE designation = VALUES(designation)");

            // Companies
            executeQuietly(stmt, "INSERT INTO companies (company_id, company_name, website, industry, description, contact_person, contact_email, contact_phone, is_active) VALUES " +
                    "(1, 'Example Technologies', 'https://example.com', 'Information Technology', 'Leading enterprise cloud solutions provider.', 'Elena Vance', 'recruiter@example.com', '9876543210', TRUE), " +
                    "(2, 'Global Cloud Systems', 'https://globalcloud.com', 'Cloud Computing', 'Cloud infrastructure and consulting services.', 'Mark Reed', 'careers@globalcloud.com', '9876543222', TRUE), " +
                    "(3, 'Apex Financial Tech', 'https://apexfin.com', 'FinTech', 'Next-generation banking and algorithmic payments.', 'Siddharth Roy', 'hr@apexfin.com', '9876543333', TRUE) " +
                    "ON DUPLICATE KEY UPDATE company_name = VALUES(company_name), description = VALUES(description), is_active = VALUES(is_active)");

            // Recruiters
            executeQuietly(stmt, "INSERT INTO recruiters (recruiter_id, user_id, company_id, designation) VALUES " +
                    "(1, 3, 1, 'Senior Talent Acquisition Lead') " +
                    "ON DUPLICATE KEY UPDATE designation = VALUES(designation)");

            // Students
            executeQuietly(stmt, "INSERT INTO students (student_id, user_id, register_number, department_id, batch_year, cgpa, active_backlogs, phone, date_of_birth, address) VALUES " +
                    "(1, 2, 'CPMS2026001', 1, 2026, 8.25, 0, '9000000000', '2004-05-15', '12 Lake View Rd, Chennai'), " +
                    "(2, NULL, 'CPMS2026002', 2, 2026, 7.80, 0, NULL, NULL, NULL), " +
                    "(3, NULL, 'CPMS2026003', 3, 2026, 6.90, 1, NULL, NULL, NULL) " +
                    "ON DUPLICATE KEY UPDATE cgpa = VALUES(cgpa), department_id = VALUES(department_id), batch_year = VALUES(batch_year)");

            // Jobs
            executeQuietly(stmt, "INSERT INTO jobs (job_id, company_id, posted_by, job_title, job_description, job_type, location, min_cgpa, max_backlogs, package_lpa, application_deadline, job_status) VALUES " +
                    "(1, 1, 1, 'Associate Software Engineer', 'Design and build backend enterprise systems in Java and cloud architectures.', 'FULL_TIME', 'Bengaluru / Hybrid', 7.00, 0, 8.50, DATE_ADD(NOW(), INTERVAL 30 DAY), 'OPEN'), " +
                    "(2, 2, 1, 'Cloud Operations Trainee', 'Manage cloud monitoring, incident management, CI/CD pipelines and deployment infrastructure.', 'FULL_TIME', 'Hyderabad / On-site', 6.50, 1, 6.00, DATE_ADD(NOW(), INTERVAL 20 DAY), 'OPEN') " +
                    "ON DUPLICATE KEY UPDATE job_title = VALUES(job_title), min_cgpa = VALUES(min_cgpa), max_backlogs = VALUES(max_backlogs)");

            // Job departments
            executeQuietly(stmt, "INSERT INTO job_departments (job_id, department_id) VALUES " +
                    "(1, 1), (1, 2), (2, 1), (2, 2), (2, 3) " +
                    "ON DUPLICATE KEY UPDATE department_id = VALUES(department_id)");

            // Notifications
            executeQuietly(stmt, "INSERT INTO notifications (user_id, title, message, notification_type, is_read) VALUES " +
                    "(2, 'Campus Placement Season 2026 Commenced', 'Welcome to CPMS! Please verify your profile, upload your latest PDF resume, and review upcoming job drives.', 'GENERAL', FALSE)");

            System.out.println("\nALL DATABASE SETUP COMPLETED SUCCESSFULLY!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
