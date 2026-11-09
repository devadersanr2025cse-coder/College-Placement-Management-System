package com.cpms.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Job {
    private int jobId;
    private int companyId;
    private int postedBy;
    private String jobTitle;
    private String jobDescription;
    private String jobType; // FULL_TIME, INTERNSHIP, CONTRACT
    private String location;
    private BigDecimal minCgpa;
    private int maxBacklogs;
    private BigDecimal packageLpa;
    private Timestamp applicationDeadline;
    private String jobStatus; // DRAFT, OPEN, CLOSED
    private Timestamp createdAt;

    // Joined fields
    private String companyName;
    private String companyWebsite;
    private String companyIndustry;
    private String postedByName;
    private List<Integer> departmentIds = new ArrayList<>();
    private List<String> departmentNames = new ArrayList<>();
    private int applicantCount;
    private boolean eligibleForCurrentStudent;
    private String eligibilityReason;

    public Job() {
        this.jobType = "FULL_TIME";
        this.jobStatus = "OPEN";
        this.minCgpa = BigDecimal.ZERO;
        this.maxBacklogs = 0;
    }

    public int getJobId() {
        return jobId;
    }

    public void setJobId(int jobId) {
        this.jobId = jobId;
    }

    public int getCompanyId() {
        return companyId;
    }

    public void setCompanyId(int companyId) {
        this.companyId = companyId;
    }

    public int getPostedBy() {
        return postedBy;
    }

    public void setPostedBy(int postedBy) {
        this.postedBy = postedBy;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getJobDescription() {
        return jobDescription;
    }

    public void setJobDescription(String jobDescription) {
        this.jobDescription = jobDescription;
    }

    public String getJobType() {
        return jobType;
    }

    public void setJobType(String jobType) {
        this.jobType = jobType;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public BigDecimal getMinCgpa() {
        return minCgpa;
    }

    public void setMinCgpa(BigDecimal minCgpa) {
        this.minCgpa = minCgpa;
    }

    public int getMaxBacklogs() {
        return maxBacklogs;
    }

    public void setMaxBacklogs(int maxBacklogs) {
        this.maxBacklogs = maxBacklogs;
    }

    public BigDecimal getPackageLpa() {
        return packageLpa;
    }

    public void setPackageLpa(BigDecimal packageLpa) {
        this.packageLpa = packageLpa;
    }

    public Timestamp getApplicationDeadline() {
        return applicationDeadline;
    }

    public void setApplicationDeadline(Timestamp applicationDeadline) {
        this.applicationDeadline = applicationDeadline;
    }

    public String getJobStatus() {
        return jobStatus;
    }

    public void setJobStatus(String jobStatus) {
        this.jobStatus = jobStatus;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getCompanyWebsite() {
        return companyWebsite;
    }

    public void setCompanyWebsite(String companyWebsite) {
        this.companyWebsite = companyWebsite;
    }

    public String getCompanyIndustry() {
        return companyIndustry;
    }

    public void setCompanyIndustry(String companyIndustry) {
        this.companyIndustry = companyIndustry;
    }

    public String getPostedByName() {
        return postedByName;
    }

    public void setPostedByName(String postedByName) {
        this.postedByName = postedByName;
    }

    public List<Integer> getDepartmentIds() {
        return departmentIds;
    }

    public void setDepartmentIds(List<Integer> departmentIds) {
        this.departmentIds = departmentIds;
    }

    public List<String> getDepartmentNames() {
        return departmentNames;
    }

    public void setDepartmentNames(List<String> departmentNames) {
        this.departmentNames = departmentNames;
    }

    public String getDepartmentNamesString() {
        if (departmentNames == null || departmentNames.isEmpty()) {
            return "All Departments";
        }
        return String.join(", ", departmentNames);
    }

    public int getApplicantCount() {
        return applicantCount;
    }

    public void setApplicantCount(int applicantCount) {
        this.applicantCount = applicantCount;
    }

    public boolean isEligibleForCurrentStudent() {
        return eligibleForCurrentStudent;
    }

    public void setEligibleForCurrentStudent(boolean eligibleForCurrentStudent) {
        this.eligibleForCurrentStudent = eligibleForCurrentStudent;
    }

    public String getEligibilityReason() {
        return eligibilityReason;
    }

    public void setEligibilityReason(String eligibilityReason) {
        this.eligibilityReason = eligibilityReason;
    }
}

