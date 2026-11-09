CREATE DATABASE IF NOT EXISTS cpms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cpms;

-- WARNING: destructive reset of CPMS objects.
DROP VIEW IF EXISTS v_student_placement_summary;
DROP VIEW IF EXISTS v_job_application_summary;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS messages, resume_feedbacks, academic_updates, recruiters,
 report_history, notifications, offers, interviews, applications,
 eligibility_checks, resumes, job_departments, jobs, companies, placement_officers,
 students, departments, users;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(120) NOT NULL,
  email VARCHAR(160) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('STUDENT','OFFICER','RECRUITER') NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE departments (
  department_id INT AUTO_INCREMENT PRIMARY KEY,
  department_name VARCHAR(100) NOT NULL UNIQUE,
  department_code VARCHAR(15) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE students (
  student_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NULL UNIQUE,
  register_number VARCHAR(30) NOT NULL UNIQUE,
  department_id INT NOT NULL,
  batch_year YEAR NOT NULL,
  cgpa DECIMAL(4,2) NOT NULL,
  active_backlogs INT NOT NULL DEFAULT 0,
  phone VARCHAR(20),
  date_of_birth DATE,
  address TEXT,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
  FOREIGN KEY (department_id) REFERENCES departments(department_id),
  CHECK (cgpa BETWEEN 0 AND 10),
  CHECK (active_backlogs >= 0)
) ENGINE=InnoDB;

CREATE TABLE placement_officers (
  officer_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL UNIQUE,
  employee_code VARCHAR(30) NOT NULL UNIQUE,
  designation VARCHAR(100),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE companies (
  company_id INT AUTO_INCREMENT PRIMARY KEY,
  company_name VARCHAR(160) NOT NULL,
  website VARCHAR(255),
  industry VARCHAR(100),
  description TEXT,
  contact_person VARCHAR(120),
  contact_email VARCHAR(160),
  contact_phone VARCHAR(25),
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE recruiters (
  recruiter_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL UNIQUE,
  company_id INT NOT NULL,
  designation VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE jobs (
  job_id INT AUTO_INCREMENT PRIMARY KEY,
  company_id INT NOT NULL,
  posted_by INT NOT NULL,
  job_title VARCHAR(160) NOT NULL,
  job_description TEXT,
  job_type ENUM('FULL_TIME','INTERNSHIP','CONTRACT') NOT NULL DEFAULT 'FULL_TIME',
  location VARCHAR(160),
  min_cgpa DECIMAL(4,2) NOT NULL DEFAULT 0,
  max_backlogs INT NOT NULL DEFAULT 0,
  package_lpa DECIMAL(8,2),
  application_deadline DATETIME,
  job_status ENUM('DRAFT','OPEN','CLOSED') NOT NULL DEFAULT 'OPEN',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE,
  FOREIGN KEY (posted_by) REFERENCES placement_officers(officer_id),
  CHECK (min_cgpa BETWEEN 0 AND 10),
  CHECK (max_backlogs >= 0)
) ENGINE=InnoDB;

CREATE TABLE job_departments (
  job_id INT NOT NULL,
  department_id INT NOT NULL,
  PRIMARY KEY (job_id, department_id),
  FOREIGN KEY (job_id) REFERENCES jobs(job_id) ON DELETE CASCADE,
  FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE resumes (
  resume_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  file_name VARCHAR(255) NOT NULL,
  file_path VARCHAR(500) NOT NULL,
  uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE eligibility_checks (
  check_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  job_id INT NOT NULL,
  is_eligible BOOLEAN NOT NULL,
  reason VARCHAR(500),
  checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  FOREIGN KEY (job_id) REFERENCES jobs(job_id) ON DELETE CASCADE,
  INDEX idx_eligibility_student_job (student_id, job_id)
) ENGINE=InnoDB;

CREATE TABLE applications (
  application_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  job_id INT NOT NULL,
  resume_id INT,
  application_status ENUM('APPLIED','UNDER_REVIEW','SHORTLISTED','REJECTED','SELECTED','WITHDRAWN') NOT NULL DEFAULT 'APPLIED',
  applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_student_job (student_id, job_id),
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  FOREIGN KEY (job_id) REFERENCES jobs(job_id) ON DELETE CASCADE,
  FOREIGN KEY (resume_id) REFERENCES resumes(resume_id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE interviews (
  interview_id INT AUTO_INCREMENT PRIMARY KEY,
  application_id INT NOT NULL,
  round_number INT NOT NULL,
  interview_datetime DATETIME NOT NULL,
  mode ENUM('ONLINE','OFFLINE') NOT NULL,
  meeting_or_venue VARCHAR(500),
  scheduled_by INT NOT NULL,
  result ENUM('PENDING','PASSED','FAILED') NOT NULL DEFAULT 'PENDING',
  notes TEXT,
  UNIQUE KEY uq_application_round (application_id, round_number),
  FOREIGN KEY (application_id) REFERENCES applications(application_id) ON DELETE CASCADE,
  FOREIGN KEY (scheduled_by) REFERENCES placement_officers(officer_id),
  CHECK (round_number > 0)
) ENGINE=InnoDB;

CREATE TABLE offers (
  offer_id INT AUTO_INCREMENT PRIMARY KEY,
  application_id INT NOT NULL UNIQUE,
  package_lpa DECIMAL(8,2),
  offer_date DATE NOT NULL,
  offer_status ENUM('PENDING','ACCEPTED','DECLINED','REVOKED') NOT NULL DEFAULT 'PENDING',
  FOREIGN KEY (application_id) REFERENCES applications(application_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE academic_updates (
  update_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  previous_cgpa DECIMAL(4,2) NOT NULL,
  submitted_cgpa DECIMAL(4,2) NOT NULL,
  previous_backlogs INT NOT NULL,
  submitted_backlogs INT NOT NULL,
  status ENUM('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING',
  student_remarks TEXT,
  reviewed_by INT NULL,
  review_date DATETIME NULL,
  officer_remarks TEXT NULL,
  submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  FOREIGN KEY (reviewed_by) REFERENCES placement_officers(officer_id) ON DELETE SET NULL,
  CHECK (submitted_cgpa BETWEEN 0 AND 10),
  CHECK (submitted_backlogs >= 0)
) ENGINE=InnoDB;

CREATE TABLE resume_feedbacks (
  feedback_id INT AUTO_INCREMENT PRIMARY KEY,
  resume_id INT NOT NULL,
  student_id INT NOT NULL,
  officer_id INT NOT NULL,
  feedback_type ENUM('SUGGESTION','CORRECTION','APPROVAL','REJECTION') NOT NULL DEFAULT 'SUGGESTION',
  comments TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (resume_id) REFERENCES resumes(resume_id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  FOREIGN KEY (officer_id) REFERENCES placement_officers(officer_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE messages (
  message_id INT AUTO_INCREMENT PRIMARY KEY,
  sender_id INT NOT NULL,
  receiver_id INT NULL,
  subject VARCHAR(200) NOT NULL,
  content TEXT NOT NULL,
  category ENUM('GENERAL','ACADEMIC','RESUME','PROFILE','ADVICE','ANNOUNCEMENT') NOT NULL DEFAULT 'GENERAL',
  is_read BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (receiver_id) REFERENCES users(user_id) ON DELETE CASCADE,
  INDEX idx_message_receiver (receiver_id, is_read, created_at)
) ENGINE=InnoDB;

CREATE TABLE notifications (
  notification_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  title VARCHAR(180) NOT NULL,
  message TEXT NOT NULL,
  notification_type ENUM('GENERAL','APPLICATION','INTERVIEW','OFFER','ACADEMIC','RESUME','SYSTEM') NOT NULL DEFAULT 'GENERAL',
  is_read BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  INDEX idx_notification_user_read (user_id, is_read, created_at)
) ENGINE=InnoDB;

CREATE TABLE report_history (
  report_id INT AUTO_INCREMENT PRIMARY KEY,
  generated_by INT NOT NULL,
  report_type VARCHAR(100) NOT NULL,
  report_format ENUM('PDF','EXCEL') NOT NULL,
  file_path VARCHAR(500),
  generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (generated_by) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE OR REPLACE VIEW v_student_placement_summary AS
SELECT s.student_id, u.full_name, s.register_number, d.department_name,
       s.batch_year, s.cgpa, s.active_backlogs,
       COUNT(DISTINCT a.application_id) AS total_applications,
       SUM(CASE WHEN a.application_status = 'SELECTED' THEN 1 ELSE 0 END) AS selections
FROM students s
LEFT JOIN users u ON u.user_id = s.user_id
JOIN departments d ON d.department_id = s.department_id
LEFT JOIN applications a ON a.student_id = s.student_id
GROUP BY s.student_id, u.full_name, s.register_number, d.department_name, s.batch_year, s.cgpa, s.active_backlogs;

CREATE OR REPLACE VIEW v_job_application_summary AS
SELECT j.job_id, j.job_title, c.company_name, j.package_lpa, j.job_status,
       COUNT(a.application_id) AS application_count,
       SUM(CASE WHEN a.application_status = 'SELECTED' THEN 1 ELSE 0 END) AS selected_count
FROM jobs j
JOIN companies c ON c.company_id = j.company_id
LEFT JOIN applications a ON a.job_id = j.job_id
GROUP BY j.job_id, j.job_title, c.company_name, j.package_lpa, j.job_status;
