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
<html>
<head>
    <title>User Login</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/login.css">



</head>
<body>
<h1>Login to Food App</h1>

<%-- Display error message if present --%>
<%
    if (errorMessage != null) {
        out.println("<p style='color: red;'>" + errorMessage + "</p>");
    }
%>

<%-- Display success message from registration --%>
<%
    String success = request.getParameter("success");
    if (success != null) {
        out.println("<p style='color: green;'>" + success + "</p>");
    }
%>

<%-- The form now submits to ITSELF --%>
<form action="login.jsp" method="post">
    <%-- Add a hidden field to indicate a login attempt --%>
    <input type="hidden" name="action" value="login">

    <label for="username">Username:</label><br>
    <input type="text" id="username" name="username" required><br><br>

    <label for="password">Password:</label><br>
    <input type="password" id="password" name="password" required><br><br>

    <input type="submit" value="Login">
</form>

<p>Test credentials: (customer) testuser/pass | (admin) admin/adminpass</p>
<p>Don't have an account? <a href="register.jsp">Register here</a></p>
</body>
</html>