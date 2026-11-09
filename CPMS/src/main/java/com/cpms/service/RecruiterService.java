package com.cpms.service;

import com.cpms.dao.*;
import com.cpms.model.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RecruiterService {

    private final RecruiterDAO recruiterDAO;
    private final CompanyDAO companyDAO;
    private final JobDAO jobDAO;
    private final ApplicationDAO applicationDAO;
    private final InterviewDAO interviewDAO;
    private final StudentDAO studentDAO;
    private final NotificationService notificationService;

    public RecruiterService() {
        this.recruiterDAO = new RecruiterDAO();
        this.companyDAO = new CompanyDAO();
        this.jobDAO = new JobDAO();
        this.applicationDAO = new ApplicationDAO();
        this.interviewDAO = new InterviewDAO();
        this.studentDAO = new StudentDAO();
        this.notificationService = new NotificationService();
    }

    public Recruiter getRecruiterByUserId(int userId) {
        return recruiterDAO.findByUserId(userId);
    }

    public Company getCompanyProfile(int companyId) {
        return companyDAO.findById(companyId);
    }

    public boolean updateCompanyProfile(Company company, int authorizedCompanyId) {
        if (company.getCompanyId() != authorizedCompanyId) {
            return false; // Prevent unauthorized cross-company modification
        }
        return companyDAO.updateCompany(company);
    }

    public Map<String, Object> getRecruiterDashboardMetrics(int companyId) {
        Map<String, Object> stats = new HashMap<>();
        List<Job> jobs = jobDAO.getJobsByCompany(companyId);
        List<Application> applicants = applicationDAO.getApplicationsByCompany(companyId);

        int activeJobs = 0;
        for (Job j : jobs) {
            if ("OPEN".equals(j.getJobStatus())) {
                activeJobs++;
            }
        }

        int totalApplicants = applicants.size();
        int shortlistedCount = 0;
        int selectedCount = 0;

        for (Application a : applicants) {
            if ("SHORTLISTED".equalsIgnoreCase(a.getApplicationStatus())) {
                shortlistedCount++;
            } else if ("SELECTED".equalsIgnoreCase(a.getApplicationStatus())) {
                selectedCount++;
            }
        }

        List<Interview> interviews = interviewDAO.getInterviewsByCompany(companyId);

        stats.put("totalJobs", jobs.size());
        stats.put("activeJobs", activeJobs);
        stats.put("totalApplicants", totalApplicants);
        stats.put("shortlistedCount", shortlistedCount);
        stats.put("selectedCount", selectedCount);
        stats.put("interviewCount", interviews.size());

        return stats;
    }

    public List<Job> getCompanyJobs(int companyId) {
        return jobDAO.getJobsByCompany(companyId);
    }

    public Job getCompanyJobById(int jobId, int companyId) {
        Job job = jobDAO.findById(jobId);
        if (job != null && job.getCompanyId() == companyId) {
            return job;
        }
        return null; // Prevent cross-company job access
    }

    public boolean postJob(Job job, List<Integer> departmentIds, int companyId, int officerId) {
        job.setCompanyId(companyId);
        job.setPostedBy(officerId); // Link to managing placement officer or system officer
        int jobId = jobDAO.createJob(job, departmentIds);
        return jobId > 0;
    }

    public List<Application> getApplicantsForCompany(int companyId) {
        return applicationDAO.getApplicationsByCompany(companyId);
    }

    public Student getCandidateProfileForRecruiter(int studentId, int companyId) {
        // Enforce access control: candidate must have applied to at least one job of this company
        List<Application> companyApps = applicationDAO.getApplicationsByCompany(companyId);
        boolean appliedToCompany = companyApps.stream().anyMatch(a -> a.getStudentId() == studentId);

        if (!appliedToCompany) {
            return null; // Deny unauthorized browsing of candidates
        }

        Student student = studentDAO.findById(studentId);
        if (student != null) {
            // Strictly hide pending or unverified academic updates from recruiters!
            student.setHasPendingUpdate(false);
            student.setPendingCgpa(null);
            student.setPendingBacklogs(null);
        }
        return student;
    }

    public boolean updateCandidateStatus(int applicationId, int authorizedCompanyId, String newStatus) {
        Application app = applicationDAO.findById(applicationId);
        if (app == null) return false;

        // Verify application belongs to this company
        Job job = jobDAO.findById(app.getJobId());
        if (job == null || job.getCompanyId() != authorizedCompanyId) {
            return false; // Unauthorized access attempt
        }

        boolean updated = applicationDAO.updateStatus(applicationId, newStatus);
        if (updated) {
            Student student = studentDAO.findById(app.getStudentId());
            if (student != null && student.getUserId() != null) {
                notificationService.notifyUser(
                    student.getUserId(),
                    "Application Update: " + job.getCompanyName(),
                    "Your application for " + job.getJobTitle() + " has been updated to: " + newStatus.replace('_', ' ') + ".",
                    "APPLICATION"
                );
            }
        }
        return updated;
    }

    public List<Interview> getCompanyInterviews(int companyId) {
        return interviewDAO.getInterviewsByCompany(companyId);
    }
}

