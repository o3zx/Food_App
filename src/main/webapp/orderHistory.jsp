<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import classes --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.Order" %>
<%@ page import="org.foodapp.foodapp.OrderDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // 1. Customer Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null || "ADMIN".equals(user.getRole())) {
        // Redirect if not logged in or if they are an admin
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Get Data
    OrderDAO orderDAO = new OrderDAO();
    // Use the new method to get orders for THIS user
    List<Order> orders = orderDAO.getOrdersByUserId(user.getId());

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Order History</title>
    <title>My Order History</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/history.css">
</head>
<body>
<h1>My Order History</h1>
<p>Welcome, <%= user.getUsername() %>! | <a href="menu.jsp">Back to Menu</a> | <a href="logout.jsp">Logout</a></p>

<h2>Your Past Orders</h2>

<% if (orders.isEmpty()) { %>
<p>You have not placed any orders yet.</p>
<% } else { %>
<table>
    <thead>
    <tr>
        <th>Order ID</th>
        <th>Date</th>
        <th>Total</th>
        <th>Status</th>
        <th>Details</th>
    </tr>
    </thead>
    <tbody>
    <% for (Order order : orders) { %>
    <tr>
        <td><%= order.getId() %></td>
        <td><%= sdf.format(order.getOrderDate()) %></td>
        <td>$<%= String.format("%.2f", order.getTotalAmount()) %></td>
        <td><%= order.getStatus() %></td>
        <td>
            <%-- This links to a new page we will create --%>
            <a href="viewOrderDetails.jsp?orderId=<%= order.getId() %>">View Details</a>
        </td>
    </tr>
    <% } // End for loop %>
    </tbody>
</table>
<% } // End else %>

</body>
</html>