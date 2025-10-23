package org.foodapp.foodapp;

import org.foodapp.foodapp.util.DBUtil; // Import our new utility
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    /**
     * Finds a user by their username.
     * @param username The username to search for.
     * @return The User object if found, otherwise null.
     */
    public User getUserByUsername(String username) {
        // SQL query to find the user
        String sql = "SELECT * FROM users WHERE username = ?";
        User user = null;

        // try-with-resources: Automatically closes the connection and statement
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set the username parameter (the ? in the SQL)
            ps.setString(1, username);

            // Execute the query and get the results
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) { // Check if we found a row
                    // Create a User object from the row data
                    user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPasswordHash(rs.getString("passwordHash"));
                    user.setRole(rs.getString("role"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching user by username: " + e.getMessage());
            e.printStackTrace();
        }
        return user; // Return the user (or null if not found)
    }

    /**
     * Adds a new user to the 'users' table.
     * @param user The User object to add.
     * @return true if added, false if username already exists or an error occurs.
     */
    public boolean addUser(User user) {
        // First, check if user already exists
        if (getUserByUsername(user.getUsername()) != null) {
            System.out.println("DAO: User " + user.getUsername() + " already exists.");
            return false; // Registration failed: Username taken
        }

        // SQL query to insert a new user
        String sql = "INSERT INTO users (username, email, passwordHash, role) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set the parameters for the query
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());

            // !! IMPORTANT !! In a real app, HASH the password before this step!
            // We are storing plain text for this example ONLY.
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, "CUSTOMER"); // Default role

            // Execute the insert
            int rowsAffected = ps.executeUpdate();

            // Return true if one row was successfully inserted
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error adding user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Authenticates a user.
     * @param username The username.
     * @param password The plain-text password.
     * @return The User object if login is successful, otherwise null.
     */
    public User authenticateUser(String username, String password) {
        User user = getUserByUsername(username);

        // !! IMPORTANT !! This is NOT secure.
        // A real app would hash the 'password' parameter and compare it to the
        // stored 'passwordHash'. We are comparing plain text for this example.
        if (user != null && user.getPasswordHash().equals(password)) {
            System.out.println("DAO: Login success for " + username);
            return user;
        }

        System.out.println("DAO: Login failed for " + username);
        return null;
    }
}