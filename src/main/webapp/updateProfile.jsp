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

    // 2. Get the new address from the form
    String newAddress = request.getParameter("address");

    // 3. Simple Validation
    if (newAddress == null || newAddress.trim().isEmpty()) {
        response.sendRedirect("profile.jsp?error=Address cannot be empty.");
        return;
    }

    // 4. Call the DAO to update the database
    UserDAO userDAO = new UserDAO();
    boolean success = userDAO.updateUserAddress(user.getId(), newAddress);

    if (success) {
        // 5. IMPORTANT: Update the user object in the SESSION
        // If we don't do this, the old address will keep showing
        user.setAddress(newAddress);
        session.setAttribute("user", user);

        // 6. Redirect back with a success message
        response.sendRedirect("profile.jsp?success=Address updated successfully!");
    } else {
        // 6. Redirect back with an error message
        response.sendRedirect("profile.jsp?error=Failed to update address.");
    }
%>