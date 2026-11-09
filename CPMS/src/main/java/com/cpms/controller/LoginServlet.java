package com.cpms.controller;

import com.cpms.dao.PlacementOfficerDAO;
import com.cpms.dao.RecruiterDAO;
import com.cpms.dao.StudentDAO;
import com.cpms.model.PlacementOfficer;
import com.cpms.model.Recruiter;
import com.cpms.model.Student;
import com.cpms.model.User;
import com.cpms.service.AuthService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private AuthService authService;
    private StudentDAO studentDAO;
    private PlacementOfficerDAO officerDAO;
    private RecruiterDAO recruiterDAO;

    @Override
    public void init() {
        authService = new AuthService();
        studentDAO = new StudentDAO();
        officerDAO = new PlacementOfficerDAO();
        recruiterDAO = new RecruiterDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("role") != null) {
            String role = (String) session.getAttribute("role");
            if ("STUDENT".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/student/dashboard");
                return;
            } else if ("OFFICER".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/officer/dashboard");
                return;
            } else if ("RECRUITER".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/recruiter/dashboard");
                return;
            }
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = authService.login(email, password);

        if (user == null) {
            request.setAttribute("errorMessage", "Invalid email or password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Create a new session after successful authentication
        HttpSession session = request.getSession(true);

        // Prevent session fixation
        request.changeSessionId();

        session.setAttribute("userId", user.getUserId());
        session.setAttribute("fullName", user.getFullName());
        session.setAttribute("email", user.getEmail());
        session.setAttribute("role", user.getRole());

        // Cache role-specific identifiers in session
        if ("STUDENT".equalsIgnoreCase(user.getRole())) {
            Student s = studentDAO.findByUserId(user.getUserId());
            if (s != null) {
                session.setAttribute("studentId", s.getStudentId());
                session.setAttribute("registerNumber", s.getRegisterNumber());
            }
            session.setMaxInactiveInterval(30 * 60);
            response.sendRedirect(request.getContextPath() + "/student/dashboard");

        } else if ("OFFICER".equalsIgnoreCase(user.getRole())) {
            PlacementOfficer po = officerDAO.findByUserId(user.getUserId());
            if (po != null) {
                session.setAttribute("officerId", po.getOfficerId());
            }
            session.setMaxInactiveInterval(30 * 60);
            response.sendRedirect(request.getContextPath() + "/officer/dashboard");

        } else if ("RECRUITER".equalsIgnoreCase(user.getRole())) {
            Recruiter r = recruiterDAO.findByUserId(user.getUserId());
            if (r != null) {
                session.setAttribute("recruiterId", r.getRecruiterId());
                session.setAttribute("companyId", r.getCompanyId());
                session.setAttribute("companyName", r.getCompanyName());
            }
            session.setMaxInactiveInterval(30 * 60);
            response.sendRedirect(request.getContextPath() + "/recruiter/dashboard");

        } else {
            session.invalidate();
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized role.");
        }
    }
}
