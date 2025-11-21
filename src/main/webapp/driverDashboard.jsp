<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import all necessary classes --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.Order" %>
<%@ page import="org.foodapp.foodapp.OrderDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%

    User user = (User) session.getAttribute("user");
    if (user == null || !"DRIVER".equals(user.getRole())) {
        response.sendRedirect("login.jsp?error=Access Denied");
        return;
    }


    OrderDAO orderDAO = new OrderDAO();
    List<Order> orders = orderDAO.getOrdersByDriverId(user.getId());

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Driver Dashboard - My Deliveries</title>

    <!-- Global Styles -->
    <link rel="stylesheet" href="assets/css/style.css">
    <!-- Page-Specific Styles -->
    <link rel="stylesheet" href="assets/css/driverDashboard.css">
</head>
<body>

<!-- Main Header -->
<header class="main-header">
    <div class="container">
        <a href="driverDashboard.jsp" class="main-header-logo">FoodApp Driver</a>
        <nav class="main-header-nav">
            <span class="user-welcome">Welcome, <strong><%= user.getUsername() %></strong>!</span>
            <a href="logout" class="btn btn-outline">Logout</a>
        </nav>
    </div>
</header>

<!-- Main Content -->
<main class="driver-main">
    <div class="container">

        <!-- Dashboard Header -->
        <div class="dashboard-header">
            <div class="dashboard-header-content">
                <h1 class="page-title">My Deliveries</h1>
                <p class="page-subtitle">Manage your assigned delivery orders</p>
            </div>
            <div class="dashboard-stats">
                <div class="stat-card">
                    <div class="stat-value"><%= orders.size() %></div>
                    <div class="stat-label">Active Deliveries</div>
                </div>
            </div>
        </div>

        <!-- Deliveries Section -->
        <div class="deliveries-section">
            <div class="section-header">
                <h2 class="section-title">Assigned Orders</h2>
            </div>

            <% if (orders.isEmpty()) { %>
            <!-- Empty State -->
            <div class="empty-state card">
                <div class="empty-state-icon">🚗</div>
                <h3 class="empty-state-title">No Active Deliveries</h3>
                <p class="empty-state-text">You have no assigned deliveries at the moment. Check back soon for new orders!</p>
            </div>
            <% } else { %>
            <!-- Deliveries Table -->
            <div class="table-wrapper">
                <table class="styled-table deliveries-table">
                    <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Assigned Date</th>
                        <th>Delivery Address</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Order order : orders) { %>
                    <tr class="delivery-row">
                        <td>
                            <span class="order-id">#<%= order.getId() %></span>
                        </td>
                        <td>
                            <span class="order-date"><%= sdf.format(order.getOrderDate()) %></span>
                        </td>
                        <td>
                            <div class="address-cell">
                                <span class="address-icon">📍</span>
                                <span class="address-text"><%= order.getDeliveryAddress() %></span>
                            </div>
                        </td>
                        <td>
                                        <span class="status-badge status-<%= order.getStatus().toLowerCase().replace(" ", "-") %>">
                                            <%= order.getStatus() %>
                                        </span>
                        </td>
                        <td>
                            <div class="action-cell">
                                <form action="updateOrderStatus.jsp" method="post" class="delivery-form">
                                    <input type="hidden" name="orderId" value="<%= order.getId() %>">
                                    <input type="hidden" name="newStatus" value="Delivered">
                                    <input type="hidden" name="redirect" value="driverDashboard.jsp">
                                    <button type="submit" class="btn btn-sm btn-secondary">
                                        ✓ Mark as Delivered
                                    </button>
                                </form>

                                <a href="viewOrderDetails.jsp?orderId=<%= order.getId() %>" class="btn btn-sm btn-outline">
                                    View Items
                                </a>
                            </div>
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