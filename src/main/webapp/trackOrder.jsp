<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import all necessary classes --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.Order" %>
<%@ page import="org.foodapp.foodapp.OrderItem" %>
<%@ page import="org.foodapp.foodapp.OrderDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // 1. Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }


    // 2. Get Order ID and Fetch Data
    Order order = null;
    List<OrderItem> items = null;
    int orderId = 0;

    try {
        orderId = Integer.parseInt(request.getParameter("orderId"));
        OrderDAO orderDAO = new OrderDAO();

        order = orderDAO.getOrderById(orderId);
        items = orderDAO.getItemsForOrder(orderId);

    } catch (NumberFormatException e) {
        // Handle bad ID
    }

    // Security check: Make sure this order belongs to this user OR user is admin
    if (order == null || (order.getUserId() != user.getId() && !"ADMIN".equals(user.getRole()))) {
        response.sendRedirect("orderHistory.jsp");
        return;
    }

    // --- 3. LOGIC FOR THE VISUAL TRACKER ---
    String step1 = "completed"; // "Pending" is always done if order exists
    String step2 = "";
    String step3 = "";
    String step4 = "";
    String progressPercent = "10%"; // Start progress

    String status = order.getStatus();

    // Use a switch with fall-through to set completed steps
    switch(status) {
        case "Delivered":
            step4 = "completed";
            progressPercent = "90%"; // Full width
        case "Out for Delivery":
            step3 = "completed";
            if(progressPercent.equals("10%")) progressPercent = "60%";
        case "Preparing":
            step2 = "completed";
            if(progressPercent.equals("10%")) progressPercent = "35%";
        case "Pending":
            // step1 is already completed
            break;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Order #<%= orderId %> - FoodApp</title>

    <!-- Global Styles -->
    <link rel="stylesheet" href="assets/css/style.css">
    <!-- Page-Specific Styles -->
    <link rel="stylesheet" href="assets/css/viewOrderDetails.css">
</head>
<body>

<!-- Main Header -->
<header class="main-header">
    <div class="container">
        <a href="menu.jsp" class="main-header-logo">FoodApp</a>
        <nav class="main-header-nav">
            <% if("ADMIN".equals(user.getRole())) { %>
            <a href="adminDashboard.jsp">Dashboard</a>
            <a href="adminManageProducts.jsp">Products</a>
            <% } else { %>
            <a href="menu.jsp">Menu</a>
            <a href="cart.jsp">🛒 Cart</a>
            <a href="orderHistory.jsp">My Orders</a>
            <a href="profile.jsp">Profile</a>
            <% } %>
            <a href="logout">Logout</a>
        </nav>
    </div>
</header>

<!-- Main Content -->
<main class="track-main">
    <div class="container">

        <!-- Page Header -->
        <div class="page-header">
            <div class="page-header-content">
                <h1 class="page-title">Track Your Order</h1>
                <p class="page-subtitle">Order ID: <span class="order-id-badge">#<%= orderId %></span></p>
            </div>
            <div class="page-header-actions">
                <% if("ADMIN".equals(user.getRole())) { %>
                <a href="adminDashboard.jsp" class="btn btn-outline">
                    <span class="btn-icon">←</span>
                    Back to Dashboard
                </a>
                <% } else { %>
                <a href="orderHistory.jsp" class="btn btn-outline">
                    <span class="btn-icon">←</span>
                    My Orders
                </a>
                <% } %>
            </div>
        </div>

        <!-- Status Tracker Card -->
        <div class="card status-tracker-card">
            <div class="card-header">
                <h2 class="card-title">Order Status</h2>
            </div>
            <div class="card-body">

                <!-- Visual Progress Tracker -->
                <div class="progress-tracker">
                    <div class="progress-bar">
                        <div class="progress-fill" style="width: <%= progressPercent %>;"></div>
                    </div>

                    <div class="tracker-steps">
                        <div class="tracker-step <%= step1 %>">
                            <div class="step-circle">
                                <span class="step-icon">📦</span>
                            </div>
                            <span class="step-label">Pending</span>
                        </div>

                        <div class="tracker-step <%= step2 %>">
                            <div class="step-circle">
                                <span class="step-icon">🍳</span>
                            </div>
                            <span class="step-label">Preparing</span>
                        </div>

                        <div class="tracker-step <%= step3 %>">
                            <div class="step-circle">
                                <span class="step-icon">🚗</span>
                            </div>
                            <span class="step-label">Out for Delivery</span>
                        </div>

                        <div class="tracker-step <%= step4 %>">
                            <div class="step-circle">
                                <span class="step-icon">✓</span>
                            </div>
                            <span class="step-label">Delivered</span>
                        </div>
                    </div>
                </div>

                <!-- Current Status Badge -->
                <div class="current-status">
                    <span class="status-label">Current Status:</span>
                    <span class="status-badge status-<%= status.toLowerCase().replace(" ", "-") %>">
                            <%= order.getStatus() %>
                        </span>
                </div>

            </div>
        </div>

        <!-- Order Details Card -->
        <div class="card order-details-card">
            <div class="card-header">
                <h2 class="card-title">Order Items</h2>
            </div>
            <div class="card-body">

                <div class="table-wrapper">
                    <table class="styled-table order-items-table">
                        <thead>
                        <tr>
                            <th>Item Name</th>
                            <th>Quantity</th>
                            <th>Price</th>
                            <th>Subtotal</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            double total = 0.0;
                            for (OrderItem item : items) {
                                double subtotal = item.getPriceAtTimeOfOrder() * item.getQuantity();
                                total += subtotal;
                        %>
                        <tr>
                            <td>
                                <span class="item-name"><%= item.getProductName() %></span>
                            </td>
                            <td>
                                <span class="item-quantity">× <%= item.getQuantity() %></span>
                            </td>
                            <td>
                                <span class="item-price">$<%= String.format("%.2f", item.getPriceAtTimeOfOrder()) %></span>
                            </td>
                            <td>
                                <span class="item-subtotal">$<%= String.format("%.2f", subtotal) %></span>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                        <tfoot>
                        <tr class="total-row">
                            <td colspan="3" class="total-label">Total:</td>
                            <td class="total-amount">$<%= String.format("%.2f", total) %></td>
                        </tr>
                        </tfoot>
                    </table>
                </div>

            </div>
        </div>

    </div>
</main>

</body>
</html>