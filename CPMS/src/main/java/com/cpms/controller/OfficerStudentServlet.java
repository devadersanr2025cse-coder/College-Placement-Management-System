package com.cpms.controller;

import com.cpms.dao.DepartmentDAO;
import com.cpms.model.Department;
import com.cpms.model.Student;
import com.cpms.service.OfficerService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/officer/students")
public class OfficerStudentServlet extends HttpServlet {

    private OfficerService officerService;
    private DepartmentDAO departmentDAO;

    @Override
    public void init() {
        officerService = new OfficerService();
        departmentDAO = new DepartmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("q");
        String deptStr = request.getParameter("departmentId");
        String batchStr = request.getParameter("batchYear");

        Integer departmentId = null;
        Integer batchYear = null;

        try {
            if (deptStr != null && !deptStr.isBlank()) departmentId = Integer.parseInt(deptStr);
            if (batchStr != null && !batchStr.isBlank()) batchYear = Integer.parseInt(batchStr);
        } catch (NumberFormatException ignored) {}

        List<Student> students = officerService.searchStudents(query, departmentId, batchYear);
        List<Department> departments = departmentDAO.getAllDepartments();

        request.setAttribute("students", students);
        request.setAttribute("departments", departments);
        request.setAttribute("query", query);
        request.setAttribute("selectedDept", departmentId);
        request.setAttribute("selectedBatch", batchYear);

        request.getRequestDispatcher("/officer/students.jsp").forward(request, response);
    }
}

