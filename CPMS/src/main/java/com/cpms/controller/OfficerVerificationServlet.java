package com.cpms.controller;

import com.cpms.dao.PlacementOfficerDAO;
import com.cpms.model.AcademicUpdate;
import com.cpms.model.PlacementOfficer;
import com.cpms.service.OfficerService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/officer/verifications")
public class OfficerVerificationServlet extends HttpServlet {

    private OfficerService officerService;
    private PlacementOfficerDAO officerDAO;

    @Override
    public void init() {
        officerService = new OfficerService();
        officerDAO = new PlacementOfficerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<AcademicUpdate> pendingUpdates = officerService.getPendingAcademicUpdates();
        request.setAttribute("pendingUpdates", pendingUpdates);
        request.getRequestDispatcher("/officer/verifications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("userId");
        PlacementOfficer officer = officerDAO.findByUserId(userId);

        int officerId = officer != null ? officer.getOfficerId() : 1;

        int updateId = 0;
        try {
            updateId = Integer.parseInt(request.getParameter("updateId"));
        } catch (NumberFormatException ignored) {}

        String action = request.getParameter("action"); // APPROVE or REJECT
        String remarks = request.getParameter("officerRemarks");

        String status = "APPROVE".equalsIgnoreCase(action) ? "APPROVED" : "REJECTED";

        boolean reviewed = officerService.reviewAcademicUpdate(updateId, officerId, status, remarks);

        if (reviewed) {
            response.sendRedirect(request.getContextPath() + "/officer/verifications?success=" + status.toLowerCase());
        } else {
            request.setAttribute("errorMessage", "Failed to process academic verification.");
            doGet(request, response);
        }
    }
}

