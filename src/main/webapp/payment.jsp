<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import all necessary classes --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.CartItem" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
    // 1. Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Retrieve Cart and Calculate Total
    @SuppressWarnings("unchecked")
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

    if (cart == null || cart.isEmpty()) {
        response.sendRedirect("menu.jsp");
        return;
    }

    double cartTotal = 0.0;
    for (CartItem item : cart.values()) {
        cartTotal += item.getTotalPrice();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Payment</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/payment.css">
</head>
<body>

<div class="container">
    <div class="login-container">
        <div class="login-card"> <h1>Complete Your Payment</h1>

            <div class="payment-summary">
                Total: <%= String.format("$%.2f", cartTotal) %>
            </div>

            <form action="placeOrder.jsp" method="post">

                <div class="payment-selection">
                    <div class="payment-option">
                        <input type="radio" id="paypal" name="paymentMethod" value="paypal" checked>
                        <label for="paypal">Pay with PayPal</label>
                    </div>

                    <div class="payment-option">
                        <input type="radio" id="applepay" name="paymentMethod" value="applepay">
                        <label for="applepay">Pay with Apple Pay</label>
                    </div>

                    <div class="payment-option">
                        <input type="radio" id="card" name="paymentMethod" value="card">
                        <label for="card">Pay with Credit Card (Test)</label>
                    </div>
                </div>

                <button type="submit" class="btn" style="margin-top: 25px;">
                    Pay <%= String.format("$%.2f", cartTotal) %>
                </button>
            </form>
        </div>
    </div>
</div>

</body>
</html>