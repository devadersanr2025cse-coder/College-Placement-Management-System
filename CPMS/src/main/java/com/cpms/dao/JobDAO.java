package com.cpms.dao;

import com.cpms.model.Job;
import com.cpms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JobDAO {

    public int createJob(Job job, List<Integer> departmentIds) {
        String insertJobSql = """
            INSERT INTO jobs (company_id, posted_by, job_title, job_description, job_type, location,
                              min_cgpa, max_backlogs, package_lpa, application_deadline, job_status)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            int jobId = -1;
            try (PreparedStatement ps = con.prepareStatement(insertJobSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, job.getCompanyId());
                ps.setInt(2, job.getPostedBy());
                ps.setString(3, job.getJobTitle());
                ps.setString(4, job.getJobDescription());
                ps.setString(5, job.getJobType());
                ps.setString(6, job.getLocation());
                ps.setBigDecimal(7, job.getMinCgpa());
                ps.setInt(8, job.getMaxBacklogs());
                ps.setBigDecimal(9, job.getPackageLpa());
                ps.setTimestamp(10, job.getApplicationDeadline());
                ps.setString(11, job.getJobStatus());

                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        jobId = rs.getInt(1);
                        job.setJobId(jobId);
                    }
                }
            }

            if (jobId > 0 && departmentIds != null && !departmentIds.isEmpty()) {
                String insertDeptSql = "INSERT INTO job_departments (job_id, department_id) VALUES (?, ?)";
                try (PreparedStatement psDept = con.prepareStatement(insertDeptSql)) {
                    for (int deptId : departmentIds) {
                        psDept.setInt(1, jobId);
                        psDept.setInt(2, deptId);
                        psDept.addBatch();
                    }
                    psDept.executeBatch();
                }
            }

            con.commit();
            return jobId;

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return -1;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    public boolean updateJob(Job job, List<Integer> departmentIds) {
        String updateJobSql = """
            UPDATE jobs
            SET company_id = ?, job_title = ?, job_description = ?, job_type = ?, location = ?,
                min_cgpa = ?, max_backlogs = ?, package_lpa = ?, application_deadline = ?, job_status = ?
            WHERE job_id = ?
        """;

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            try (PreparedStatement ps = con.prepareStatement(updateJobSql)) {
                ps.setInt(1, job.getCompanyId());
                ps.setString(2, job.getJobTitle());
                ps.setString(3, job.getJobDescription());
                ps.setString(4, job.getJobType());
                ps.setString(5, job.getLocation());
                ps.setBigDecimal(6, job.getMinCgpa());
                ps.setInt(7, job.getMaxBacklogs());
                ps.setBigDecimal(8, job.getPackageLpa());
                ps.setTimestamp(9, job.getApplicationDeadline());
                ps.setString(10, job.getJobStatus());
                ps.setInt(11, job.getJobId());

                ps.executeUpdate();
            }

            if (departmentIds != null) {
                // Delete old mappings
                try (PreparedStatement psDel = con.prepareStatement("DELETE FROM job_departments WHERE job_id = ?")) {
                    psDel.setInt(1, job.getJobId());
                    psDel.executeUpdate();
                }

                // Insert new mappings
                if (!departmentIds.isEmpty()) {
                    try (PreparedStatement psDept = con.prepareStatement("INSERT INTO job_departments (job_id, department_id) VALUES (?, ?)")) {
                        for (int deptId : departmentIds) {
                            psDept.setInt(1, job.getJobId());
                            psDept.setInt(2, deptId);
                            psDept.addBatch();
                        }
                        psDept.executeBatch();
                    }
                }
            }

            con.commit();
            return true;

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    public boolean setJobStatus(int jobId, String status) {
        String sql = "UPDATE jobs SET job_status = ? WHERE job_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, jobId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Job findById(int jobId) {
        String sql = """
            SELECT j.*, c.company_name, c.website as company_website, c.industry as company_industry,
                   u.full_name as posted_by_name,
                   COUNT(DISTINCT a.application_id) as applicant_count
            FROM jobs j
            JOIN companies c ON j.company_id = c.company_id
            JOIN placement_officers po ON j.posted_by = po.officer_id
            JOIN users u ON po.user_id = u.user_id
            LEFT JOIN applications a ON j.job_id = a.job_id
            WHERE j.job_id = ?
            GROUP BY j.job_id, c.company_name, c.website, c.industry, u.full_name
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, jobId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Job job = mapJob(rs);
                    loadJobDepartments(job, con);
                    return job;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Job> getAllJobs(boolean openOnly) {
        List<Job> jobs = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT j.*, c.company_name, c.website as company_website, c.industry as company_industry,
                   u.full_name as posted_by_name,
                   COUNT(DISTINCT a.application_id) as applicant_count
            FROM jobs j
            JOIN companies c ON j.company_id = c.company_id
            JOIN placement_officers po ON j.posted_by = po.officer_id
            JOIN users u ON po.user_id = u.user_id
            LEFT JOIN applications a ON j.job_id = a.job_id
        """);

        if (openOnly) {
            sql.append(" WHERE j.job_status = 'OPEN' AND (j.application_deadline IS NULL OR j.application_deadline >= NOW())");
        }
        sql.append(" GROUP BY j.job_id, c.company_name, c.website, c.industry, u.full_name ORDER BY j.created_at DESC");

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql.toString())) {

            while (rs.next()) {
                Job job = mapJob(rs);
                loadJobDepartments(job, con);
                jobs.add(job);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return jobs;
    }

    public List<Job> getJobsByCompany(int companyId) {
        List<Job> jobs = new ArrayList<>();
        String sql = """
            SELECT j.*, c.company_name, c.website as company_website, c.industry as company_industry,
                   u.full_name as posted_by_name,
                   COUNT(DISTINCT a.application_id) as applicant_count
            FROM jobs j
            JOIN companies c ON j.company_id = c.company_id
            JOIN placement_officers po ON j.posted_by = po.officer_id
            JOIN users u ON po.user_id = u.user_id
            LEFT JOIN applications a ON j.job_id = a.job_id
            WHERE j.company_id = ?
            GROUP BY j.job_id, c.company_name, c.website, c.industry, u.full_name
            ORDER BY j.created_at DESC
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Job job = mapJob(rs);
                    loadJobDepartments(job, con);
                    jobs.add(job);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return jobs;
    }

    public List<Integer> getDepartmentIdsForJob(int jobId) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT department_id FROM job_departments WHERE job_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countActiveJobs() {
        String sql = "SELECT COUNT(*) FROM jobs WHERE job_status = 'OPEN'";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private void loadJobDepartments(Job job, Connection con) {
        String sql = """
            SELECT d.department_id, d.department_code, d.department_name
            FROM job_departments jd
            JOIN departments d ON jd.department_id = d.department_id
            WHERE jd.job_id = ?
        """;
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, job.getJobId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    job.getDepartmentIds().add(rs.getInt("department_id"));
                    job.getDepartmentNames().add(rs.getString("department_code"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Job mapJob(ResultSet rs) throws SQLException {
        Job j = new Job();
        j.setJobId(rs.getInt("job_id"));
        j.setCompanyId(rs.getInt("company_id"));
        j.setPostedBy(rs.getInt("posted_by"));
        j.setJobTitle(rs.getString("job_title"));
        j.setJobDescription(rs.getString("job_description"));
        j.setJobType(rs.getString("job_type"));
        j.setLocation(rs.getString("location"));
        j.setMinCgpa(rs.getBigDecimal("min_cgpa"));
        j.setMaxBacklogs(rs.getInt("max_backlogs"));
        j.setPackageLpa(rs.getBigDecimal("package_lpa"));
        j.setApplicationDeadline(rs.getTimestamp("application_deadline"));
        j.setJobStatus(rs.getString("job_status"));
        j.setCreatedAt(rs.getTimestamp("created_at"));
        j.setCompanyName(rs.getString("company_name"));
        j.setCompanyWebsite(rs.getString("company_website"));
        j.setCompanyIndustry(rs.getString("company_industry"));
        j.setPostedByName(rs.getString("posted_by_name"));
        j.setApplicantCount(rs.getInt("applicant_count"));
        return j;
    }
}

