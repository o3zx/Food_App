<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import classes --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.Order" %>
<%@ page import="org.foodapp.foodapp.OrderItem" %>
<%@ page import="org.foodapp.foodapp.OrderDAO" %>
<%@ page import="java.util.List" %>

<%
    // 1. General Authentication Check (Must be logged in)
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
        // Redirect if ID is missing or invalid
        response.sendRedirect("menu.jsp");
        return;
    }

    // 3. Get Data
    OrderDAO orderDAO = new OrderDAO();
    List<OrderItem> items = orderDAO.getItemsForOrder(orderId);

    // (Security Note: A real app would also check if this orderId
    // belongs to this user. We'll skip that for our mock.)
%>

<!DOCTYPE html>
<html>
<head>
    <title>Order Details</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/history.css">
</head>
<body>
<h1>Details for Order #<%= orderId %></h1>

<% if (items.isEmpty()) { %>
<p>Could not find items for this order.</p>
<% } else { %>
<table>
    <thead>
    <tr>
        <th>Item Name</th>
        <th>Quantity</th>
        <th>Price (at time of order)</th>
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
        <td><%= item.getProductName() %></td>
        <td><%= item.getQuantity() %></td>
        <td>$<%= String.format("%.2f", item.getPriceAtTimeOfOrder()) %></td>
        <td>$<%= String.format("%.2f", subtotal) %></td>
    </tr>
    <% } // End for loop %>
    <tr>
        <td colspan="3" style="text-align: right;"><strong>Total:</strong></td>
        <td><strong>$<%= String.format("%.2f", total) %></strong></td>
    </tr>
    </tbody>
</table>
<% } // End else %>

<%-- Navigation: Go back to the correct page --%>
<% if ("ADMIN".equals(user.getRole())) { %>
<p><a href="adminDashboard.jsp">Back to Dashboard</a></p>
<% } else { %>
<p><a href="orderHistory.jsp">Back to My Orders</a></p>
<% } %>

</body>
</html>