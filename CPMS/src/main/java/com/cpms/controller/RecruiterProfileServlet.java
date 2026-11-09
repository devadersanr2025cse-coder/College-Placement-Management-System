package com.cpms.controller;

import com.cpms.model.Company;
import com.cpms.model.Recruiter;
import com.cpms.service.RecruiterService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/recruiter/profile")
public class RecruiterProfileServlet extends HttpServlet {

    private RecruiterService recruiterService;

    @Override
    public void init() {
        recruiterService = new RecruiterService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("userId");
        Recruiter recruiter = recruiterService.getRecruiterByUserId(userId);

        if (recruiter == null) {
            response.sendRedirect(request.getContextPath() + "/recruiter/dashboard");
            return;
        }

        Company company = recruiterService.getCompanyProfile(recruiter.getCompanyId());

        request.setAttribute("recruiter", recruiter);
        request.setAttribute("company", company);
        request.getRequestDispatcher("/recruiter/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("userId");
        Recruiter recruiter = recruiterService.getRecruiterByUserId(userId);

        if (recruiter == null) {
            response.sendRedirect(request.getContextPath() + "/recruiter/dashboard");
            return;
        }

        Company currentCo = recruiterService.getCompanyProfile(recruiter.getCompanyId());

        String companyName = request.getParameter("companyName");
        String website = request.getParameter("website");
        String industry = request.getParameter("industry");
        String description = request.getParameter("description");
        String contactPerson = request.getParameter("contactPerson");
        String contactEmail = request.getParameter("contactEmail");
        String contactPhone = request.getParameter("contactPhone");

        if (companyName != null && !companyName.isBlank()) {
            currentCo.setCompanyName(companyName.trim());
        }
        currentCo.setWebsite(website);
        currentCo.setIndustry(industry);
        currentCo.setDescription(description);
        currentCo.setContactPerson(contactPerson);
        currentCo.setContactEmail(contactEmail);
        currentCo.setContactPhone(contactPhone);

        boolean updated = recruiterService.updateCompanyProfile(currentCo, recruiter.getCompanyId());

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/recruiter/profile?success=saved");
        } else {
            request.setAttribute("errorMessage", "Failed to update company profile.");
            doGet(request, response);
        }
    }
}

