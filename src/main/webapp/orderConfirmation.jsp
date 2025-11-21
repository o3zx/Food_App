<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.foodapp.foodapp.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get the order ID we stored in placeOrder.jsp
    Integer orderId = (Integer) session.getAttribute("lastOrderId");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed - FoodApp</title>

    <!-- Global Styles -->
    <link rel="stylesheet" href="assets/css/style.css">
    <!-- Page-Specific Styles -->
    <link rel="stylesheet" href="assets/css/orderConfirmation.css">
</head>
<body class="confirmation-body">

<div class="confirmation-container">

    <!-- Success Animation -->
    <div class="success-animation">
        <svg class="checkmark" viewBox="0 0 52 52">
            <circle class="checkmark-circle" cx="26" cy="26" r="25" fill="none"/>
            <path class="checkmark-check" fill="none" d="M14.1 27.2l7.1 7.2 16.7-16.8"/>
        </svg>
    </div>

    <!-- Confirmation Card -->
    <div class="confirmation-card card">

        <!-- Thank You Header -->
        <div class="confirmation-header">
            <h1 class="confirmation-title">Thank You, <span class="user-name"><%= user.getUsername() %></span>!</h1>
            <p class="confirmation-subtitle">Your order has been placed successfully</p>
        </div>

        <!-- Order Details -->
        <div class="order-details">
            <% if (orderId != null) { %>
            <div class="order-id-display">
                <span class="order-id-label">Order ID</span>
                <span class="order-id-value">#<%= orderId %></span>
            </div>
            <div class="status-message">
                <div class="status-icon">🍳</div>
                <p>Your delicious meal is now being prepared by our chefs!</p>
            </div>
            <% } else { %>
            <div class="status-message">
                <div class="status-icon">✓</div>
                <p>Your order has been successfully placed.</p>
            </div>
            <% } %>
        </div>

        <!-- Timeline -->
        <div class="order-timeline">
            <div class="timeline-step completed">
                <div class="step-icon">✓</div>
                <div class="step-content">
                    <span class="step-title">Order Placed</span>
                    <span class="step-description">We've received your order</span>
                </div>
            </div>
            <div class="timeline-step active">
                <div class="step-icon">🍳</div>
                <div class="step-content">
                    <span class="step-title">Preparing</span>
                    <span class="step-description">Your meal is being prepared</span>
                </div>
            </div>
            <div class="timeline-step">
                <div class="step-icon">🚗</div>
                <div class="step-content">
                    <span class="step-title">Out for Delivery</span>
                    <span class="step-description">On the way to you</span>
                </div>
            </div>
            <div class="timeline-step">
                <div class="step-icon">🏠</div>
                <div class="step-content">
                    <span class="step-title">Delivered</span>
                    <span class="step-description">Enjoy your meal!</span>
                </div>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="orderHistory.jsp" class="btn btn-outline btn-lg">
                📋 View Order History
            </a>
            <a href="menu.jsp" class="btn btn-primary btn-lg">
                🍽️ Order Again
            </a>
        </div>

        <!-- Additional Info -->
        <div class="additional-info">
            <p class="info-text">
                You can track your order status in <a href="orderHistory.jsp">Order History</a>
            </p>
        </div>

    </div>

</div>

<%
    // Clean up the session attribute
    session.removeAttribute("lastOrderId");
%>

</body>
</html>