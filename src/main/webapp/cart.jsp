<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import all your classes (User, CartItem, Product, ProductDAO, Map, etc.) --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.CartItem" %>
<%@ page import="org.foodapp.foodapp.Product" %>
<%@ page import="org.foodapp.foodapp.ProductDAO" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Enumeration" %>

<%
    // 1. Get user (if they are logged in). This can be null for guests.
    User user = (User) session.getAttribute("user");

    // 2. Retrieve Cart (Works for guests and users)
    @SuppressWarnings("unchecked")
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
    if (cart == null) {
        cart = new HashMap<>();
        session.setAttribute("cart", cart);
    }

    // 3. Handle Actions
    String action = request.getParameter("action");
    ProductDAO productDAO = new ProductDAO();

    // ---------------------------------------------------------------
    // 4. LOGIC BLOCK TO HANDLE BATCH UPDATES FROM MENU
    // ---------------------------------------------------------------
    if ("batchUpdate".equals(action)) {

        // --- FIX: THIS IS THE "GATE" ---
        // If a guest (user == null) tries to add items, redirect them to login.
        if (user == null) {
            response.sendRedirect("login.jsp?error=Please log in to add items to your cart.");
            return;
        }
        // --- END FIX ---

        // Get all parameters from the form
        Enumeration<String> paramNames = request.getParameterNames();

        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();

            if (paramName.startsWith("quantity_")) {
                try {
                    int quantity = Integer.parseInt(request.getParameter(paramName));
                    int productId = Integer.parseInt(paramName.substring(9));

                    if (quantity > 0) {
                        if (cart.containsKey(productId)) {
                            cart.get(productId).setQuantity(quantity);
                        } else {
                            Product product = productDAO.getProductById(productId);
                            if (product != null) {
                                cart.put(productId, new CartItem(product, quantity));
                            }
                        }
                    } else if (quantity == 0) {
                        cart.remove(productId);
                    }
                } catch (NumberFormatException e) {
                    System.out.println("Error parsing batch update: " + e.getMessage());
                }
            }
        }
        response.sendRedirect("cart.jsp");
        return;
    }

    // --- Logic for "remove" (Guests can also remove items) ---
    String productIdStr = request.getParameter("productId");
    if ("remove".equals(action) && productIdStr != null) {
        try {
            int productId = Integer.parseInt(productIdStr);
            cart.remove(productId);

            // Redirect to avoid re-processing on refresh
            response.sendRedirect("cart.jsp");
            return;
        } catch (NumberFormatException e) {
            // Handle error
        }
    }

    // 5. Calculate Total (Do this *after* all logic)
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
    <title>Shopping Cart - FoodApp</title>

    <!-- Global Styles -->
    <link rel="stylesheet" href="assets/css/style.css">
    <!-- Page-Specific Styles -->
    <link rel="stylesheet" href="assets/css/cart.css">
</head>
<body>

<!-- Main Header -->
<header class="main-header">
    <div class="container">
        <a href="menu.jsp" class="main-header-logo">FoodApp</a>
        <nav class="main-header-nav">
            <a href="menu.jsp">Menu</a>
            <a href="cart.jsp" class="active">🛒 Cart</a>
            <% if (user != null) { %>
            <a href="orderHistory.jsp">My Orders</a>
            <a href="profile.jsp">Profile</a>
            <a href="logout">Logout</a>
            <% } else { %>
            <a href="login.jsp" class="btn btn-primary">Login / Register</a>
            <% } %>
        </nav>
    </div>
</header>

<!-- Main Content -->
<main class="cart-main">
    <div class="container">

        <!-- Page Header -->
        <div class="page-header">
            <div class="page-header-content">
                <h1 class="page-title">Shopping Cart</h1>
                <% if (!cart.isEmpty()) { %>
                <p class="page-subtitle"><%= cart.size() %> item<%= cart.size() != 1 ? "s" : "" %> in your cart</p>
                <% } %>
            </div>
            <div class="page-header-actions">
                <a href="menu.jsp" class="btn btn-outline">
                    <span class="btn-icon">←</span>
                    Continue Shopping
                </a>
            </div>
        </div>

        <!-- Cart Content -->
        <% if (cart.isEmpty()) { %>
        <!-- Empty Cart State -->
        <div class="empty-cart card">
            <div class="empty-cart-icon">🛒</div>
            <h2 class="empty-cart-title">Your cart is empty</h2>
            <p class="empty-cart-text">Looks like you haven't added any delicious items yet.</p>
            <a href="menu.jsp" class="btn btn-primary">Browse Menu</a>
        </div>
        <% } else { %>
        <!-- Cart with Items -->
        <div class="cart-layout">

            <!-- Cart Items Section -->
            <div class="cart-items-section">
                <div class="section-header">
                    <h2 class="section-title">Your Items</h2>
                </div>

                <div class="cart-items-wrapper">
                    <table class="styled-table cart-table">
                        <thead>
                        <tr>
                            <th>Item</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Subtotal</th>
                            <th>Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (CartItem item : cart.values()) { %>
                        <tr class="cart-item-row">
                            <td>
                                <div class="item-info">
                                    <span class="item-name"><%= item.getProduct().getName() %></span>
                                </div>
                            </td>
                            <td>
                                <span class="item-price">$<%= String.format("%.2f", item.getProduct().getPrice()) %></span>
                            </td>
                            <td>
                                <span class="item-quantity"><%= item.getQuantity() %></span>
                            </td>
                            <td>
                                <span class="item-subtotal">$<%= String.format("%.2f", item.getTotalPrice()) %></span>
                            </td>
                            <td>
                                <form action="cart.jsp" method="post" class="remove-form">
                                    <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                                    <input type="hidden" name="action" value="remove">
                                    <button type="submit" class="btn btn-sm btn-danger">Remove</button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Cart Summary Section -->
            <div class="cart-summary-section">
                <div class="cart-summary card">
                    <h2 class="summary-title">Order Summary</h2>

                    <div class="summary-details">
                        <div class="summary-row">
                            <span class="summary-label">Items (<%= cart.size() %>):</span>
                            <span class="summary-value">$<%= String.format("%.2f", cartTotal) %></span>
                        </div>
                        <div class="summary-row summary-divider"></div>
                        <div class="summary-row summary-total">
                            <span class="summary-label">Total:</span>
                            <span class="summary-value">$<%= String.format("%.2f", cartTotal) %></span>
                        </div>
                    </div>

                    <div class="summary-actions">
                        <% if (user != null) { %>
                        <a href="checkout.jsp" class="btn btn-primary btn-block">Proceed to Checkout</a>
                        <% } else { %>
                        <a href="login.jsp?error=Please log in to check out." class="btn btn-primary btn-block">Login to Checkout</a>
                        <% } %>
                    </div>

                    <div class="summary-footer">
                        <p class="summary-note">🔒 Secure checkout guaranteed</p>
                    </div>
                </div>
            </div>

        </div>
        <% } %>

    </div>
</main>

</body>
</html>