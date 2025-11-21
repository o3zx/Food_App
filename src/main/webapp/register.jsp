<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - FoodApp</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/register.css">
</head>
<body class="auth-body">

<div class="auth-container">

    <div class="auth-card card">

        <div class="auth-logo">
            <span class="logo-text">FoodApp</span>
        </div>

        <div class="auth-header">
            <h1 class="auth-title">Create an Account</h1>
            <p class="auth-subtitle">Join us and start ordering delicious meals</p>
        </div>

        <%
            // FIX: Check for the attribute sent by RegisterServlet
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
        <div class="alert alert-error">
            <%= errorMessage %>
        </div>
        <% } %>

        <form action="register" method="post" id="registrationForm" class="auth-form">

            <div class="form-group">
                <label for="username" class="form-label">Username</label>
                <input
                        type="text"
                        id="username"
                        name="username"
                        class="form-input"
                        placeholder="Choose a username"
                        required
                        autofocus>
            </div>

            <div class="form-group">
                <label for="email" class="form-label">Email Address</label>
                <input
                        type="email"
                        id="email"
                        name="email"
                        class="form-input"
                        placeholder="your.email@example.com"
                        required>
            </div>

            <div class="form-group">
                <label for="password" class="form-label">Password</label>
                <input
                        type="password"
                        id="password"
                        name="password"
                        class="form-input"
                        placeholder="Create a strong password"
                        required>
            </div>

            <div class="form-group">
                <label for="confirmPassword" class="form-label">Confirm Password</label>
                <input
                        type="password"
                        id="confirmPassword"
                        name="confirmPassword"
                        class="form-input"
                        placeholder="Re-enter your password"
                        required>
            </div>

            <div class="form-group">
                <label for="address" class="form-label">Delivery Address</label>
                <textarea
                        id="address"
                        name="address"
                        class="form-textarea"
                        rows="3"
                        placeholder="Enter your complete delivery address"
                        required></textarea>
                <span class="form-help">This will be your default delivery location</span>
            </div>

            <button type="submit" class="btn btn-primary btn-block btn-lg">
                Create Account
            </button>
        </form>

        <div class="auth-footer">
            <p class="auth-footer-text">
                Already have an account?
                <a href="login.jsp" class="auth-link">Sign in</a>
            </p>
        </div>

    </div>

    <div class="auth-info">
        <p class="auth-info-text">
            🍔 Order your favorite meals • 🚗 Fast delivery • ✨ Easy checkout
        </p>
    </div>

</div>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

</body>
</html>