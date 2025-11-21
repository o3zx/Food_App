<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import classes --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.Order" %>
<%@ page import="org.foodapp.foodapp.OrderItem" %>
<%@ page import="org.foodapp.foodapp.OrderDAO" %>
<%@ page import="java.util.List" %>

<%
    // 1. General Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Get Order ID from URL
    int orderId = 0;
    try {
        orderId = Integer.parseInt(request.getParameter("orderId"));
    } catch (NumberFormatException e) {
        response.sendRedirect("menu.jsp");
        return;
    }

    // 3. Get Data
    OrderDAO orderDAO = new OrderDAO();
    Order order = orderDAO.getOrderById(orderId);
    List<OrderItem> items = orderDAO.getItemsForOrder(orderId);
    if(order == null) {
        response.sendRedirect("orderHistory.jsp?error=Order not found");
        return;
    }

    // Security check: Make sure this order belongs to this user OR user is admin
    boolean isCustomer = order.getUserId() == user.getId();
    boolean isAdmin = user.getRole().equals("ADMIN");
    boolean isAssignedDriver = order.getDriverId() == user.getId();
    if(!isCustomer && !isAdmin && !isAssignedDriver) {
        response.sendRedirect("login.jsp?error=Accses Denied");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order #<%= orderId %> - FoodApp</title>

    <!-- Global Styles -->
    <link rel="stylesheet" href="assets/css/style.css">
    <!-- Page-Specific Styles (Shared with viewOrderDetails) -->
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
            <% }
            else if ("DRIVER".equals(user.getRole())) { %>
            <a href="profile.jsp">Profile</a>
            <a href="logout">Logout</a>
            <% }
             else { %>
            <a href="menu.jsp">Menu</a>
            <a href="cart.jsp">🛒 Cart</a>
            <a href="orderHistory.jsp">My Orders</a>
            <a href="logout">Logout</a>
            <% } %>

        </nav>
    </div>
</header>

<!-- Main Content -->
<main class="track-main">
    <div class="container">

        <!-- Page Header -->
        <div class="page-header">
            <div class="page-header-content">
                <h1 class="page-title">Order Details</h1>
                <div class="order-meta">
                    <span class="order-id-badge">#<%= orderId %></span>
                    <% if (order != null) { %>
                    <span class="status-badge status-<%= order.getStatus().toLowerCase().replace(" ", "-") %>">
                                <%= order.getStatus() %>
                            </span>
                    <span class="order-date-text">
                                <%= new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(order.getOrderDate()) %>
                            </span>
                    <% } %>
                </div>
            </div>
            <div class="page-header-actions">

                <% if (!"ADMIN".equals(user.getRole()) && !"DRIVER".equals(user.getRole())) { %>
                <a href="trackOrder.jsp?orderId=<%= orderId %>" class="btn btn-primary">
                    <span class="btn-icon">📍</span>
                    Track Order
                </a>
                <% } %>


                <% if ("ADMIN".equals(user.getRole())) { %>
                <a href="adminDashboard.jsp" class="btn btn-outline">
                    <span class="btn-icon">←</span>
                    Dashboard
                </a>
                <% } else if ("DRIVER".equals(user.getRole())) { %>
                <a href="driverDashboard.jsp" class="btn btn-outline">Dashboard</a>
                <% } else { %>
                <a href="orderHistory.jsp" class="btn btn-outline">
                    <span class="btn-icon">←</span>
                    My Orders
                </a>
                <% } %>
            </div>
        </div>

        <!-- Order Items Card -->
        <% if (items.isEmpty()) { %>
        <!-- Empty State -->
        <div class="empty-state card">
            <div class="empty-state-icon">📋</div>
            <h3 class="empty-state-title">No Items Found</h3>
            <p class="empty-state-text">Could not find items for this order.</p>
            <% if ("ADMIN".equals(user.getRole())) { %>
            <a href="adminDashboard.jsp" class="btn btn-primary">Back to Dashboard</a>
            <% } else { %>
            <a href="orderHistory.jsp" class="btn btn-primary">Back to My Orders</a>
            <% } %>
        </div>
        <% } else { %>
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
        <% } %>

    </div>
</main>

</body>
</html>