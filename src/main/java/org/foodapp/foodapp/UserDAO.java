package org.foodapp.foodapp;
import org.foodapp.foodapp.User;
import java.util.Collections;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // --- Simulated Database ---
    // We now use a static list to hold users in memory
    private static final List<User> users = new ArrayList<>();
    private static int nextId = 1;

    // Static initializer to add our original mock "testuser"
    static {
        // "testuser" for logging in
        users.add(new User(nextId++, "testuser", "pass", "test@app.com", "CUSTOMER"));
        users.add(new User(nextId++, "admin", "adminpass", "admin@app.com", "ADMIN"));
    }

    /**
     * Finds a user by their username (case-insensitive).
     * @param username The username to search for.
     * @return The User object if found, otherwise null.
     */
    public User getUserByUsername(String username) {
        for (User user : users) {
            if (user.getUsername().equalsIgnoreCase(username)) {
                return user;
            }
        }
        return null; // Not found
    }

    /**
     * Adds a new user to our simulated database.
     * @param user The User object to add (password should be plain text here).
     * @return true if added, false if username already exists.
     */
    public boolean addUser(User user) {
        // 1. Check if user already exists
        if (getUserByUsername(user.getUsername()) != null) {
            System.out.println("DAO: User " + user.getUsername() + " already exists.");
            return false; // Registration failed: Username taken
        }

        // 2. Set new ID and default role
        user.setId(nextId++);
        user.setRole("CUSTOMER");

        // 3. NOTE: In a real app, HASH the password *before* saving!
        // We are storing plain text for this mock example ONLY.
        // e.g., user.setPasswordHash(bcrypt.hash(user.getPasswordHash()));

        // 4. Add to our mock list
        users.add(user);

        System.out.println("DAO: User " + user.getUsername() + " successfully added.");
        return true; // Registration successful
    }

    /**
     * Authenticates a user by checking the list.
     * @param username The username.
     * @param password The plain-text password.
     * @return The User object if login is successful, otherwise null.
     */
    public User authenticateUser(String username, String password) {
        User user = getUserByUsername(username);

        // NOTE: In a real app, you would compare the HASH of the input password
        // with the stored hash!
        if (user != null && user.getPasswordHash().equals(password)) {
            System.out.println("DAO: Login success for " + username);
            return user;
        }

        System.out.println("DAO: Login failed for " + username);
        return null;
    }
}