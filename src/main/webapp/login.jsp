<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.foodapp.foodapp.UserDAO" %>
<%@ page import="org.foodapp.foodapp.User" %>

<%
    String errorMessage = null;
    if ("login".equals(request.getParameter("action"))) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        UserDAO userDAO = new UserDAO();
        User user = userDAO.authenticateUser(username, password);
        if (user != null) {
            session.setAttribute("user", user);
            session.setAttribute("loggedIn", true);
            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect("adminDashboard.jsp");
            } else {
                response.sendRedirect("menu.jsp");
            }
            return;
        } else {
            errorMessage = "Invalid username or password.";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - FoodApp</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body class="auth-body">

    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h1 class="auth-title">Welcome Back</h1>
                <p class="auth-subtitle">Sign in to continue your delicious journey.</p>
            </div>

            <% if (errorMessage != null) { %>
                <div class="alert alert-danger" role="alert">
                    <%= errorMessage %>
                </div>
            <% } %>
            <%
                String success = request.getParameter("success");
                if (success != null) {
            %>
                <div class="alert alert-success" role="alert">
                    <%= success %>
                </div>
            <% } %>

            <form action="login.jsp" method="post" class="auth-form">
                <input type="hidden" name="action" value="login">
                <div class="form-group">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" id="username" name="username" class="form-input" required autofocus>
                </div>
                <div class="form-group">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" id="password" name="password" class="form-input" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Login</button>
            </form>

            <div class="auth-footer">
                <p>Don't have an account? <a href="register.jsp">Sign up</a></p>
            </div>
        </div>
    </div>

</body>
</html>
