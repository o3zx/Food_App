package org.foodapp.foodapp;

import org.foodapp.foodapp.util.DBUtil; // Import our new utility
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {


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
                    user.setAddress(rs.getString("address"));
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
        String sql = "INSERT INTO users (username, email, passwordHash, role, Address) VALUES (?, ?, ?, ?,?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set the parameters for the query
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());

            // !! IMPORTANT !! In a real app, HASH the password before this step!
            // We are storing plain text for this example ONLY.
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, "CUSTOMER"); // Default role
            ps.setString(5, user.getAddress());

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
    public boolean updateUserAddress(int userId, String newAddress) {
        String sql = "UPDATE users SET address = ? WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newAddress);
            ps.setInt(2, userId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; // Will be true if 1 row was changed

        } catch (SQLException e) {
            System.err.println("Error updating user address: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    public boolean updateUserPassword(int userId, String currentPassword, String newPassword) {
        String sqlSelect = "SELECT passwordHash FROM users WHERE id = ?";
        String sqlUpdate = "UPDATE users SET passwordHash = ? WHERE id = ?";

        try (Connection conn = DBUtil.getConnection()) {

            // 1. First, check if the CURRENT password is correct
            String storedPasswordHash = null;
            try (PreparedStatement psSelect = conn.prepareStatement(sqlSelect)) {
                psSelect.setInt(1, userId);
                try (ResultSet rs = psSelect.executeQuery()) {
                    if (rs.next()) {
                        storedPasswordHash = rs.getString("passwordHash");
                    }
                }
            }

            // (In a real app, we would hash 'currentPassword' and compare the hashes)
            // For our app, we just compare plain text:
            if (storedPasswordHash == null || !storedPasswordHash.equals(currentPassword)) {
                System.out.println("DAO: Password update failed. Current password incorrect.");
                return false; // Current password did not match
            }

            // 2. If it was correct, update to the NEW password
            try (PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate)) {
                // (In a real app, we would hash 'newPassword' before storing)
                psUpdate.setString(1, newPassword);
                psUpdate.setInt(2, userId);

                int rowsAffected = psUpdate.executeUpdate();
                return rowsAffected > 0;
            }

        } catch (SQLException e) {
            System.err.println("Error updating user password: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}