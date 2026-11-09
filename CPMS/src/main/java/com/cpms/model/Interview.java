package com.cpms.model;

import java.sql.Timestamp;

public class Interview {
    private int interviewId;
    private int applicationId;
    private int roundNumber;
    private Timestamp interviewDatetime;
    private String mode; // ONLINE, OFFLINE
    private String meetingOrVenue;
    private int scheduledBy;
    private String result; // PENDING, PASSED, FAILED
    private String notes;

    // Joined fields
    private int studentId;
    private String studentName;
    private String registerNumber;
    private String studentEmail;
    private int jobId;
    private String jobTitle;
    private int companyId;
    private String companyName;
    private String scheduledByName;

    public Interview() {
        this.roundNumber = 1;
        this.mode = "ONLINE";
        this.result = "PENDING";
    }

    public int getInterviewId() {
        return interviewId;
    }

    public void setInterviewId(int interviewId) {
        this.interviewId = interviewId;
    }

    public int getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
    }

    public int getRoundNumber() {
        return roundNumber;
    }

    public void setRoundNumber(int roundNumber) {
        this.roundNumber = roundNumber;
    }

    public Timestamp getInterviewDatetime() {
        return interviewDatetime;
    }

    public void setInterviewDatetime(Timestamp interviewDatetime) {
        this.interviewDatetime = interviewDatetime;
    }

    public String getMode() {
        return mode;
    }

    public void setMode(String mode) {
        this.mode = mode;
    }

    public String getMeetingOrVenue() {
        return meetingOrVenue;
    }

    public void setMeetingOrVenue(String meetingOrVenue) {
        this.meetingOrVenue = meetingOrVenue;
    }

    public int getScheduledBy() {
        return scheduledBy;
    }

    public void setScheduledBy(int scheduledBy) {
        this.scheduledBy = scheduledBy;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
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

    public String getStudentEmail() {
        return studentEmail;
    }

    public void setStudentEmail(String studentEmail) {
        this.studentEmail = studentEmail;
    }

    public int getJobId() {
        return jobId;
    }

    public void setJobId(int jobId) {
        this.jobId = jobId;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public int getCompanyId() {
        return companyId;
    }

    public void setCompanyId(int companyId) {
        this.companyId = companyId;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getScheduledByName() {
        return scheduledByName;
    }

    public void setScheduledByName(String scheduledByName) {
        this.scheduledByName = scheduledByName;
    }
}

