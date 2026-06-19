package com.retail.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection utility class to handle Aiven Cloud MySQL database connectivity.
 */
public class DBConnection {

    // Database configuration - Updated for your Aiven Cloud Database
    private static final String URL = "jdbc:mysql://mysql-363c44dd-ysy210804-8b06.i.aivencloud.com:13613/retail_shop_db?useSSL=true&trustServerCertificate=true&serverTimezone=UTC";
    private static final String USER = "avnadmin";
    private static final String PASSWORD = "AVNS_CR9W1SKNCynL7VElGCi"; // Put your secret Aiven password string here
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