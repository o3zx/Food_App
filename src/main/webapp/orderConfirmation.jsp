<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.foodapp.foodapp.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmed</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get the order ID we stored in placeOrder.jsp
    Integer orderId = (Integer) session.getAttribute("lastOrderId");
%>

<h1>Thank You, <%= user.getUsername() %>!</h1>

<% if (orderId != null) { %>
<p>Your order (ID: <strong><%= orderId %></strong>) has been placed successfully.</p>
<p>It is now being prepared.</p>
<% } else { %>
<p>Your order has been placed successfully.</p>
<% } %>

<p><a href="menu.jsp">Place Another Order</a></p>

<%
    // Clean up the session attribute
    session.removeAttribute("lastOrderId");
%>
</body>
</html>