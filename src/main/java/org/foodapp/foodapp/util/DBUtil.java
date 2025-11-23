package org.foodapp.foodapp.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    // 1. Database Connection Details
    // We use 'foodapp_db' which we created in MySQL Workbench
    private static final String URL = "jdbc:mysql://localhost:3306/foodapp_db";

    // 2. Database Credentials (!!! IMPORTANT !!!)
    // You MUST change these to your MySQL username and password
    private static final String USER = "root";
    private static final String PASSWORD = "Password";

        // the connector
    private static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";
            // method to get our connection object
    public static Connection getConnection() {
        Connection connection = null;
        try {
            // 3. Load the driver
            Class.forName(DRIVER_CLASS);

            // 4. Get the connection
            connection = DriverManager.getConnection(URL, USER, PASSWORD);

        } catch (ClassNotFoundException e) {
            System.err.println("Error: MySQL JDBC Driver not found!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error: Connection to database failed!");
            e.printStackTrace();
        }

        return connection;
    }
}

