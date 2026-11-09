package com.cpms.controller;

import com.cpms.model.*;
import com.cpms.service.OfficerService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/officer/dashboard")
public class OfficerDashboardServlet extends HttpServlet {

    private OfficerService officerService;

    @Override
    public void init() {
        officerService = new OfficerService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        PlacementOfficer officer = officerService.getOfficerByUserId(userId);

        if (officer != null) {
            session.setAttribute("officerId", officer.getOfficerId());
            request.setAttribute("officer", officer);
        }

        Map<String, Object> metrics = officerService.getDashboardMetrics();
        List<AcademicUpdate> pendingUpdates = officerService.getPendingAcademicUpdates();
        List<Interview> upcomingInterviews = officerService.getUpcomingInterviews(5);
        List<Job> activeJobs = officerService.getAllJobs();
        List<Map<String, Object>> deptStats = officerService.getDepartmentPlacementStats();

        request.setAttribute("metrics", metrics);
        request.setAttribute("pendingUpdates", pendingUpdates);
        request.setAttribute("upcomingInterviews", upcomingInterviews);
        request.setAttribute("activeJobs", activeJobs);
        request.setAttribute("deptStats", deptStats);

        request.getRequestDispatcher("/officer/dashboard.jsp").forward(request, response);
    }
}

