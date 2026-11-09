package com.cpms.controller;

import com.cpms.service.OfficerService;
import com.cpms.service.ReportService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@WebServlet("/officer/reports")
public class OfficerReportServlet extends HttpServlet {

    private OfficerService officerService;
    private ReportService reportService;

    @Override
    public void init() {
        officerService = new OfficerService();
        reportService = new ReportService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("userId");

        String format = request.getParameter("download");

        if ("pdf".equalsIgnoreCase(format)) {
            byte[] pdfBytes = reportService.generatePlacementSummaryPdf(userId);
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"CPMS_Placement_Report_" + LocalDate.now() + ".pdf\"");
            response.setContentLength(pdfBytes.length);

            try (OutputStream out = response.getOutputStream()) {
                out.write(pdfBytes);
                out.flush();
            }
            return;

        } else if ("excel".equalsIgnoreCase(format)) {
            byte[] excelBytes = reportService.generatePlacementSummaryExcel(userId);
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"CPMS_Placement_Report_" + LocalDate.now() + ".xlsx\"");
            response.setContentLength(excelBytes.length);

            try (OutputStream out = response.getOutputStream()) {
                out.write(excelBytes);
                out.flush();
            }
            return;
        }

        Map<String, Object> metrics = officerService.getDashboardMetrics();
        List<Map<String, Object>> deptStats = officerService.getDepartmentPlacementStats();
        List<Map<String, Object>> companyStats = officerService.getCompanyPlacements();

        request.setAttribute("metrics", metrics);
        request.setAttribute("deptStats", deptStats);
        request.setAttribute("companyStats", companyStats);
        request.getRequestDispatcher("/officer/reports.jsp").forward(request, response);
    }
}

