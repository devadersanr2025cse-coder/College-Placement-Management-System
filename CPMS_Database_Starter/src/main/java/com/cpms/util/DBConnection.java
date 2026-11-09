package com.cpms.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DBConnection {
    private static final String URL = System.getenv().getOrDefault(
        "CPMS_DB_URL",
        "jdbc:mysql://localhost:3306/cpms?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Kolkata"
    );
    private static final String USER = System.getenv().getOrDefault("CPMS_DB_USER", "root");
    private static final String PASSWORD = System.getenv().getOrDefault("CPMS_DB_PASSWORD", "");

    private DBConnection() {}

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
