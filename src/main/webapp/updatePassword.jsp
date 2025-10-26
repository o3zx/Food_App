<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import all necessary classes --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.UserDAO" %>

<%
    // 1. Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Get all form parameters
    String currentPassword = request.getParameter("currentPassword");
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");

    String redirectURL = "profile.jsp";

    // 3. Server-side Validation
    if (currentPassword == null || newPassword == null || confirmPassword == null ||
            currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {

        redirectURL += "?error=All password fields are required.";
        response.sendRedirect(redirectURL);
        return;
    }

    if (!newPassword.equals(confirmPassword)) {
        redirectURL += "?error=New passwords do not match.";
        response.sendRedirect(redirectURL);
        return;
    }

    if (newPassword.length() < 6) {
        redirectURL += "?error=Password must be at least 6 characters long.";
        response.sendRedirect(redirectURL);
        return;
    }

    // 4. Call the DAO to attempt the update
    UserDAO userDAO = new UserDAO();
    boolean success = userDAO.updateUserPassword(user.getId(), currentPassword, newPassword);

    if (success) {
        // 5. Redirect back with a success message
        redirectURL += "?success=Password changed successfully!";
    } else {
        // 5. Redirect back with an error message
        redirectURL += "?error=Password update failed. Please check your current password.";
    }

    response.sendRedirect(redirectURL);
%>