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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Food Ordering App</title>
    <link rel="stylesheet" href="assets/css/admin.css">
</head>
<body>
  <div class="admin-dashboard">
      <header class="dashboard-header">
          <h1>Admin Dashboard</h1>
          <div class="user-info">
              <span>Welcome, <strong><%= user.getUsername() %></strong>!</span>
              <a href="login.jsp" class="logout-btn">Logout</a>
          </div>
      </header>

      <section class="orders-section">
          <h2>All Orders</h2>

          <% if (orders.isEmpty()) { %>
              <p class="no-orders">No orders have been placed yet.</p>
          <% } else { %>
              <div class="table-container">
                  <table class="orders-table">
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
                            <a href="viewOrderDetails.jsp?orderId=<%= order.getId() %>">View Details</a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</body>
</html>
