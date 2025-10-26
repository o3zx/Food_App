<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import the necessary classes --%>
<%@ page import="org.foodapp.foodapp.UserDAO" %>
<%@ page import="org.foodapp.foodapp.User" %>

<%
    // 1. Get Form Parameters
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");
    String address = request.getParameter("address");

    // --- 2. Server-Side Validation ---

    // Check for null or empty fields
    if (username == null || username.trim().isEmpty() ||
        email == null || email.trim().isEmpty() ||
        password == null || password.isEmpty()) {

        response.sendRedirect("register.jsp?error=All fields are required.");
        return;
    }
    // validate Address
    if (address == null || address.trim().isEmpty()) {
        response.sendRedirect("register.jsp?error=Address is required.");
        return;
    }

    // Check if passwords match
    if (!password.equals(confirmPassword)) {
        response.sendRedirect("register.jsp?error=Passwords do not match.");
        return;
    }

    // --- 3. Process Registration ---

    UserDAO userDAO = new UserDAO();

    try {
        // --- FIX 1 ---
        // Check if the username is already taken
        if (userDAO.getUserByUsername(username) != null) {
            response.sendRedirect("register.jsp?error=Username is already taken.");
            return;
        }

        // Create the new User object
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setEmail(email);

        // --- FIX 2 ---
        // Set the password hash (using plain text for this mock)
        newUser.setPasswordHash(password);

        // set address
        newUser.setAddress(address);
        // The DAO will set the ID and Role automatically

        // --- FIX 3 ---
        // Attempt to register the user
        boolean success = userDAO.addUser(newUser);

        if (success) {
            // --- 4. Success ---
            response.sendRedirect("login.jsp?success=Registration successful. Please log in.");
        } else {
            // --- 5. Failure (DAO returned false) ---
            response.sendRedirect("register.jsp?error=An error occurred. Please try again.");
        }

    } catch (Exception e) {
        // Handle any database or other exceptions
        response.sendRedirect("register.jsp?error=A server error occurred.");
        e.printStackTrace(); // Log the error for debugging
    }
%>