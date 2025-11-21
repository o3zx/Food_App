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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Order Summary</title>

    <!-- Global Styles -->
    <link rel="stylesheet" href="assets/css/style.css">
    <!-- Page-Specific Styles -->
    <link rel="stylesheet" href="assets/css/checkout.css">
</head>
<body>

<!-- Main Header -->
<header class="main-header">
    <div class="container">
        <a href="menu.jsp" class="main-header-logo">FoodApp</a>
        <nav class="main-header-nav">
            <a href="menu.jsp">Menu</a>
            <a href="cart.jsp">🛒 Cart</a>
            <a href="orderHistory.jsp">My Orders</a>
            <a href="profile.jsp">Profile</a>
            <a href="logout">Logout</a>
        </nav>
    </div>
</header>

<!-- Main Content -->
<main class="checkout-main">
    <div class="container">

        <!-- Checkout Progress -->
        <div class="checkout-progress">
            <div class="progress-step completed">
                <div class="step-circle">✓</div>
                <span class="step-label">Cart</span>
            </div>
            <div class="progress-line"></div>
            <div class="progress-step active">
                <div class="step-circle">2</div>
                <span class="step-label">Review Order</span>
            </div>
            <div class="progress-line"></div>
            <div class="progress-step">
                <div class="step-circle">3</div>
                <span class="step-label">Payment</span>
            </div>
        </div>

        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">Order Summary</h1>
            <p class="page-subtitle">Please review your order before proceeding to payment</p>
        </div>

        <!-- Checkout Layout -->
        <div class="checkout-layout">

            <!-- Order Details Section -->
            <div class="order-details-section">

                <!-- Order Items Card -->
                <div class="card order-items-card">
                    <div class="card-header">
                        <h2 class="card-title">Your Items (<%= cart.size() %>)</h2>
                    </div>
                    <div class="card-body">
                        <div class="items-table-wrapper">
                            <table class="styled-table checkout-table">
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
                                    <td>
                                        <span class="item-name"><%= item.getProduct().getName() %></span>
                                    </td>
                                    <td>
                                        <span class="item-price">$<%= String.format("%.2f", item.getProduct().getPrice()) %></span>
                                    </td>
                                    <td>
                                        <span class="item-quantity">× <%= item.getQuantity() %></span>
                                    </td>
                                    <td>
                                        <span class="item-subtotal">$<%= String.format("%.2f", item.getTotalPrice()) %></span>
                                    </td>
                                </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Delivery Information Card -->
                <div class="card delivery-card">
                    <div class="card-header">
                        <h2 class="card-title">Delivery Information</h2>
                    </div>
                    <div class="card-body">
                        <div class="delivery-info">
                            <div class="info-item">
                                <div class="info-icon">👤</div>
                                <div class="info-content">
                                    <span class="info-label">Deliver to:</span>
                                    <span class="info-value"><%= user.getUsername() %></span>
                                </div>
                            </div>
                            <div class="info-item">
                                <div class="info-icon">📍</div>
                                <div class="info-content">
                                    <span class="info-label">Address:</span>
                                    <span class="info-value"><%= user.getAddress() %></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- Order Summary Sidebar -->
            <div class="order-summary-section">
                <div class="card order-summary-card">
                    <div class="card-header">
                        <h2 class="card-title">Order Total</h2>
                    </div>
                    <div class="card-body">
                        <div class="summary-details">
                            <div class="summary-row">
                                <span class="summary-label">Subtotal:</span>
                                <span class="summary-value">$<%= String.format("%.2f", cartTotal) %></span>
                            </div>
                            <div class="summary-row">
                                <span class="summary-label">Delivery Fee:</span>
                                <span class="summary-value summary-free">Free</span>
                            </div>
                            <div class="summary-divider"></div>
                            <div class="summary-row summary-total">
                                <span class="summary-label">Total:</span>
                                <span class="summary-value">$<%= String.format("%.2f", cartTotal) %></span>
                            </div>
                        </div>

                        <form action="payment.jsp" method="post" class="checkout-form">
                            <button type="submit" class="btn btn-primary btn-block btn-lg">
                                Proceed to Payment
                            </button>
                        </form>

                        <div class="summary-footer">
                            <a href="cart.jsp" class="btn btn-outline btn-block">
                                <span class="btn-icon">←</span>
                                Back to Cart
                            </a>
                        </div>

                        <div class="security-badges">
                            <span class="security-badge">🔒 Secure Payment</span>
                            <span class="security-badge">✓ Easy Refunds</span>
                        </div>
                    </div>
                </div>
            </div>

        </div>

    </div>
</main>

</body>
</html>