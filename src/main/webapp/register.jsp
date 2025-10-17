<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/login.css">

</head>
</head>
<body>
<h1>Create a New Account</h1>

<%-- Check for error messages from the processing page --%>
<%
    String error = request.getParameter("error");
    if (error != null) {
        out.println("<p style='color: red;'>" + error + "</p>");
    }
%>

<%-- The form POSTs to our new logic page --%>
<%-- We use the 'onsubmit' event to call our JavaScript validation --%>
<form action="processRegistration.jsp" method="post" id="registrationForm">
    <label for="username">Username:</label><br>
    <input type="text" id="username" name="username" required><br><br>

    <label for="email">Email:</label><br>
    <input type="email" id="email" name="email" required><br><br>

    <label for="password">Password:</label><br>
    <input type="password" id="password" name="password" required><br><br>

    <label for="confirmPassword">Confirm Password:</label><br>
    <input type="password" id="confirmPassword" name="confirmPassword" required><br><br>

    <input type="submit" value="Register">
</form>

<p>Already have an account? <a href="login.jsp">Login here</a></p>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>