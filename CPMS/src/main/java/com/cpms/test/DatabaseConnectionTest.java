
package com.cpms.test;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import com.cpms.util.DBConnection;

public class DatabaseConnectionTest {

    public static void main(String[] args) {

        try (Connection connection = DBConnection.getConnection()) {

            DatabaseMetaData metaData = connection.getMetaData();

            System.out.println("================================");
            System.out.println("DATABASE CONNECTION SUCCESSFUL");
            System.out.println("================================");

            System.out.println("Database: " +
                connection.getCatalog());

            System.out.println("MySQL Version: " +
                metaData.getDatabaseProductVersion());

            System.out.println("JDBC Driver: " +
                metaData.getDriverName());

        } catch (Exception e) {

            System.out.println("DATABASE CONNECTION FAILED");
            e.printStackTrace();
        }
    }
}

