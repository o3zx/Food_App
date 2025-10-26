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
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Your Order - Food Ordering App</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/main.css">
    <link rel="stylesheet" href="assets/css/track.css">
</head>
<body>
    <div class="track-container">
        <header class="track-header">
            <% if("ADMIN".equals(user.getRole())) { %>
            <a href="adminDashboard.jsp" class="btn">Back to Dashboard</a>
            <% } %>
            <h1>Track Order #<%= orderId %></h1>
            <a href="orderHistory.jsp" class="btn-back">Back to My Orders</a>
            <a href="profile.jsp">My Profile</a>
        </header>

        <div class="status-card">
            <div class="status-tracker">
                <div class="progress-line" style="width: <%= progressPercent %>;"></div>

                <div class="step <%= step1 %>">
                    <div class="step-icon">✔</div>
                    <div class="step-label">Pending</div>
                </div>

                <div class="step <%= step2 %>">
                    <div class="step-icon">🍳</div>
                    <div class="step-label">Preparing</div>
                </div>

                <div class="step <%= step3 %>">
                    <div class="step-icon">🚚</div>
                    <div class="step-label">Out for Delivery</div>
                </div>

                <div class="step <%= step4 %>">
                    <div class="step-icon">✓</div>
                    <div class="step-label">Delivered</div>
                </div>
            </div>

            <div class="current-status">
                <span class="status-label">Current Status:</span>
                <span class="status-value <%= status.toLowerCase().replace(" ", "-") %>"><%= order.getStatus() %></span>
            </div>
        </div>

        <section class="order-details-section">
            <h2>Order Details</h2>

            <div class="table-container">
                <table class="order-details-table">
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
    </div>
</body>
</html>