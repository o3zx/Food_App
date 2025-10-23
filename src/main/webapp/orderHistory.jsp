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
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Order History</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/history.css">
</head>
<body>

    <div class="container">
        <div class="history-header">
            <h1>My Order History</h1>
            <div>
                <a href="menu.jsp" class="btn">Back to Menu</a>
                <a href="login.jsp" class="btn">Logout</a>
            </div>
        </div>

        <p>Welcome, <%= user.getUsername() %>!</p>

        <h2>Your Past Orders</h2>

        <% if (orders.isEmpty()) { %>
            <p>You have not placed any orders yet.</p>
        <% } else { %>
            <table class="styled-table">
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
                        <a href="viewOrderDetails.jsp?orderId=<%= order.getId() %>">View Details</a>
                    </td>
                </tr>
                <% } // End for loop %>
                </tbody>
            </table>
        <% } // End else %>
    </div>

</body>
</html>