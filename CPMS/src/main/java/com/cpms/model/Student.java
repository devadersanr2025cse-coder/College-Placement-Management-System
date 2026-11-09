package com.cpms.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class Student {

    private int studentId;
    private Integer userId;
    private String registerNumber;
    private int departmentId;
    private int batchYear;
    private BigDecimal cgpa;
    private int activeBacklogs;
    private String phone;
    private LocalDate dateOfBirth;
    private String address;

    // Joined fields
    private String fullName;
    private String email;
    private String departmentName;
    private String departmentCode;
    private boolean activeUser;

    // Academic update status
    private boolean hasPendingUpdate;
    private BigDecimal pendingCgpa;
    private Integer pendingBacklogs;

    // Resume info
    private Integer activeResumeId;
    private String resumeFileName;
    private String resumeFilePath;

    public Student() {
    }

    public Student(int studentId, Integer userId, String registerNumber,
                   int departmentId, int batchYear, BigDecimal cgpa,
                   int activeBacklogs, String phone,
                   LocalDate dateOfBirth, String address) {
        this.studentId = studentId;
        this.userId = userId;
        this.registerNumber = registerNumber;
        this.departmentId = departmentId;
        this.batchYear = batchYear;
        this.cgpa = cgpa;
        this.activeBacklogs = activeBacklogs;
        this.phone = phone;
        this.dateOfBirth = dateOfBirth;
        this.address = address;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getRegisterNumber() {
        return registerNumber;
    }

    public void setRegisterNumber(String registerNumber) {
        this.registerNumber = registerNumber;
    }

    public int getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(int departmentId) {
        this.departmentId = departmentId;
    }

    public int getBatchYear() {
        return batchYear;
    }

    public void setBatchYear(int batchYear) {
        this.batchYear = batchYear;
    }

    public BigDecimal getCgpa() {
        return cgpa;
    }

    public void setCgpa(BigDecimal cgpa) {
        this.cgpa = cgpa;
    }

    public int getActiveBacklogs() {
        return activeBacklogs;
    }

    public void setActiveBacklogs(int activeBacklogs) {
        this.activeBacklogs = activeBacklogs;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public String getDepartmentCode() {
        return departmentCode;
    }

    public void setDepartmentCode(String departmentCode) {
        this.departmentCode = departmentCode;
    }

    public boolean isActiveUser() {
        return activeUser;
    }

    public void setActiveUser(boolean activeUser) {
        this.activeUser = activeUser;
    }

    public boolean isHasPendingUpdate() {
        return hasPendingUpdate;
    }

    public void setHasPendingUpdate(boolean hasPendingUpdate) {
        this.hasPendingUpdate = hasPendingUpdate;
    }

    public BigDecimal getPendingCgpa() {
        return pendingCgpa;
    }

    public void setPendingCgpa(BigDecimal pendingCgpa) {
        this.pendingCgpa = pendingCgpa;
    }

    public Integer getPendingBacklogs() {
        return pendingBacklogs;
    }

    public void setPendingBacklogs(Integer pendingBacklogs) {
        this.pendingBacklogs = pendingBacklogs;
    }

    public Integer getActiveResumeId() {
        return activeResumeId;
    }

    public void setActiveResumeId(Integer activeResumeId) {
        this.activeResumeId = activeResumeId;
    }

    public String getResumeFileName() {
        return resumeFileName;
    }

    public void setResumeFileName(String resumeFileName) {
        this.resumeFileName = resumeFileName;
    }

    public String getResumeFilePath() {
        return resumeFilePath;
    }

    public void setResumeFilePath(String resumeFilePath) {
        this.resumeFilePath = resumeFilePath;
    }
}
