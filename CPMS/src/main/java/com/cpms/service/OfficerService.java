package com.cpms.service;

import com.cpms.dao.*;
import com.cpms.model.*;

import java.util.List;
import java.util.Map;

public class OfficerService {

    private final StudentDAO studentDAO;
    private final AcademicUpdateDAO academicUpdateDAO;
    private final CompanyDAO companyDAO;
    private final JobDAO jobDAO;
    private final ApplicationDAO applicationDAO;
    private final InterviewDAO interviewDAO;
    private final ResumeDAO resumeDAO;
    private final ResumeFeedbackDAO resumeFeedbackDAO;
    private final MessageDAO messageDAO;
    private final PlacementOfficerDAO officerDAO;
    private final ReportDAO reportDAO;
    private final NotificationService notificationService;

    public OfficerService() {
        this.studentDAO = new StudentDAO();
        this.academicUpdateDAO = new AcademicUpdateDAO();
        this.companyDAO = new CompanyDAO();
        this.jobDAO = new JobDAO();
        this.applicationDAO = new ApplicationDAO();
        this.interviewDAO = new InterviewDAO();
        this.resumeDAO = new ResumeDAO();
        this.resumeFeedbackDAO = new ResumeFeedbackDAO();
        this.messageDAO = new MessageDAO();
        this.officerDAO = new PlacementOfficerDAO();
        this.reportDAO = new ReportDAO();
        this.notificationService = new NotificationService();
    }

    public PlacementOfficer getOfficerByUserId(int userId) {
        return officerDAO.findByUserId(userId);
    }

    public Map<String, Object> getDashboardMetrics() {
        return reportDAO.getOverallPlacementStats();
    }

    public List<Student> searchStudents(String query, Integer deptId, Integer batchYear) {
        return studentDAO.searchStudents(query, deptId, batchYear);
    }

    public Student getStudentDetails(int studentId) {
        return studentDAO.findById(studentId);
    }

    public List<AcademicUpdate> getPendingAcademicUpdates() {
        return academicUpdateDAO.getPendingUpdates();
    }

    public boolean reviewAcademicUpdate(int updateId, int officerId, String status, String remarks) {
        AcademicUpdate update = academicUpdateDAO.findById(updateId);
        if (update == null) return false;

        boolean reviewed = academicUpdateDAO.reviewUpdate(updateId, officerId, status, remarks);
        if (reviewed) {
            Student student = studentDAO.findById(update.getStudentId());
            if (student != null && student.getUserId() != null) {
                String title = "Academic Update " + status;
                String msg = "Your request to update CGPA to " + update.getSubmittedCgpa() +
                             " and backlogs to " + update.getSubmittedBacklogs() +
                             " was " + status.toLowerCase() + " by the placement cell." +
                             (remarks != null && !remarks.isBlank() ? " Remarks: " + remarks : "");

                notificationService.notifyUser(student.getUserId(), title, msg, "ACADEMIC");
            }
        }
        return reviewed;
    }

    public List<Company> getAllCompanies() {
        return companyDAO.getAllCompanies();
    }

    public Company getCompanyById(int companyId) {
        return companyDAO.findById(companyId);
    }

    public boolean saveCompany(Company company) {
        if (company.getCompanyId() > 0) {
            return companyDAO.updateCompany(company);
        } else {
            return companyDAO.createCompany(company) > 0;
        }
    }

    public boolean toggleCompanyStatus(int companyId, boolean active) {
        return companyDAO.toggleStatus(companyId, active);
    }

    public List<Job> getAllJobs() {
        return jobDAO.getAllJobs(false);
    }

    public Job getJobById(int jobId) {
        return jobDAO.findById(jobId);
    }

    public boolean saveJob(Job job, List<Integer> departmentIds) {
        if (job.getJobId() > 0) {
            return jobDAO.updateJob(job, departmentIds);
        } else {
            int jobId = jobDAO.createJob(job, departmentIds);
            if (jobId > 0) {
                // Broadcast notification to all students
                notificationService.notifyAllStudents(
                    "New Job Drive Announced: " + job.getJobTitle(),
                    job.getCompanyName() + " is hiring for " + job.getJobTitle() +
                    (job.getPackageLpa() != null ? " with package " + job.getPackageLpa() + " LPA." : ".") +
                    " Check eligibility and apply now!",
                    "APPLICATION"
                );
                return true;
            }
            return false;
        }
    }

    public boolean closeJob(int jobId) {
        return jobDAO.setJobStatus(jobId, "CLOSED");
    }

    public List<Application> getJobApplicants(int jobId) {
        return applicationDAO.getApplicationsByJob(jobId);
    }

