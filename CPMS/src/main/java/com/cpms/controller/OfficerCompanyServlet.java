package com.cpms.controller;

import com.cpms.model.Company;
import com.cpms.service.OfficerService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/officer/companies")
public class OfficerCompanyServlet extends HttpServlet {

    private OfficerService officerService;

    @Override
    public void init() {
        officerService = new OfficerService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String toggleId = request.getParameter("toggle");
        if (toggleId != null) {
            try {
                int cId = Integer.parseInt(toggleId);
                boolean active = Boolean.parseBoolean(request.getParameter("active"));
                officerService.toggleCompanyStatus(cId, active);
                response.sendRedirect(request.getContextPath() + "/officer/companies?success=status");
                return;
            } catch (Exception ignored) {}
        }

        List<Company> companies = officerService.getAllCompanies();
        request.setAttribute("companies", companies);
        request.getRequestDispatcher("/officer/companies.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int companyId = 0;
        try {
            String cIdStr = request.getParameter("companyId");
            if (cIdStr != null && !cIdStr.isBlank()) {
                companyId = Integer.parseInt(cIdStr);
            }
        } catch (NumberFormatException ignored) {}

        String companyName = request.getParameter("companyName");
        String website = request.getParameter("website");
        String industry = request.getParameter("industry");
        String description = request.getParameter("description");
        String contactPerson = request.getParameter("contactPerson");
        String contactEmail = request.getParameter("contactEmail");
        String contactPhone = request.getParameter("contactPhone");

        if (companyName == null || companyName.isBlank()) {
            request.setAttribute("errorMessage", "Company name is required.");
            doGet(request, response);
            return;
        }

        Company c = new Company();
        c.setCompanyId(companyId);
        c.setCompanyName(companyName.trim());
        c.setWebsite(website != null ? website.trim() : null);
        c.setIndustry(industry != null ? industry.trim() : null);
        c.setDescription(description != null ? description.trim() : null);
        c.setContactPerson(contactPerson != null ? contactPerson.trim() : null);
        c.setContactEmail(contactEmail != null ? contactEmail.trim() : null);
        c.setContactPhone(contactPhone != null ? contactPhone.trim() : null);
        c.setActive(true);

        boolean saved = officerService.saveCompany(c);
        if (saved) {
            response.sendRedirect(request.getContextPath() + "/officer/companies?success=saved");
        } else {
            request.setAttribute("errorMessage", "Failed to save company details.");
            doGet(request, response);
        }
    }
}

