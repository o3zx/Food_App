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
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/cart.css">
</head>
<body>

<header class="main-header">
    <a href="menu.jsp" class="logo">FoodApp</a>
    <nav>
        <a href="cart.jsp">🛒 Cart</a>
        <% if (user != null) { %>
        <a href="orderHistory.jsp">My Orders</a>
        <a href="profile.jsp">My Profile</a>
        <a href="logout.jsp">Logout</a>
        <% } else { %>
        <a href="login.jsp" class="btn">Login / Register</a>
        <% } %>
    </nav>
</header>

<div class="container">
    <div class="history-header"> <h1>Shopping Cart</h1>
        <a href="menu.jsp" class="btn">Continue Shopping</a>
    </div>

    <% if (cart.isEmpty()) { %>
    <div class="card" style="padding: 40px; text-align: center;">
        <h2>Your cart is empty.</h2>
        <p style="margin-top: 10px;">Looks like you haven't added any items yet.</p>
        <a href="menu.jsp" class="btn" style="margin-top: 20px;">Start Shopping</a>
    </div>
    <% } else { %>
    <div class="cart-container">
        <div class="cart-items">
            <table class="styled-table">
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
                <tr>
                    <td><%= item.getProduct().getName() %></td>
                    <td>$<%= String.format("%.2f", item.getProduct().getPrice()) %></td>
                    <td><%= item.getQuantity() %></td>
                    <td>$<%= String.format("%.2f", item.getTotalPrice()) %></td>
                    <td>
                        <form action="cart.jsp" method="post">
                            <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                            <input type="hidden" name="action" value="remove">
                            <button type="submit" class="btn-danger" style="padding: 8px 12px; width: auto;">Remove</button>
                        </form>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <div class="cart-summary">
            <h2>Cart Summary</h2>
            <div class="cart-summary-row cart-summary-total">
                <span>Total:</span>
                <span>$<%= String.format("%.2f", cartTotal) %></span>
            </div>

            <% if (user != null) { %>
            <a href="checkout.jsp" class="btn" style="width: 100%;">Proceed to Checkout</a>
            <% } else { %>
            <a href="login.jsp?error=Please log in to check out." class="btn" style="width: 100%;">Login to Check Out</a>
            <% } %>

        </div>
    </div>
    <% } %>
</div>
</body>
</html>