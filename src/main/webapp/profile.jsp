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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - FoodApp</title>

    <!-- Global Styles -->
    <link rel="stylesheet" href="assets/css/style.css">
    <!-- Page-Specific Styles -->
    <link rel="stylesheet" href="assets/css/profile.css">
</head>
<body>

<!-- Main Header -->
<header class="main-header">
    <div class="container">
        <a href="menu.jsp" class="main-header-logo">FoodApp</a>
        <nav class="main-header-nav">
            <a href="menu.jsp">Menu</a>
            <a href="cart.jsp">🛒 Cart</a>
            <a href="orderHistory.jsp">My Orders</a>
            <a href="profile.jsp" class="active">Profile</a>
            <a href="logout">Logout</a>
        </nav>
    </div>
</header>

<!-- Main Content -->
<main class="profile-main">
    <div class="container">

        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">My Profile</h1>
            <p class="page-subtitle">Manage your account settings and information</p>
        </div>

        <!-- Alert Messages -->
        <% if (successMessage != null) { %>
        <div class="alert alert-success">
            <%= successMessage %>
        </div>
        <% } %>
        <% if (errorMessage != null) { %>
        <div class="alert alert-error">
            <%= errorMessage %>
        </div>
        <% } %>

        <div class="profile-layout">

            <!-- Profile Info Card -->
            <div class="card profile-info-card">
                <div class="card-header">
                    <h2 class="card-title">Account Information</h2>
                </div>
                <div class="card-body">
                    <div class="info-grid">
                        <div class="info-item">
                            <span class="info-label">Username</span>
                            <span class="info-value"><%= user.getUsername() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Email</span>
                            <span class="info-value"><%= user.getEmail() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Role</span>
                            <span class="info-value role-badge"><%= user.getRole() %></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Update Address Card -->
            <div class="card address-card">
                <div class="card-header">
                    <h2 class="card-title">Delivery Address</h2>
                </div>
                <div class="card-body">
                    <form action="updateProfile.jsp" method="post" class="profile-form">
                        <div class="form-group">
                            <label for="address" class="form-label">Address</label>
                            <textarea
                                    id="address"
                                    name="address"
                                    rows="4"
                                    class="form-textarea"
                                    placeholder="Enter your delivery address"
                                    required><%= user.getAddress() %></textarea>
                            <span class="form-help">This address will be used for all your deliveries</span>
                        </div>
                        <button type="submit" class="btn btn-primary">
                            Save Address
                        </button>
                    </form>
                </div>
            </div>

            <!-- Change Password Card -->
            <div class="card password-card">
                <div class="card-header">
                    <h2 class="card-title">Change Password</h2>
                </div>
                <div class="card-body">
                    <form action="updatePassword.jsp" method="post" id="passwordForm" class="profile-form">

                        <div class="form-group">
                            <label for="currentPassword" class="form-label">Current Password</label>
                            <input
                                    type="password"
                                    id="currentPassword"
                                    name="currentPassword"
                                    class="form-input"
                                    placeholder="Enter your current password"
                                    required>
                        </div>

                        <div class="form-group">
                            <label for="newPassword" class="form-label">New Password</label>
                            <input
                                    type="password"
                                    id="newPassword"
                                    name="newPassword"
                                    class="form-input"
                                    placeholder="Enter your new password"
                                    required>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword" class="form-label">Confirm New Password</label>
                            <input
                                    type="password"
                                    id="confirmPassword"
                                    name="confirmPassword"
                                    class="form-input"
                                    placeholder="Confirm your new password"
                                    required>
                        </div>

                        <button type="submit" class="btn btn-secondary">
                            Change Password
                        </button>
                    </form>
                </div>
            </div>

        </div>

    </div>
</main>

<!-- JavaScript -->
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

</body>
</html>