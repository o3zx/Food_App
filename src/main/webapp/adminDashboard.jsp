<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import classes --%>
<%@ page import="org.foodapp.foodapp.User" %>
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

    // Formatter for the date
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/admin.css">

</head>
<body>
<h1>Admin Dashboard</h1>
<p>Welcome, <%= user.getUsername() %>! | <a href="logout.jsp">Logout</a></p>

<h2>All Orders</h2>

<% if (orders.isEmpty()) { %>
<p>No orders have been placed yet.</p>
<% } else { %>
<table>
    <thead>
    <tr>
        <th>Order ID</th>
        <th>User ID</th>
        <th>Date</th>
        <th>Total</th>
        <th>Status</th>
        <th>Action</th>
    </tr>
    </thead>
    <tbody>
    <% for (Order order : orders) { %>
    <tr>
        <td><%= order.getId() %></td>
        <td><%= order.getUserId() %></td>
        <td><%= sdf.format(order.getOrderDate()) %></td>
        <td>$<%= String.format("%.2f", order.getTotalAmount()) %></td>
        <td><%= order.getStatus() %></td>
        <td>
            <%-- This form posts to our new logic page --%>
            <form action="updateOrderStatus.jsp" method="post" style="display:inline;">
                <input type="hidden" name="orderId" value="<%= order.getId() %>">
                <select name="newStatus">
                    <option value="Preparing" <% if ("Preparing".equals(order.getStatus())) out.print("selected"); %>>Preparing</option>
                    <option value="Out for Delivery" <% if ("Out for Delivery".equals(order.getStatus())) out.print("selected"); %>>Out for Delivery</option>
                    <option value="Delivered" <% if ("Delivered".equals(order.getStatus())) out.print("selected"); %>>Delivered</option>
                    <option value="Cancelled" <% if ("Cancelled".equals(order.getStatus())) out.print("selected"); %>>Cancelled</option>
                </select>
                <button type="submit">Update</button>
            </form>
            <%-- We'll need an 'viewOrderDetails.jsp' page next --%>
            <%-- <a href="viewOrderDetails.jsp?orderId=<%= order.getId() %>">View</a> --%>
                <a href="viewOrderDetails.jsp?orderId=<%= order.getId() %>">View Details</a>
        </td>
    </tr>
    <% } // End for loop %>
    </tbody>
</table>
<% } // End else %>

</body>
</html>