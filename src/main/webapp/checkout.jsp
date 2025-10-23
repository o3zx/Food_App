<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import necessary classes --%>
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

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Food Ordering App</title>
    <link rel="stylesheet" href="assets/css/checkout.css">
</head>
<body>
    <div class="checkout-container">
        <header class="checkout-header">
            <h1>Order Summary</h1>
            <p class="subtitle">Please review your order before placing it.</p>
        </header>

        <div class="checkout-content">
            <section class="order-items">
                <h2>Your Items</h2>
                <div class="table-container">
                    <table class="checkout-table">
                        <thead>
                            <tr>
                                <th>Item</th>
                                <th>Price</th>
                                <th>Quantity</th>
                                <th>Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (CartItem item : cart.values()) { %>
                            <tr>
                                <td class="item-name"><%= item.getProduct().getName() %></td>
                                <td class="item-price">$<%= String.format("%.2f", item.getProduct().getPrice()) %></td>
                                <td class="item-quantity"><%= item.getQuantity() %></td>
                                <td class="item-subtotal">$<%= String.format("%.2f", item.getTotalPrice()) %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <div class="order-total">
                    <span class="total-label">Total:</span>
                    <span class="total-amount">$<%= String.format("%.2f", cartTotal) %></span>
                </div>
            </section>

            <section class="delivery-section">
                <h2>Delivery Information</h2>
                <div class="delivery-info">
                    <div class="info-row">
                        <strong>Deliver to:</strong>
                        <span><%= user.getUsername() %></span>
                    </div>
                    <div class="info-row">
                        <strong>Address:</strong>
                        <span>(Address would go here)</span>
                    </div>
                </div>
            </section>

            <form action="payment.jsp" method="post" class="checkout-form">
                <button type="submit" class="btn">Proceed to Payment</button>
            </form>

            <div class="checkout-actions">
                <a href="cart.jsp" class="btn-back">Back to Cart</a>
            </div>
        </div>
    </div>
</body>
</html>