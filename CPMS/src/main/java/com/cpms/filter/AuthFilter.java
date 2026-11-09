package com.cpms.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AuthFilter implements Filter {

    @Override
    public void doFilter(
            jakarta.servlet.ServletRequest request,
            jakarta.servlet.ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String requestURI = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = requestURI.substring(contextPath.length());

        // Bypass public resources
        if (path.startsWith("/assets/") ||
            path.equals("/login.jsp") ||
            path.equals("/login") ||
            path.equals("/register.jsp") ||
            path.equals("/register") ||
            path.equals("/access-denied.jsp") ||
            path.equals("/index.jsp") ||
            path.equals("/") ||
            path.isEmpty()) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);

        // Check login
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect(contextPath + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");

        // Role-based access enforcement with friendly redirect
        if (path.startsWith("/student/") && !"STUDENT".equalsIgnoreCase(role)) {
            res.sendRedirect(contextPath + "/access-denied.jsp?required=STUDENT&current=" + (role != null ? role : "GUEST"));
            return;
        }

        if ((path.startsWith("/officer/") || path.startsWith("/admin/")) && !"OFFICER".equalsIgnoreCase(role)) {
            res.sendRedirect(contextPath + "/access-denied.jsp?required=OFFICER&current=" + (role != null ? role : "GUEST"));
            return;
        }

        if (path.startsWith("/recruiter/") && !"RECRUITER".equalsIgnoreCase(role)) {
            res.sendRedirect(contextPath + "/access-denied.jsp?required=RECRUITER&current=" + (role != null ? role : "GUEST"));
            return;
        }

        // Prevent caching of sensitive portal pages
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        chain.doFilter(request, response);
    }
}
