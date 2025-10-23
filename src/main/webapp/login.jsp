<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import DAO and Model --%>
<%@ page import="org.foodapp.foodapp.UserDAO" %>
<%@ page import="org.foodapp.foodapp.User" %>

<%
    // --- LOGIN LOGIC ---
    String errorMessage = null;

    // Check if the form was submitted (by checking the 'action' parameter)
    if ("login".equals(request.getParameter("action"))) {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.authenticateUser(username, password);

        if (user != null) {
            // SUCCESS: Create session
            session.setAttribute("user", user);
            session.setAttribute("loggedIn", true);

            // --- ROLE-BASED REDIRECT ---
            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect("adminDashboard.jsp");
            } else {
                response.sendRedirect("menu.jsp");
            }
            return; // Stop processing

        } else {
            // FAILURE
            errorMessage = "Invalid username or password.";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Food Ordering App</title>
    <link rel="stylesheet" href="assets/css/login.css">
</head>
<body>
    <div class="login-container">

        <h1>Login to Food App</h1>

        <%-- Display error message if present --%>
        <%
            if (errorMessage != null) {
                out.println("<p class='message-error'>" + errorMessage + "</p>");
            }
        %>

        <%-- Display success message from registration --%>
        <%
            String success = request.getParameter("success");
            if (success != null) {
                out.println("<p class='message-success'>" + success + "</p>");
            }
        %>

        <%-- The form now submits to ITSELF --%>
      <form action="login.jsp" method="post" class="login-form">
          <input type="hidden" name="action" value="login">

          <div class="form-group">
              <label for="username">Username:</label>
              <input type="text" id="username" name="username" required>
          </div>

          <div class="form-group">
              <label for="password">Password:</label>
              <input type="password" id="password" name="password" required>
          </div>

          <button type="submit" class="btn-login">Login</button>
      </form>

        <div class="login-links">
            <p>Test credentials: (customer) testuser/pass | (admin) admin/adminpass</p>
            <p>Don't have an account? <a href="register.jsp">Register here</a></p>
        </div>
    </div>
</body>
</html>
