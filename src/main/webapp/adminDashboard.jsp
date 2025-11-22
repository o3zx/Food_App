<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import all necessary classes --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.UserDAO" %>
<%@ page import="org.foodapp.foodapp.Order" %>
<%@ page import="org.foodapp.foodapp.OrderDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // 1. Admin Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp?error=Access Denied");
        return;
    }

    // 2. Get Data
    OrderDAO orderDAO = new OrderDAO();
    List<Order> orders = orderDAO.getAllOrders();

    // 3. Get all available drivers
    UserDAO userDAO = new UserDAO();
    List<User> drivers = userDAO.getUsersByRole("DRIVER");

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Order Management</title>

    <!-- Global Styles -->
    <link rel="stylesheet" href="assets/css/style.css">
    <!-- Page-Specific Styles -->
    <link rel="stylesheet" href="assets/css/adminDashboard.css">
</head>
<body>

<!-- Main Header -->
<header class="main-header">
    <div class="container">
        <a href="adminDashboard.jsp" class="main-header-logo">FoodApp Admin</a>
        <nav class="main-header-nav">
            <a href="adminDashboard.jsp" class="active">Orders</a>
            <a href="adminManageProducts.jsp">Products</a>
            <a href="logout">Logout</a>
        </nav>
    </div>
</header>

<!-- Main Content -->
<main class="admin-main">
    <div class="container">

        <!-- Dashboard Header -->
        <div class="dashboard-header">
            <div class="dashboard-header-content">
                <h1 class="page-title">Order Management</h1>
                <p class="page-subtitle">View and manage all customer orders</p>
            </div>
            <div class="dashboard-header-actions">
                <a href="adminManageProducts.jsp" class="btn btn-outline">
                    <span class="btn-icon">🍔</span>
                    Manage Products
                </a>
            </div>
        </div>

        <!-- Orders Section -->
        <div class="orders-section">
            <div class="section-header">
                <h2 class="section-title">All Orders (<%= orders.size() %>)</h2>
            </div>

            <% if (orders.isEmpty()) { %>
            <div class="empty-state card">
                <div class="empty-state-icon">📦</div>
                <h3 class="empty-state-title">No Orders Yet</h3>
                <p class="empty-state-text">Orders will appear here once customers start placing them.</p>
            </div>
            <% } else { %>
            <div class="table-wrapper">
                <table class="styled-table orders-table">
                    <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Customer ID</th>
                        <th>Date & Time</th>
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
                            <span class="user-id">User <%= order.getUserId() %></span>
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
                            <div class="action-cell">
                                <%-- LOGIC FOR ACTIONS BASED ON STATUS --%>

                                <% if (order.getStatus().equals("Pending")) { %>
                                <form action="adminOrderAction" method="post" class="status-form">
                                    <input type="hidden" name="action" value="assign">
                                    <input type="hidden" name="orderId" value="<%= order.getId() %>">
                                    <div class="driver-select-group">
                                        <select name="driverId" class="form-select form-select-sm" required>
                                            <option value="">-- Assign Driver --</option>
                                            <% for (User driver : drivers) { %>
                                            <option value="<%= driver.getId() %>"><%= driver.getUsername() %></option>
                                            <% } %>
                                        </select>
                                        <button type="submit" class="btn btn-sm btn-primary">Assign</button>
                                    </div>
                                </form>

                                <% } else if (order.getStatus().equals("Out for Delivery")) { %>
                                <div class="driver-info">
                                    <span class="driver-label">Driver ID: <%= order.getDriverId() %></span>
                                </div>

                                <% } else if (order.getStatus().equals("Delivered") || order.getStatus().equals("Cancelled")) { %>
                                <div class="completed-actions">
                                    <span class="status-label"><%= order.getStatus() %></span>
                                    <form action="adminOrderAction" method="post" class="delete-form">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="orderId" value="<%= order.getId() %>">
                                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?');">
                                            Delete
                                        </button>
                                    </form>
                                </div>

                                <% } else { %>
                                <form action="updateOrderStatus.jsp" method="post" class="update-status-form">
                                    <input type="hidden" name="orderId" value="<%= order.getId() %>">
                                    <div class="status-select-group">
                                        <select name="newStatus" class="form-select form-select-sm">
                                            <option value="Preparing" <% if ("Preparing".equals(order.getStatus())) out.print("selected"); %>>Preparing</option>
                                            <option value="Cancelled" <% if ("Cancelled".equals(order.getStatus())) out.print("selected"); %>>Cancelled</option>
                                        </select>
                                        <button type="submit" class="btn btn-sm btn-secondary">Update</button>
                                    </div>
                                </form>
                                <% } %>

                                <a href="viewOrderDetails.jsp?orderId=<%= order.getId() %>" class="btn btn-sm btn-outline view-details-btn">
                                    View Details
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