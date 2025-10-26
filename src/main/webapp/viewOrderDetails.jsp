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

    // Security check: Make sure this order belongs to this user OR user is admin
    if (order == null || (order.getUserId() != user.getId() && !"ADMIN".equals(user.getRole()))) {
        response.sendRedirect("orderHistory.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details #<%= orderId %> - Food Ordering App</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/main.css">
    <link rel="stylesheet" href="assets/css/orderDetails.css">
</head>
<body>
    <div class="details-container">
        <header class="details-header">
            <div class="header-content">
                <h1>Order Details #<%= orderId %></h1>
                <% if (order != null) { %>
                <div class="order-meta">
                    <span class="status-badge <%= order.getStatus().toLowerCase().replace(" ", "-") %>">
                        <%= order.getStatus() %>
                    </span>
                    <span class="order-date">
                        <%= new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(order.getOrderDate()) %>
                    </span>
                </div>
                <% } %>
            </div>
            <nav class="header-actions">
                <% if("ADMIN".equals(user.getRole())) { %>
                <a href="adminDashboard.jsp" class="btn">Back to Dashboard</a>
                <% } %>
                <a href="trackOrder.jsp?orderId=<%= orderId %>" class="btn btn-track">📍 Track Order</a>
            </nav>
        </header>

        <main class="details-content">
            <% if (items.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon">📋</div>
                    <p class="empty-message">Could not find items for this order.</p>
                </div>
            <% } else { %>
                <section class="order-items-section">
                    <h2>Order Items</h2>

                    <div class="table-container">
                        <table class="order-items-table">
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
                                    <td class="item-name"><%= item.getProductName() %></td>
                                    <td class="item-qty"><%= item.getQuantity() %></td>
                                    <td class="item-price">$<%= String.format("%.2f", item.getPriceAtTimeOfOrder()) %></td>
                                    <td class="item-subtotal">$<%= String.format("%.2f", subtotal) %></td>
                                </tr>
                                <% } %>
                            </tbody>
                            <tfoot>
                                <tr class="total-row">
                                    <td colspan="3">Total:</td>
                                    <td class="total-amount">$<%= String.format("%.2f", total) %></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </section>
            <% } %>
        </main>

        <footer class="details-footer">
            <% if ("ADMIN".equals(user.getRole())) { %>
                <a href="adminDashboard.jsp" class="btn-back">← Back to Dashboard</a>
            <% } else { %>
                <a href="orderHistory.jsp" class="btn-back">← Back to My Orders</a>
            <% } %>
        </footer>
    </div>
</body>
</html>