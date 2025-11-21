//package org.foodapp.foodapp.util;
//
//import java.sql.Connection;
//import java.sql.DriverManager;
//import java.sql.SQLException;
//
//public class DBUtil {
//
//    // 1. Database Connection Details
//    // We use 'foodapp_db' which we created in MySQL Workbench
//    private static final String URL = "jdbc:mysql://localhost:3306/foodapp_db";
//
//    // 2. Database Credentials (!!! IMPORTANT !!!)
//    // You MUST change these to your MySQL username and password
//    private static final String USER = "root";
//    private static final String PASSWORD = "Yahyadriss1968";
//
//        // the connector
//    private static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";
//            // method to get our connection object
//    public static Connection getConnection() {
//        Connection connection = null;
//        try {
//            // 3. Load the driver
//            Class.forName(DRIVER_CLASS);
//
//            // 4. Get the connection
//            connection = DriverManager.getConnection(URL, USER, PASSWORD);
//
//        } catch (ClassNotFoundException e) {
//            System.err.println("Error: MySQL JDBC Driver not found!");
//            e.printStackTrace();
//        } catch (SQLException e) {
//            System.err.println("Error: Connection to database failed!");
//            e.printStackTrace();
//        }
//
//        return connection;
//    }
//}

package org.foodapp.foodapp.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    // 1. Get Environment Variables (Cloud) OR use Defaults (Local)
    private static final String DB_HOST = System.getenv("DB_HOST") != null ? System.getenv("DB_HOST") : "localhost";
    private static final String DB_PORT = System.getenv("DB_PORT") != null ? System.getenv("DB_PORT") : "3306";
    private static final String DB_NAME = System.getenv("DB_NAME") != null ? System.getenv("DB_NAME") : "foodapp_db";
    private static final String DB_USER = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "root";

    // !!! IMPORTANT: REPLACE 'your_local_password' WITH YOUR REAL MYSQL PASSWORD !!!
    private static final String DB_PASS = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : "Yahyadriss1968";

    private static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";

    public static Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName(DRIVER_CLASS);

            // 2. Smart URL Builder
            String url;
            if ("localhost".equals(DB_HOST)) {
                // LOCAL: Simple URL (No strict SSL)
                url = "jdbc:mysql://localhost:" + DB_PORT + "/" + DB_NAME + "?allowPublicKeyRetrieval=true&useSSL=false";
            } else {
                // CLOUD: Secure URL (TiDB requires this)
                url = "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME +
                        "?sslMode=VERIFY_IDENTITY&enabledTLSProtocols=TLSv1.2,TLSv1.3&useSSL=true&allowPublicKeyRetrieval=true";
            }

            connection = DriverManager.getConnection(url, DB_USER, DB_PASS);

        } catch (ClassNotFoundException e) {
            System.err.println("Error: MySQL JDBC Driver not found!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error: Connection to database failed!");
            // Print the error so you can see WHY it failed
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
        }

        return connection;
    }
}