    public boolean updateApplicantStatus(int applicationId, String status, int officerId) {
        boolean updated = applicationDAO.updateStatus(applicationId, status);
        if (updated) {
            Application app = applicationDAO.findById(applicationId);
            if (app != null) {
                Student student = studentDAO.findById(app.getStudentId());
                if (student != null && student.getUserId() != null) {
                    notificationService.notifyUser(
                        student.getUserId(),
                        "Application Status Updated",
                        "Your application for " + app.getJobTitle() + " at " + app.getCompanyName() +
                        " is now: " + status.replace('_', ' ') + ".",
                        "APPLICATION"
                    );
                }
            }
        }
        return updated;
    }

    public boolean scheduleInterview(Interview interview, int officerId) {
        interview.setScheduledBy(officerId);
        boolean scheduled = interviewDAO.scheduleInterview(interview);
        if (scheduled) {
            Application app = applicationDAO.findById(interview.getApplicationId());
            if (app != null) {
                Student student = studentDAO.findById(app.getStudentId());
                if (student != null && student.getUserId() != null) {
                    notificationService.notifyUser(
                        student.getUserId(),
                        "Interview Scheduled: Round " + interview.getRoundNumber(),
                        "Interview scheduled for " + app.getJobTitle() + " at " + app.getCompanyName() +
                        " on " + interview.getInterviewDatetime() + " (" + interview.getMode() + " - " + interview.getMeetingOrVenue() + ").",
                        "INTERVIEW"
                    );
                }
                // Also update application status to SHORTLISTED or UNDER_REVIEW if currently APPLIED
                if ("APPLIED".equals(app.getApplicationStatus())) {
                    applicationDAO.updateStatus(app.getApplicationId(), "SHORTLISTED");
                }
            }
        }
        return scheduled;
    }

    public boolean recordInterviewResult(int interviewId, String result, String notes) {
        boolean updated = interviewDAO.updateInterviewResult(interviewId, result, notes);
        if (updated) {
            Interview iv = interviewDAO.findById(interviewId);
            if (iv != null && iv.getStudentId() > 0) {
                Student student = studentDAO.findById(iv.getStudentId());
                if (student != null && student.getUserId() != null) {
                    notificationService.notifyUser(
                        student.getUserId(),
                        "Interview Result Released: Round " + iv.getRoundNumber(),
                        "Result for " + iv.getJobTitle() + " (Round " + iv.getRoundNumber() + "): " + result +
                        (notes != null && !notes.isBlank() ? ". Remarks: " + notes : ""),
                        "INTERVIEW"
                    );
                }

                // If PASSED on final round or marked PASSED, update application status if appropriate
                if ("PASSED".equals(result)) {
                    applicationDAO.updateStatus(iv.getApplicationId(), "SHORTLISTED");
                } else if ("FAILED".equals(result)) {
                    applicationDAO.updateStatus(iv.getApplicationId(), "REJECTED");
                }
            }
        }
        return updated;
    }

    public boolean addResumeFeedback(int resumeId, int studentId, int officerId, String feedbackType, String comments) {
        ResumeFeedback f = new ResumeFeedback();
        f.setResumeId(resumeId);
        f.setStudentId(studentId);
        f.setOfficerId(officerId);
        f.setFeedbackType(feedbackType);
        f.setComments(comments);

        boolean added = resumeFeedbackDAO.addFeedback(f);
        if (added) {
            Student student = studentDAO.findById(studentId);
            if (student != null && student.getUserId() != null) {
                notificationService.notifyUser(
                    student.getUserId(),
                    "Resume Feedback from Placement Cell",
                    "The placement officer provided feedback on your resume: " + comments,
                    "RESUME"
                );
            }
        }
        return added;
    }

    public boolean sendStudentMessage(int senderId, Integer receiverId, String subject, String content, String category) {
        Message m = new Message();
        m.setSenderId(senderId);
        m.setReceiverId(receiverId);
        m.setSubject(subject);
        m.setContent(content);
        m.setCategory(category != null ? category : "GENERAL");

        boolean sent = messageDAO.sendMessage(m);
        if (sent) {
            if (receiverId != null && receiverId > 0) {
                notificationService.notifyUser(
                    receiverId,
                    "New Message from Placement Cell: " + subject,
                    content.length() > 100 ? content.substring(0, 97) + "..." : content,
                    "GENERAL"
                );
            } else {
                notificationService.notifyAllStudents(
                    "Placement Announcement: " + subject,
                    content.length() > 100 ? content.substring(0, 97) + "..." : content,
                    "GENERAL"
                );
            }
        }
        return sent;
    }

    public List<Map<String, Object>> getDepartmentPlacementStats() {
        return reportDAO.getDepartmentWisePlacementStats();
    }

    public List<Map<String, Object>> getCompanyPlacements() {
        return reportDAO.getCompanyWisePlacements();
    }

    public List<Interview> getUpcomingInterviews(int limit) {
        return interviewDAO.getUpcomingInterviews(limit);
    }
}

