<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - FoodApp</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body class="auth-body">

    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h1 class="auth-title">Create an Account</h1>
                <p class="auth-subtitle">Join us and start ordering.</p>
            </div>

            <% 
                String error = request.getParameter("error");
                if (error != null) { 
            %>
                <div class="alert alert-danger" role="alert">
                    <%= error %>
                </div>
            <% } %>

            <form action="processRegistration.jsp" method="post" id="registrationForm" class="auth-form">
                <div class="form-group">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" id="username" name="username" class="form-input" required>
                </div>
                <div class="form-group">
                    <label for="email" class="form-label">Email Address</label>
                    <input type="email" id="email" name="email" class="form-input" required>
                </div>
                <div class="form-group">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" id="password" name="password" class="form-input" required>
                </div>
                <div class="form-group">
                    <label for="confirmPassword" class="form-label">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" required>
                </div>
                <div class="form-group">
                    <label for="address" class="form-label">Delivery Address</label>
                    <input type="text" id="address" name="address"  class="form-textarea" required></input>
                </div>
                <button type="submit" class="btn btn-primary w-100">Create Account</button>
            </form>

            <div class="auth-footer">
                <p>Already have an account? <a href="login.jsp">Login</a></p>
            </div>
        </div>
    </div>

</body>
</html>
