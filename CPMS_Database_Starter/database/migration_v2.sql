-- Migration script to upgrade CPMS database schema to support 3 roles and complete placement workflow
USE cpms;

-- 1. Update users table role enum to include RECRUITER
ALTER TABLE users MODIFY COLUMN role ENUM('STUDENT','OFFICER','RECRUITER') NOT NULL;

-- 2. Allow user_id in students to be NULL for pre-seeded academic records
ALTER TABLE students MODIFY COLUMN user_id INT NULL UNIQUE;

-- 3. Add is_active and description to companies if not present
ALTER TABLE companies ADD COLUMN IF NOT EXISTS description TEXT AFTER industry;
ALTER TABLE companies ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT TRUE AFTER contact_phone;

-- 4. Create recruiters table
CREATE TABLE IF NOT EXISTS recruiters (
  recruiter_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL UNIQUE,
  company_id INT NOT NULL,
  designation VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. Create academic_updates table for CGPA / Backlog update workflow
CREATE TABLE IF NOT EXISTS academic_updates (
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

-- 6. Create resume_feedbacks table
CREATE TABLE IF NOT EXISTS resume_feedbacks (
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

-- 7. Create messages table for officer-student communication and announcements
CREATE TABLE IF NOT EXISTS messages (
  message_id INT AUTO_INCREMENT PRIMARY KEY,
  sender_id INT NOT NULL,
  receiver_id INT NULL, -- NULL indicates broadcast to all students
  subject VARCHAR(200) NOT NULL,
  content TEXT NOT NULL,
  category ENUM('GENERAL','ACADEMIC','RESUME','PROFILE','ADVICE','ANNOUNCEMENT') NOT NULL DEFAULT 'GENERAL',
  is_read BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (receiver_id) REFERENCES users(user_id) ON DELETE CASCADE,
  INDEX idx_message_receiver (receiver_id, is_read, created_at)
) ENGINE=InnoDB;

