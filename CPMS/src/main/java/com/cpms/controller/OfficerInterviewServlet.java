package com.cpms.controller;

import com.cpms.dao.ApplicationDAO;
import com.cpms.dao.PlacementOfficerDAO;
import com.cpms.model.Application;
import com.cpms.model.Interview;
import com.cpms.model.PlacementOfficer;
import com.cpms.service.OfficerService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/officer/interviews")
public class OfficerInterviewServlet extends HttpServlet {

    private OfficerService officerService;
    private ApplicationDAO applicationDAO;
    private PlacementOfficerDAO officerDAO;

    @Override
    public void init() {
        officerService = new OfficerService();
        applicationDAO = new ApplicationDAO();
        officerDAO = new PlacementOfficerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Interview> upcomingInterviews = officerService.getUpcomingInterviews(50);
        request.setAttribute("interviews", upcomingInterviews);
        request.getRequestDispatcher("/officer/interviews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("userId");
        PlacementOfficer officer = officerDAO.findByUserId(userId);
        int officerId = officer != null ? officer.getOfficerId() : 1;

        String action = request.getParameter("action");

        if ("schedule".equalsIgnoreCase(action)) {
            int applicationId = Integer.parseInt(request.getParameter("applicationId"));
            int roundNumber = Integer.parseInt(request.getParameter("roundNumber"));
            String datetimeStr = request.getParameter("interviewDatetime");
            String mode = request.getParameter("mode");
            String meetingOrVenue = request.getParameter("meetingOrVenue");

            LocalDateTime ldt = LocalDateTime.parse(datetimeStr);

            Interview interview = new Interview();
            interview.setApplicationId(applicationId);
            interview.setRoundNumber(roundNumber);
            interview.setInterviewDatetime(Timestamp.valueOf(ldt));
            interview.setMode(mode != null ? mode : "ONLINE");
            interview.setMeetingOrVenue(meetingOrVenue != null ? meetingOrVenue.trim() : "");
            interview.setResult("PENDING");

            boolean scheduled = officerService.scheduleInterview(interview, officerId);
            if (scheduled) {
                response.sendRedirect(request.getContextPath() + "/officer/interviews?success=scheduled");
            } else {
                request.setAttribute("errorMessage", "Failed to schedule interview. Round might already exist for this candidate.");
                doGet(request, response);
            }

        } else if ("result".equalsIgnoreCase(action)) {
            int interviewId = Integer.parseInt(request.getParameter("interviewId"));
            String result = request.getParameter("result");
            String notes = request.getParameter("notes");

            boolean recorded = officerService.recordInterviewResult(interviewId, result, notes);
            if (recorded) {
                response.sendRedirect(request.getContextPath() + "/officer/interviews?success=result");
            } else {
                request.setAttribute("errorMessage", "Failed to record interview result.");
                doGet(request, response);
            }
        } else {
            doGet(request, response);
        }
    }
}

