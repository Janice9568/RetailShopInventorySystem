package com.retail.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection utility class to handle MySQL database connectivity.
 */
public class DBConnection {

    // Database configuration - Update these details based on your MySQL setup
    private static final String URL = "jdbc:mysql://localhost:3306/retail_shop_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "admin"; // Change to your MySQL password
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    private static Connection connection = null;

    /**
     * Returns a connection to the MySQL database.
     * @return Connection object
     */
    public static Connection getConnection() {
        try {
            // Load the MySQL JDBC Driver
            Class.forName(DRIVER);

            // Establish the connection
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Database Connection Successful.");
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("SQL Connection Error: " + e.getMessage());
            e.printStackTrace();
        }
        return connection;
    }

    /**
     * Closes the provided database connection.
     * @param conn The connection to close.
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("Database Connection Closed.");
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }
}