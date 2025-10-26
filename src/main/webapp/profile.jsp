<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.foodapp.foodapp.User" %>
<%
    // 1. Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Get any messages from our logic page
    String successMessage = request.getParameter("success");
    String errorMessage = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<header class="main-header">
    <a href="menu.jsp" class="logo">FoodApp</a>
    <nav>
        <a href="cart.jsp">🛒 Cart</a>
        <a href="orderHistory.jsp">My Orders</a>
        <a href="logout.jsp">Logout</a>
    </nav>
</header>

<div class="container">
    <div class="profile-card">
        <h1>My Profile</h1>

        <% if (successMessage != null) { %>
        <p class="success-message" style="margin-bottom: 20px;"><%= successMessage %></p>
        <% } %>
        <% if (errorMessage != null) { %>
        <p class="error-message" style="margin-bottom: 20px;"><%= errorMessage %></p>
        <% } %>

        <div class="form-group">
            <label>Username:</label>
            <p><%= user.getUsername() %></p>
        </div>
        <div class="form-group">
            <label>Email:</label>
            <p><%= user.getEmail() %></p>
        </div>

        <hr style="margin: 30px 0;">

        <form action="updateProfile.jsp" method="post">
            <h2>Update Your Address</h2>
            <div class="form-group">
                <label for="address">Address:</label>
                <textarea id="address" name="address" rows="4" class="form-group input" required><%= user.getAddress() %></textarea>
            </div>
            <button type="submit" class="btn">Save Address</button>
        </form>
    </div>
</div>
</form>

<hr style="margin: 30px 0;">

<form action="updatePassword.jsp" method="post" id="passwordForm">
    <h2>Change Password</h2>

    <div class="form-group">
        <label for="currentPassword">Current Password:</label>
        <input type="password" id="currentPassword" name="currentPassword" class="form-group input" required>
    </div>

    <div class="form-group">
        <label for="newPassword">New Password:</label>
        <input type="password" id="newPassword" name="newPassword" class="form-group input" required>
    </div>

    <div class="form-group">
        <label for="confirmPassword">Confirm New Password:</label>
        <input type="password" id="confirmPassword" name="confirmPassword" class="form-group input" required>
    </div>

    <button type="submit" class="btn">Change Password</button>
</form>

</div> </div> <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>


</body>
</html>