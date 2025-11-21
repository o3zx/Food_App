<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import classes (Using your package) --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.Order" %>
<%@ page import="org.foodapp.foodapp.OrderDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // 1. Customer Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null || "ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Get Data
    OrderDAO orderDAO = new OrderDAO();
    List<Order> orders = orderDAO.getOrdersByUserId(user.getId());
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order History - FoodApp</title>

    <!-- Global Styles -->
    <link rel="stylesheet" href="assets/css/style.css">
    <!-- Page-Specific Styles -->
    <link rel="stylesheet" href="assets/css/orderHistory.css">
</head>
<body>

<!-- Main Header -->
<header class="main-header">
    <div class="container">
        <a href="menu.jsp" class="main-header-logo">FoodApp</a>
        <nav class="main-header-nav">
            <a href="menu.jsp">Menu</a>
            <a href="cart.jsp">🛒 Cart</a>
            <a href="orderHistory.jsp" class="active">My Orders</a>
            <a href="profile.jsp">Profile</a>
            <a href="logout">Logout</a>
        </nav>
    </div>
</header>

<!-- Main Content -->
<main class="history-main">
    <div class="container">

        <!-- Page Header -->
        <div class="page-header">
            <div class="page-header-content">
                <h1 class="page-title">My Order History</h1>
                <p class="page-subtitle">Welcome back, <span class="user-name"><%= user.getUsername() %></span>! Track all your past orders here.</p>
            </div>
            <div class="page-header-actions">
                <a href="menu.jsp" class="btn btn-primary">
                    <span class="btn-icon">🍽️</span>
                    Order Now
                </a>
            </div>
        </div>

        <!-- Orders Section -->
        <div class="orders-section">

            <% if (orders.isEmpty()) { %>
            <!-- Empty State -->
            <div class="empty-state card">
                <div class="empty-state-icon">📦</div>
                <h3 class="empty-state-title">No Orders Yet</h3>
                <p class="empty-state-text">You haven't placed any orders yet. Start exploring our delicious menu!</p>
                <a href="menu.jsp" class="btn btn-primary">Browse Menu</a>
            </div>
            <% } else { %>
            <!-- Orders Stats -->
            <div class="orders-stats">
                <div class="stat-card">
                    <div class="stat-value"><%= orders.size() %></div>
                    <div class="stat-label">Total Orders</div>
                </div>
            </div>

            <!-- Orders Table -->
            <div class="table-wrapper">
                <table class="styled-table orders-table">
                    <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Order Date</th>
                        <th>Total Amount</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Order order : orders) { %>
                    <tr class="order-row">
                        <td>
                            <span class="order-id">#<%= order.getId() %></span>
                        </td>
                        <td>
                            <span class="order-date"><%= sdf.format(order.getOrderDate()) %></span>
                        </td>
                        <td>
                            <span class="order-total">$<%= String.format("%.2f", order.getTotalAmount()) %></span>
                        </td>
                        <td>
                                        <span class="status-badge status-<%= order.getStatus().toLowerCase().replace(" ", "-") %>">
                                            <%= order.getStatus() %>
                                        </span>
                        </td>
                        <td>
                            <a href="viewOrderDetails.jsp?orderId=<%= order.getId() %>" class="btn btn-sm btn-outline">
                                View Details
                            </a>
                        </td>
                    </tr>
                    <% } // End for loop %>
                    </tbody>
                </table>
            </div>
            <% } // End else %>
        </div>

    </div>
</main>

</body>
</html>