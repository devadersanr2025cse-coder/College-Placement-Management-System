package com.cpms.controller;

import com.cpms.dao.CompanyDAO;
import com.cpms.dao.DepartmentDAO;
import com.cpms.model.Company;
import com.cpms.model.Department;
import com.cpms.service.AuthService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private AuthService authService;
    private DepartmentDAO departmentDAO;
    private CompanyDAO companyDAO;

    @Override
    public void init() {
        authService = new AuthService();
        departmentDAO = new DepartmentDAO();
        companyDAO = new CompanyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Department> departments = departmentDAO.getAllDepartments();
        List<Company> companies = companyDAO.getActiveCompanies();

        request.setAttribute("departments", departments);
        request.setAttribute("companies", companies);

        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        String result = "";

        if ("STUDENT".equalsIgnoreCase(role)) {
            String registerNumber = request.getParameter("registerNumber");
            int departmentId = 0;
            int batchYear = 0;
            try {
                departmentId = Integer.parseInt(request.getParameter("departmentId"));
                batchYear = Integer.parseInt(request.getParameter("batchYear"));
            } catch (NumberFormatException ignored) {}

            result = authService.registerStudent(fullName, email, password, confirmPassword, registerNumber, departmentId, batchYear);

        } else if ("RECRUITER".equalsIgnoreCase(role)) {
            int companyId = 0;
            try {
                String compIdStr = request.getParameter("companyId");
                if (compIdStr != null && !compIdStr.isBlank()) {
                    companyId = Integer.parseInt(compIdStr);
                }
            } catch (NumberFormatException ignored) {}

            String newCompanyName = request.getParameter("newCompanyName");
            String designation = request.getParameter("designation");

            result = authService.registerRecruiter(fullName, email, password, confirmPassword, companyId, newCompanyName, designation);

        } else if ("OFFICER".equalsIgnoreCase(role)) {
            String employeeCode = request.getParameter("employeeCode");
            String designation = request.getParameter("designation");
            String inviteCode = request.getParameter("inviteCode");

            result = authService.registerOfficer(fullName, email, password, confirmPassword, employeeCode, designation, inviteCode);

        } else {
            result = "Invalid registration role specified.";
        }

        if ("SUCCESS".equals(result)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?registered=true");
        } else {
            request.setAttribute("errorMessage", result);
            request.setAttribute("selectedRole", role);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            doGet(request, response);
        }
    }
}

