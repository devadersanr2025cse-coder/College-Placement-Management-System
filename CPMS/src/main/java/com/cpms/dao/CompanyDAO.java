package com.cpms.dao;

import com.cpms.model.Company;
import com.cpms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CompanyDAO {

    public List<Company> getAllCompanies() {
        List<Company> companies = new ArrayList<>();
        String sql = """
            SELECT c.company_id, c.company_name, c.website, c.industry, c.description,
                   c.contact_person, c.contact_email, c.contact_phone, c.is_active, c.created_at,
                   COUNT(DISTINCT j.job_id) as job_count,
                   COUNT(DISTINCT CASE WHEN a.application_status = 'SELECTED' THEN a.application_id END) as placement_count
            FROM companies c
            LEFT JOIN jobs j ON c.company_id = j.company_id
            LEFT JOIN applications a ON j.job_id = a.job_id
            GROUP BY c.company_id, c.company_name, c.website, c.industry, c.description,
                     c.contact_person, c.contact_email, c.contact_phone, c.is_active, c.created_at
            ORDER BY c.company_name ASC
        """;

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                companies.add(mapCompany(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return companies;
    }

    public List<Company> getActiveCompanies() {
        List<Company> companies = new ArrayList<>();
        String sql = """
            SELECT c.company_id, c.company_name, c.website, c.industry, c.description,
                   c.contact_person, c.contact_email, c.contact_phone, c.is_active, c.created_at,
                   0 as job_count, 0 as placement_count
            FROM companies c
            WHERE c.is_active = TRUE
            ORDER BY c.company_name ASC
        """;

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                companies.add(mapCompany(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return companies;
    }

    public Company findById(int companyId) {
        String sql = """
            SELECT c.company_id, c.company_name, c.website, c.industry, c.description,
                   c.contact_person, c.contact_email, c.contact_phone, c.is_active, c.created_at,
                   COUNT(DISTINCT j.job_id) as job_count,
                   COUNT(DISTINCT CASE WHEN a.application_status = 'SELECTED' THEN a.application_id END) as placement_count
            FROM companies c
            LEFT JOIN jobs j ON c.company_id = j.company_id
            LEFT JOIN applications a ON j.job_id = a.job_id
            WHERE c.company_id = ?
            GROUP BY c.company_id, c.company_name, c.website, c.industry, c.description,
                     c.contact_person, c.contact_email, c.contact_phone, c.is_active, c.created_at
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCompany(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Company findByName(String name) {
        if (name == null) return null;
        String sql = "SELECT * FROM companies WHERE LOWER(company_name) = LOWER(?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Company c = new Company();
                    c.setCompanyId(rs.getInt("company_id"));
                    c.setCompanyName(rs.getString("company_name"));
                    c.setWebsite(rs.getString("website"));
                    c.setIndustry(rs.getString("industry"));
                    c.setDescription(rs.getString("description"));
                    c.setContactPerson(rs.getString("contact_person"));
                    c.setContactEmail(rs.getString("contact_email"));
                    c.setContactPhone(rs.getString("contact_phone"));
                    c.setActive(rs.getBoolean("is_active"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    return c;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int createCompany(Company c) {
        String sql = """
            INSERT INTO companies (company_name, website, industry, description, contact_person, contact_email, contact_phone, is_active)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, c.getCompanyName());
            ps.setString(2, c.getWebsite());
            ps.setString(3, c.getIndustry());
            ps.setString(4, c.getDescription());
            ps.setString(5, c.getContactPerson());
            ps.setString(6, c.getContactEmail());
            ps.setString(7, c.getContactPhone());
            ps.setBoolean(8, c.isActive());

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateCompany(Company c) {
        String sql = """
            UPDATE companies
            SET company_name = ?, website = ?, industry = ?, description = ?,
                contact_person = ?, contact_email = ?, contact_phone = ?, is_active = ?
            WHERE company_id = ?
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, c.getCompanyName());
            ps.setString(2, c.getWebsite());
            ps.setString(3, c.getIndustry());
            ps.setString(4, c.getDescription());
            ps.setString(5, c.getContactPerson());
            ps.setString(6, c.getContactEmail());
            ps.setString(7, c.getContactPhone());
            ps.setBoolean(8, c.isActive());
            ps.setInt(9, c.getCompanyId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean toggleStatus(int companyId, boolean active) {
        String sql = "UPDATE companies SET is_active = ? WHERE company_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, companyId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countTotalCompanies() {
        String sql = "SELECT COUNT(*) FROM companies";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Company mapCompany(ResultSet rs) throws SQLException {
        Company c = new Company();
        c.setCompanyId(rs.getInt("company_id"));
        c.setCompanyName(rs.getString("company_name"));
        c.setWebsite(rs.getString("website"));
        c.setIndustry(rs.getString("industry"));
        c.setDescription(rs.getString("description"));
        c.setContactPerson(rs.getString("contact_person"));
        c.setContactEmail(rs.getString("contact_email"));
        c.setContactPhone(rs.getString("contact_phone"));
        c.setActive(rs.getBoolean("is_active"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setJobCount(rs.getInt("job_count"));
        c.setPlacementCount(rs.getInt("placement_count"));
        return c;
    }
}

