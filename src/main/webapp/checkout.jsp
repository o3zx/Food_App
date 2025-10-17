<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import necessary classes --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.CartItem" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<!DOCTYPE html>
<html>
<head>
    <title>Checkout</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/cart.css">

</head>
<body>
<%
    // 1. Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Retrieve Cart
    @SuppressWarnings("unchecked")
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

    if (cart == null || cart.isEmpty()) {
        // Redirect to menu if cart is empty
        response.sendRedirect("menu.jsp");
        return;
    }

    // Calculate total
    double cartTotal = 0.0;
    for (CartItem item : cart.values()) {
        cartTotal += item.getTotalPrice();
    }
%>

<h1>Order Summary</h1>
<p>Please review your order before placing it.</p>

<table border="1">
    <thead>
    <tr>
        <th>Item</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Subtotal</th>
    </tr>
    </thead>
    <tbody>
    <%
        for (CartItem item : cart.values()) {
    %>
    <tr>
        <td><%= item.getProduct().getName() %></td>
        <td>$<%= String.format("%.2f", item.getProduct().getPrice()) %></td>
        <td><%= item.getQuantity() %></td>
        <td>$<%= String.format("%.2f", item.getTotalPrice()) %></td>
    </tr>
    <%
        } // End loop
    %>
    </tbody>
</table>

<h3>Total: **$<%= String.format("%.2f", cartTotal) %>**</h3>

<hr>

<%-- This form POSTs to our logic page --%>
<form action="placeOrder.jsp" method="post">
    <p>
        <strong>Deliver to:</strong> <%= user.getUsername() %> <br>
        (Address would go here)
    </p>
    <button type="submit" style="font-size: 1.2em;">Confirm & Place Order</button>
</form>

<p><a href="cart.jsp">Back to Cart</a></p>

</body>
</html>