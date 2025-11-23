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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - FoodApp</title>

    <!-- Global Styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <!-- Page-Specific Styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/payment.css">
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
<main class="payment-main">
    <div class="container">

        <!-- Checkout Progress -->
        <div class="checkout-progress">
            <div class="progress-step completed">
                <div class="step-circle">✓</div>
                <span class="step-label">Cart</span>
            </div>
            <div class="progress-line"></div>
            <div class="progress-step completed">
                <div class="step-circle">✓</div>
                <span class="step-label">Review Order</span>
            </div>
            <div class="progress-line"></div>
            <div class="progress-step active">
                <div class="step-circle">3</div>
                <span class="step-label">Payment</span>
            </div>
        </div>

        <!-- Payment Card -->
        <div class="payment-card card">

            <!-- Payment Header -->
            <div class="payment-header">
                <h1 class="payment-title">Complete Your Payment</h1>
                <p class="payment-subtitle">Choose your preferred payment method</p>
            </div>

            <!-- Payment Summary -->
            <div class="payment-summary">
                <div class="summary-row">
                    <span class="summary-label">Total Amount:</span>
                    <span class="summary-value">$<%= String.format("%.2f", cartTotal) %></span>
                </div>
            </div>

            <!-- Payment Form -->
            <form action="placeOrder" method="post">
                <div class="payment-methods">
                    <h2 class="section-title">Select Payment Method</h2>

                    <div class="payment-options">

                        <!-- PayPal Option -->
                        <label class="payment-option" for="paypal">
                            <input type="radio" id="paypal" name="paymentMethod" value="paypal" checked>
                            <div class="option-content">
                                <div class="option-icon">
                                    <img src="https://raw.githubusercontent.com/datatrans/payment-logos/master/assets/apm/paypal.svg" alt="PayPal" class="payment-logo">
                                </div>
                                <div class="option-details">
                                    <span class="option-name">PayPal</span>
                                    <span class="option-description">Pay securely with PayPal</span>
                                </div>
                            </div>
                            <div class="option-checkmark">✓</div>
                        </label>

                        <!-- Apple Pay Option -->
                        <label class="payment-option" for="applepay">
                            <input type="radio" id="applepay" name="paymentMethod" value="applepay">
                            <div class="option-content">
                                <div class="option-icon">
                                    <img src="https://raw.githubusercontent.com/datatrans/payment-logos/master/assets/wallets/apple-pay.svg" alt="Apple Pay" class="payment-logo">
                                </div>
                                <div class="option-details">
                                    <span class="option-name">Apple Pay</span>
                                    <span class="option-description">Quick and secure payment</span>
                                </div>
                            </div>
                            <div class="option-checkmark">✓</div>
                        </label>

                        <!-- Credit Card Option -->
                        <label class="payment-option" for="card">
                            <input type="radio" id="card" name="paymentMethod" value="card">
                            <div class="option-content">
                                <div class="option-icon payment-icon-group">
                                    <img src="https://raw.githubusercontent.com/datatrans/payment-logos/master/assets/cards/visa.svg" alt="Visa" class="payment-logo-small">
                                    <img src="https://raw.githubusercontent.com/datatrans/payment-logos/master/assets/cards/mastercard.svg" alt="Mastercard" class="payment-logo-small">
                                </div>
                                <div class="option-details">
                                    <span class="option-name">Credit/Debit Card</span>
                                    <span class="option-description">Visa, Mastercard & more</span>
                                </div>
                            </div>
                            <div class="option-checkmark">✓</div>
                        </label>

                    </div>
                </div>

                <!-- Submit Button -->
                <div class="payment-actions">
                    <button type="submit" class="btn btn-primary btn-lg btn-block">
                        🔒 Pay $<%= String.format("%.2f", cartTotal) %>
                    </button>
                    <a href="checkout.jsp" class="btn btn-outline btn-block">
                        <span class="btn-icon">←</span>
                        Back to Order Review
                    </a>
                </div>

                <!-- Security Note -->
                <div class="security-note">
                    <span class="security-icon">🔒</span>
                    <p>Your payment information is encrypted and secure</p>
                </div>

            </form>

        </div>

    </div>
</main>

</body>
</html>