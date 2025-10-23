<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Food Ordering App</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="assets/css/auth.css">
</head>
<body>
    <div class="auth-container">
        <h1>Create a New Account</h1>

        <%-- Check for error messages from the processing page --%>
        <%
            String error = request.getParameter("error");
            if (error != null) {
                out.println("<p class='message-error'>" + error + "</p>");
            }
        %>

        <form action="processRegistration.jsp" method="post" id="registrationForm" class="auth-form">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
            </div>

            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
            </div>

            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required minlength="6">
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm Password:</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
            </div>

            <p id="js-error" class="message-error" style="display: none;"></p>

            <button type="submit" class="btn-submit">Register</button>
        </form>

        <div class="auth-links">
            <p>Already have an account? <a href="login.jsp">Login here</a></p>
        </div>
    </div>

    <script src="assets/js/main.js"></script>
</body>
</html>