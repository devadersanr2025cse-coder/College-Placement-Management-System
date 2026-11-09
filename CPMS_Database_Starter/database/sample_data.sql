USE cpms;

-- Insert Departments
INSERT INTO departments (department_id, department_name, department_code) VALUES
(1, 'Computer Science and Engineering', 'CSE'),
(2, 'Information Technology', 'IT'),
(3, 'Electronics and Communication Engineering', 'ECE'),
(4, 'Electrical and Electronics Engineering', 'EEE'),
(5, 'Mechanical Engineering', 'MECH')
ON DUPLICATE KEY UPDATE department_name = VALUES(department_name);

-- Insert Users (Officer, Student, Recruiter)
-- Passwords:
-- Officer: Officer@123
-- Student: Student@123
-- Recruiter: Recruiter@123
INSERT INTO users (user_id, full_name, email, password_hash, role, is_active) VALUES
(1, 'Dr. Sarah Jenkins', 'officer@cpms.test', '$2a$12$kZ5vJSuz0FLwmprDilxmbe5/4d4NM2bCkOBDKEyhYEVh0mMc0ATfO', 'OFFICER', TRUE),
(2, 'Arun Kumar', 'student@cpms.test', '$2a$12$qqneLARKXdR08Vqm92ID/uV0FO6NHh7rWP4UIY1bPpuAaDpXZQAf6', 'STUDENT', TRUE),
(3, 'Elena Vance', 'recruiter@example.com', '$2a$12$dZwECxRP2xZo6Pnt35NVh.FqPECGDfdbboCvTs0rYA.wkC3A.Wida', 'RECRUITER', TRUE)
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), password_hash = VALUES(password_hash);

-- Placement Officer record
INSERT INTO placement_officers (officer_id, user_id, employee_code, designation) VALUES
(1, 1, 'PO001', 'Head of Placements & Corporate Relations')
ON DUPLICATE KEY UPDATE designation = VALUES(designation);

-- Companies
INSERT INTO companies (company_id, company_name, website, industry, description, contact_person, contact_email, contact_phone, is_active) VALUES
(1, 'Example Technologies', 'https://example.com', 'Information Technology', 'Leading enterprise cloud solutions provider.', 'Elena Vance', 'recruiter@example.com', '9876543210', TRUE),
(2, 'Global Cloud Systems', 'https://globalcloud.com', 'Cloud Computing', 'Cloud infrastructure and consulting services.', 'Mark Reed', 'careers@globalcloud.com', '9876543222', TRUE),
(3, 'Apex Financial Tech', 'https://apexfin.com', 'FinTech', 'Next-generation banking and algorithmic payments.', 'Siddharth Roy', 'hr@apexfin.com', '9876543333', TRUE)
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);

-- Recruiter profile linking user 3 to company 1
INSERT INTO recruiters (recruiter_id, user_id, company_id, designation) VALUES
(1, 3, 1, 'Senior Talent Acquisition Lead')
ON DUPLICATE KEY UPDATE designation = VALUES(designation);

-- Students:
-- 1. Active student linked to user 2
-- 2. Pre-seeded academic record CPMS2026002 (unlinked, ready for student registration testing!)
-- 3. Pre-seeded academic record CPMS2026003 (unlinked, ready for student registration testing!)
INSERT INTO students (student_id, user_id, register_number, department_id, batch_year, cgpa, active_backlogs, phone, date_of_birth, address) VALUES
(1, 2, 'CPMS2026001', 1, 2026, 8.25, 0, '9000000000', '2004-05-15', '12 Lake View Rd, Chennai'),
(2, NULL, 'CPMS2026002', 2, 2026, 7.80, 0, NULL, NULL, NULL),
(3, NULL, 'CPMS2026003', 3, 2026, 6.90, 1, NULL, NULL, NULL)
ON DUPLICATE KEY UPDATE cgpa = VALUES(cgpa);

-- Sample Jobs
INSERT INTO jobs (job_id, company_id, posted_by, job_title, job_description, job_type, location, min_cgpa, max_backlogs, package_lpa, application_deadline, job_status) VALUES
(1, 1, 1, 'Associate Software Engineer', 'Design and build backend enterprise systems in Java and cloud architectures.', 'FULL_TIME', 'Bengaluru / Hybrid', 7.00, 0, 8.50, DATE_ADD(NOW(), INTERVAL 30 DAY), 'OPEN'),
(2, 2, 1, 'Cloud Operations Trainee', 'Manage cloud monitoring, incident management, CI/CD pipelines and deployment infrastructure.', 'FULL_TIME', 'Hyderabad / On-site', 6.50, 1, 6.00, DATE_ADD(NOW(), INTERVAL 20 DAY), 'OPEN')
ON DUPLICATE KEY UPDATE job_title = VALUES(job_title);

-- Eligible departments for jobs
INSERT INTO job_departments (job_id, department_id) VALUES
(1, 1), (1, 2),
(2, 1), (2, 2), (2, 3)
ON DUPLICATE KEY UPDATE department_id = VALUES(department_id);

-- Sample General Notification
INSERT INTO notifications (user_id, title, message, notification_type, is_read) VALUES
(2, 'Campus Placement Season 2026 Commenced', 'Welcome to CPMS! Please verify your profile, upload your latest PDF resume, and review upcoming job drives.', 'GENERAL', FALSE);
