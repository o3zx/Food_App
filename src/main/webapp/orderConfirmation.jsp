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
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed - Food Ordering App</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/main.css">
    <link rel="stylesheet" href="assets/css/order_confirmed.css">
</head>
<body>
    <div class="confirmation-container">
        <div class="success-icon">
            <svg class="checkmark" viewBox="0 0 52 52">
                <circle class="checkmark-circle" cx="26" cy="26" r="25" fill="none"/>
                <path class="checkmark-check" fill="none" d="M14.1 27.2l7.1 7.2 16.7-16.8"/>
            </svg>
        </div>

        <h1>Thank You, <span class="username"><%= user.getUsername() %></span>!</h1>

        <div class="confirmation-message">
            <% if (orderId != null) { %>
                <p class="order-id">Your order ID: <strong>#<%= orderId %></strong></p>
                <p class="status-message">Your order has been placed successfully and is now being prepared.</p>
            <% } else { %>
                <p class="status-message">Your order has been placed successfully.</p>
            <% } %>
        </div>

        <div class="action-buttons">
            <a href="orderHistory.jsp" class="btn-secondary">View Order History</a>
            <a href="menu.jsp" class="btn-primary">Place Another Order</a>
        </div>
    </div>

<%
    // Clean up the session attribute
    session.removeAttribute("lastOrderId");
%>
</body>
</html>