<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import necessary classes --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.UserDAO" %>

<%
    // 1. Check if user is already logged in
    if (session.getAttribute("user") != null) {
        response.sendRedirect("menu.jsp");
        return;
    }

    // 2. Get form parameters
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");

    // 3. Server-side Validation
    if (username == null || email == null || password == null ||
            username.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {

        response.sendRedirect("register.jsp?error=All fields are required.");
        return;
    }

    if (!password.equals(confirmPassword)) {
        response.sendRedirect("register.jsp?error=Passwords do not match.");
        return;
    }

    // 4. Create User object and DAO
    UserDAO userDAO = new UserDAO();

    // We store the plain-text password. (See DAO note about hashing)
    User newUser = new User();
    newUser.setUsername(username);
    newUser.setEmail(email);
    newUser.setPasswordHash(password);

    // 5. Attempt to add user
    boolean isSuccess = userDAO.addUser(newUser);

    // 6. Redirect based on outcome
    if (isSuccess) {
        // Success! Redirect to login page with a success message
        response.sendRedirect("login.jsp?success=Registration successful! Please log in.");
    } else {
        // Failure (Username likely taken)
        response.sendRedirect("register.jsp?error=Username already taken. Please choose another.");
    }
%>