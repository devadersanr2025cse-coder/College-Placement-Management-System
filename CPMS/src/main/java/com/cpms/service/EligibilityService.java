package com.cpms.service;

import com.cpms.dao.JobDAO;
import com.cpms.model.EligibilityResult;
import com.cpms.model.Job;
import com.cpms.model.Student;

import java.math.BigDecimal;
import java.util.List;

public class EligibilityService {

    private final JobDAO jobDAO;

    public EligibilityService() {
        this.jobDAO = new JobDAO();
    }

    public EligibilityResult checkEligibility(Student student, Job job) {
        EligibilityResult result = new EligibilityResult();

        if (student == null) {
            result.addReason("Student record not found.");
            return result;
        }

        if (job == null) {
            result.addReason("Job posting not found.");
            return result;
        }

        // 1. Check job status
        if (!"OPEN".equalsIgnoreCase(job.getJobStatus())) {
            result.addReason("Job posting is closed.");
        }

        // 2. Check application deadline
        if (job.getApplicationDeadline() != null &&
            job.getApplicationDeadline().before(new java.util.Date())) {
            result.addReason("Application deadline has passed.");
        }

        // 3. Check CGPA (Strictly using verified student CGPA)
        BigDecimal studentCgpa = student.getCgpa() != null ? student.getCgpa() : BigDecimal.ZERO;
        BigDecimal minCgpa = job.getMinCgpa() != null ? job.getMinCgpa() : BigDecimal.ZERO;

        if (studentCgpa.compareTo(minCgpa) < 0) {
            result.addReason("CGPA requirement not met (Required: " + minCgpa + ", Yours: " + studentCgpa + ").");
        }

        // 4. Check active backlogs (Strictly using verified student backlogs)
        int studentBacklogs = student.getActiveBacklogs();
        int maxBacklogs = job.getMaxBacklogs();

        if (studentBacklogs > maxBacklogs) {
            result.addReason("Backlog limit exceeded (Maximum allowed: " + maxBacklogs + ", Yours: " + studentBacklogs + ").");
        }

        // 5. Check eligible departments
        List<Integer> allowedDeptIds = job.getDepartmentIds();
        if (allowedDeptIds == null || allowedDeptIds.isEmpty()) {
            allowedDeptIds = jobDAO.getDepartmentIdsForJob(job.getJobId());
        }

        if (allowedDeptIds != null && !allowedDeptIds.isEmpty()) {
            if (!allowedDeptIds.contains(student.getDepartmentId())) {
                result.addReason("Your department (" + (student.getDepartmentCode() != null ? student.getDepartmentCode() : "Dept ID " + student.getDepartmentId()) +
                                 ") is not eligible for this role.");
            }
        }

        return result;
    }
}

