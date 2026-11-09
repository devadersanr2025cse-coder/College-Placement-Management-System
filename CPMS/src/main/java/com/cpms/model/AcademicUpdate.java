package com.cpms.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class AcademicUpdate {
    private int updateId;
    private int studentId;
    private BigDecimal previousCgpa;
    private BigDecimal submittedCgpa;
    private int previousBacklogs;
    private int submittedBacklogs;
    private String status; // PENDING, APPROVED, REJECTED
    private String studentRemarks;
    private Integer reviewedBy;
    private Timestamp reviewDate;
    private String officerRemarks;
    private Timestamp submittedAt;

    // Joined fields
    private String studentName;
    private String registerNumber;
    private String departmentName;
    private String officerName;

    public AcademicUpdate() {
        this.status = "PENDING";
    }

    public int getUpdateId() {
        return updateId;
    }

    public void setUpdateId(int updateId) {
        this.updateId = updateId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public BigDecimal getPreviousCgpa() {
        return previousCgpa;
    }

    public void setPreviousCgpa(BigDecimal previousCgpa) {
        this.previousCgpa = previousCgpa;
    }

    public BigDecimal getSubmittedCgpa() {
        return submittedCgpa;
    }

    public void setSubmittedCgpa(BigDecimal submittedCgpa) {
        this.submittedCgpa = submittedCgpa;
    }

    public int getPreviousBacklogs() {
        return previousBacklogs;
    }

    public void setPreviousBacklogs(int previousBacklogs) {
        this.previousBacklogs = previousBacklogs;
    }

    public int getSubmittedBacklogs() {
        return submittedBacklogs;
    }

    public void setSubmittedBacklogs(int submittedBacklogs) {
        this.submittedBacklogs = submittedBacklogs;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStudentRemarks() {
        return studentRemarks;
    }

    public void setStudentRemarks(String studentRemarks) {
        this.studentRemarks = studentRemarks;
    }

    public Integer getReviewedBy() {
        return reviewedBy;
    }

    public void setReviewedBy(Integer reviewedBy) {
        this.reviewedBy = reviewedBy;
    }

    public Timestamp getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Timestamp reviewDate) {
        this.reviewDate = reviewDate;
    }

    public String getOfficerRemarks() {
        return officerRemarks;
    }

    public void setOfficerRemarks(String officerRemarks) {
        this.officerRemarks = officerRemarks;
    }

    public Timestamp getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(Timestamp submittedAt) {
        this.submittedAt = submittedAt;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getRegisterNumber() {
        return registerNumber;
    }

    public void setRegisterNumber(String registerNumber) {
        this.registerNumber = registerNumber;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public String getOfficerName() {
        return officerName;
    }

    public void setOfficerName(String officerName) {
        this.officerName = officerName;
    }
}

