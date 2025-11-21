<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    NOTE: We removed the UserDAO imports.
    This page is now purely for display (View).
--%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - FoodApp</title>

    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/login.css">
</head>
<body class="auth-body">

<div class="auth-container">

    <div class="auth-card card">

        <div class="auth-logo">
            <span class="logo-text">FoodApp</span>
        </div>

        <div class="auth-header">
            <h1 class="auth-title">Welcome Back</h1>
            <p class="auth-subtitle">Sign in to continue your delicious journey</p>
        </div>

        <%-- 1. Check for Error Message sent from LoginServlet --%>
        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
        <div class="alert alert-error">
            <%= errorMessage %>
        </div>
        <% } %>

        <%-- 2. Check for URL parameters (e.g. from registration success) --%>
        <%
            String success = request.getParameter("success");
            if (success != null) {
        %>
        <div class="alert alert-success">
            <%= success %>
        </div>
        <% } %>

        <%
            String error = request.getParameter("error");
            if (error != null) {
        %>
        <div class="alert alert-error">
            <%= error %>
        </div>
        <% } %>

        <form action="login" method="post" class="auth-form">

            <div class="form-group">
                <label for="username" class="form-label">Username</label>
                <input
                        type="text"
                        id="username"
                        name="username"
                        class="form-input"
                        placeholder="Enter your username"
                        required
                        autofocus>
            </div>

            <div class="form-group">
                <label for="password" class="form-label">Password</label>
                <input
                        type="password"
                        id="password"
                        name="password"
                        class="form-input"
                        placeholder="Enter your password"
                        required>
            </div>

            <button type="submit" class="btn btn-primary btn-block btn-lg">
                Sign In
            </button>
        </form>

        <div class="auth-footer">
            <p class="auth-footer-text">
                Don't have an account?
                <a href="register.jsp" class="auth-link">Create one</a>
            </p>
        </div>

    </div>

    <div class="auth-info">
        <p class="auth-info-text">
            🍔 Order your favorite meals • 🚗 Fast delivery • ✨ Easy checkout
        </p>
    </div>

</div>

</body>
</html>