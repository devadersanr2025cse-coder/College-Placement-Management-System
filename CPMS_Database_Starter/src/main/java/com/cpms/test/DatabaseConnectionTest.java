package com.cpms.test;

import com.cpms.util.DBConnection;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class DatabaseConnectionTest {
    public static void main(String[] args) {
        try (Connection connection = DBConnection.getConnection();
             Statement statement = connection.createStatement()) {
            System.out.println("Connected to: " + connection.getCatalog());
            try (ResultSet rs = statement.executeQuery(
                    "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE()")) {
                if (rs.next()) System.out.println("Tables found: " + rs.getInt(1));
            }
        } catch (Exception e) {
            System.err.println("Database connection failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
