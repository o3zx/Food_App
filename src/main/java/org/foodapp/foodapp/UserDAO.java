package org.foodapp.foodapp;
import org.mindrot.jbcrypt.BCrypt;
import org.foodapp.foodapp.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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
        if (getUserByUsername(user.getUsername()) != null) {
            System.out.println("DAO: User " + user.getUsername() + " already exists.");
            return false;
        }

        String sql = "INSERT INTO users (username, email, passwordHash, role, Address) VALUES (?, ?, ?, ?,?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());

            String HashedPassowrd = BCrypt.hashpw(user.getPasswordHash(), BCrypt.gensalt());
            ps.setString(3, HashedPassowrd);
            ps.setString(4, "CUSTOMER");
            ps.setString(5, user.getAddress());

            int rowsAffected = ps.executeUpdate();

            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error adding user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }


    public User authenticateUser(String username, String password) {
        User user = getUserByUsername(username);

        if (user != null && BCrypt.checkpw(password, user.getPasswordHash())) {
            System.out.println("DAO: Hashed Login success for " + username);
            return user;
        }

        System.out.println("DAO: Hashed Login failed for " + username);
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

            String storedPasswordHash = null;
            try (PreparedStatement psSelect = conn.prepareStatement(sqlSelect)) {
                psSelect.setInt(1, userId);
                try (ResultSet rs = psSelect.executeQuery()) {
                    if (rs.next()) {
                        storedPasswordHash = rs.getString("passwordHash");
                    }
                }
            }

            if (storedPasswordHash == null || !BCrypt.checkpw(currentPassword, storedPasswordHash)) {
                System.out.println("DAO: Password update failed. Current password incorrect.");
                return false;
            }


            String newHashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

            try (PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate)) {
                psUpdate.setString(1, newHashedPassword);
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
    public List<User> getUsersByRole(String role) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, role);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // We can't use a helper here since we don't have one
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                    user.setAddress(rs.getString("address"));
                    users.add(user);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
}