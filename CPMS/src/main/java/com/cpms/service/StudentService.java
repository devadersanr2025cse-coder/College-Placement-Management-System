package com.cpms.service;

import com.cpms.dao.*;
import com.cpms.model.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public class StudentService {

    private final StudentDAO studentDAO;
    private final AcademicUpdateDAO academicUpdateDAO;
    private final JobDAO jobDAO;
    private final ApplicationDAO applicationDAO;
    private final ResumeDAO resumeDAO;
    private final ResumeFeedbackDAO resumeFeedbackDAO;
    private final InterviewDAO interviewDAO;
    private final EligibilityService eligibilityService;
    private final NotificationService notificationService;

    public StudentService() {
        this.studentDAO = new StudentDAO();
        this.academicUpdateDAO = new AcademicUpdateDAO();
        this.jobDAO = new JobDAO();
        this.applicationDAO = new ApplicationDAO();
        this.resumeDAO = new ResumeDAO();
        this.resumeFeedbackDAO = new ResumeFeedbackDAO();
        this.interviewDAO = new InterviewDAO();
        this.eligibilityService = new EligibilityService();
        this.notificationService = new NotificationService();
    }

    public Student getStudentProfile(int userId) {
        if (userId <= 0) return null;
        return studentDAO.findByUserId(userId);
    }

    public Student getStudentById(int studentId) {
        if (studentId <= 0) return null;
        return studentDAO.findById(studentId);
    }

    public boolean updateContactDetails(int userId, String phone, LocalDate dateOfBirth, String address) {
        if (userId <= 0) return false;
        if (phone == null || !phone.matches("[0-9]{10,15}")) return false;
        if (dateOfBirth != null && dateOfBirth.isAfter(LocalDate.now())) return false;
        if (address != null && address.length() > 1000) return false;

        return studentDAO.updateContactDetails(userId, phone, dateOfBirth, address);
    }

    public String submitAcademicUpdate(int studentId, BigDecimal newCgpa, int newBacklogs, String remarks) {
        Student student = studentDAO.findById(studentId);
        if (student == null) {
            return "Student profile not found.";
        }

        if (newCgpa == null || newCgpa.compareTo(BigDecimal.ZERO) < 0 || newCgpa.compareTo(BigDecimal.TEN) > 0) {
            return "CGPA must be a valid number between 0.00 and 10.00.";
        }

        if (newBacklogs < 0) {
            return "Backlog count cannot be negative.";
        }

        if (academicUpdateDAO.hasPendingUpdate(studentId)) {
            return "You already have a pending academic update request under officer review.";
        }

        AcademicUpdate update = new AcademicUpdate();
        update.setStudentId(studentId);
        update.setPreviousCgpa(student.getCgpa());
        update.setSubmittedCgpa(newCgpa);
        update.setPreviousBacklogs(student.getActiveBacklogs());
        update.setSubmittedBacklogs(newBacklogs);
        update.setStudentRemarks(remarks != null ? remarks.trim() : "");

        boolean submitted = academicUpdateDAO.submitUpdate(update);
        if (submitted) {
            // Notify Placement Officers
            notificationService.notifyAllOfficers(
                "New Academic Update Request",
                "Student " + student.getFullName() + " (" + student.getRegisterNumber() + ") submitted academic update: CGPA " + newCgpa + ", Backlogs: " + newBacklogs,
                "ACADEMIC"
            );
            return "SUCCESS";
        }
        return "Failed to submit academic update.";
    }

    public List<AcademicUpdate> getAcademicHistory(int studentId) {
        return academicUpdateDAO.getHistoryByStudent(studentId);
    }

    public List<Job> getAvailableJobs(Student student) {
        List<Job> jobs = jobDAO.getAllJobs(true);
        if (student != null) {
            for (Job job : jobs) {
                EligibilityResult res = eligibilityService.checkEligibility(student, job);
                job.setEligibleForCurrentStudent(res.isEligible());
                job.setEligibilityReason(res.getReasonString());
            }
        }
        return jobs;
    }

    public String applyForJob(int studentId, int jobId, Integer resumeId) {
        Student student = studentDAO.findById(studentId);
        if (student == null) {
            return "Student record not found.";
        }

        Job job = jobDAO.findById(jobId);
        if (job == null) {
            return "Job posting not found.";
        }

        // Check if student has active resume
        if (resumeId == null || resumeId <= 0) {
            Resume activeResume = resumeDAO.getActiveResume(studentId);
            if (activeResume == null) {
                return "You must upload a PDF resume before applying to jobs.";
            }
            resumeId = activeResume.getResumeId();
        }

        // Check for duplicate application
        Application existingApp = applicationDAO.findByStudentAndJob(studentId, jobId);
        if (existingApp != null) {
            if ("WITHDRAWN".equals(existingApp.getApplicationStatus())) {
                // Allow re-applying if previously withdrawn
                boolean statusReset = applicationDAO.updateStatus(existingApp.getApplicationId(), "APPLIED");
                return statusReset ? "SUCCESS" : "Failed to re-activate application.";
            }
            return "You have already applied for this position (Current status: " + existingApp.getApplicationStatus() + ").";
        }

        // Strictly enforce eligibility on verified academic records
        EligibilityResult eligibility = eligibilityService.checkEligibility(student, job);
        if (!eligibility.isEligible()) {
            return "Application rejected: You are not eligible for this role. " + eligibility.getReasonString();
        }

        boolean applied = applicationDAO.apply(studentId, jobId, resumeId);
        if (applied) {
            // Notify Student
            if (student.getUserId() != null) {
                notificationService.notifyUser(
                    student.getUserId(),
                    "Application Submitted",
                    "Your application for " + job.getJobTitle() + " at " + job.getCompanyName() + " was submitted successfully.",
                    "APPLICATION"
                );
            }

            // Notify Placement Officer
            notificationService.notifyAllOfficers(
                "New Job Application",
                student.getFullName() + " applied for " + job.getJobTitle() + " at " + job.getCompanyName(),
                "APPLICATION"
            );

            return "SUCCESS";
        }

        return "Failed to submit application.";
    }

    public boolean withdrawApplication(int applicationId, int studentId) {
        boolean withdrawn = applicationDAO.withdraw(applicationId, studentId);
        if (withdrawn) {
            Student s = studentDAO.findById(studentId);
            if (s != null && s.getUserId() != null) {
                notificationService.notifyUser(s.getUserId(), "Application Withdrawn",
                    "You have successfully withdrawn your application.", "APPLICATION");
            }
        }
        return withdrawn;
    }

    public List<Application> getStudentApplications(int studentId) {
        return applicationDAO.getApplicationsByStudent(studentId);
    }

    public List<Interview> getStudentInterviews(int studentId) {
        return interviewDAO.getInterviewsByStudent(studentId);
    }

    public boolean saveUploadedResume(int studentId, String fileName, String filePath) {
        int resumeId = resumeDAO.saveResume(studentId, fileName, filePath);
        if (resumeId > 0) {
            Student s = studentDAO.findById(studentId);
            if (s != null) {
                notificationService.notifyAllOfficers(
                    "Resume Uploaded",
                    "Student " + s.getFullName() + " (" + s.getRegisterNumber() + ") uploaded a new resume.",
                    "RESUME"
                );
            }
            return true;
        }
        return false;
    }

    public Resume getActiveResume(int studentId) {
        return resumeDAO.getActiveResume(studentId);
    }

    public List<ResumeFeedback> getResumeFeedbacks(int studentId) {
        return resumeFeedbackDAO.getFeedbacksByStudent(studentId);
    }
}
