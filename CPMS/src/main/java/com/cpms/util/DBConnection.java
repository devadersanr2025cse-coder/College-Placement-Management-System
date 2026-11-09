package com.cpms.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
        System.getenv().getOrDefault(
            "CPMS_DB_URL",
            "jdbc:mysql://localhost:3306/cpms?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Kolkata"
        );

    private static final String USER =
        System.getenv().getOrDefault("CPMS_DB_USER", "root");

    private static final String PASSWORD =
        System.getenv().getOrDefault("CPMS_DB_PASSWORD", "");

    public static Connection getConnection() throws SQLException {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                "MySQL JDBC Driver could not be loaded.", e
            );
        }

        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}