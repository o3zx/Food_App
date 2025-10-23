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
    // 1. Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Retrieve Cart
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
    // 4. NEW LOGIC BLOCK TO HANDLE BATCH UPDATES FROM MENU
    // ---------------------------------------------------------------
    if ("batchUpdate".equals(action)) {

        // Get all parameters from the form
        Enumeration<String> paramNames = request.getParameterNames();

        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();

            // Check if this is one of our quantity inputs
            if (paramName.startsWith("quantity_")) {
                try {
                    // Get the quantity value
                    int quantity = Integer.parseInt(request.getParameter(paramName));

                    // Get the product ID from the name (e.g., "quantity_101" -> 101)
                    int productId = Integer.parseInt(paramName.substring(9));

                    if (quantity > 0) {
                        // If quantity is > 0, add/update it in the cart
                        if (cart.containsKey(productId)) {
                            // Already in cart, just update quantity
                            cart.get(productId).setQuantity(quantity);
                        } else {
                            // Not in cart, fetch product and add new CartItem
                            Product product = productDAO.getProductById(productId);
                            if (product != null) {
                                cart.put(productId, new CartItem(product, quantity));
                            }
                        }
                    } else if (quantity == 0) {
                        // If quantity is 0, remove it from the cart
                        cart.remove(productId);
                    }

                } catch (NumberFormatException e) {
                    System.out.println("Error parsing batch update: " + e.getMessage());
                }
            }
        }

        // After processing, redirect to the cart page to view the result
        response.sendRedirect("cart.jsp");
        return;
    }

    // --- (Your old logic for "add" and "remove" from the cart page itself) ---
    // This logic will still work for changes made ON the cart page.

    String productIdStr = request.getParameter("productId");
    if ("add".equals(action) && productIdStr != null) {
        // ... your existing logic for adding 1
    }
    if ("remove".equals(action) && productIdStr != null) {
        // ... your existing logic for removing
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
    <title>Shopping Cart</title>
    <link rel="stylesheet" href="assets/css/cart.css">
</head>
<body>
    <div class="cart-container">
        <header class="cart-header">
            <h1>Shopping Cart</h1>
            <a href="menu.jsp" class="btn-continue">Continue Shopping</a>
        </header>

        <% if (cart.isEmpty()) { %>
            <div class="empty-cart">
                <p>Your cart is empty.</p>
                <a href="menu.jsp" class="btn-shop">Start Shopping</a>
            </div>
        <% } else { %>
            <div class="cart-content">
                <div class="table-container">
                    <table class="cart-table">
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
                                <td class="item-name"><%= item.getProduct().getName() %></td>
                                <td class="item-price">$<%= String.format("%.2f", item.getProduct().getPrice()) %></td>
                                <td class="item-quantity"><%= item.getQuantity() %></td>
                                <td class="item-subtotal">$<%= String.format("%.2f", item.getTotalPrice()) %></td>
                                <td class="item-action">
                                    <form action="cart.jsp" method="post" class="remove-form">
                                        <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                                        <input type="hidden" name="action" value="remove">
                                        <button type="submit" class="btn-remove">Remove</button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <div class="cart-summary">
                    <div class="total-section">
                        <h3>Cart Total:</h3>
                        <p class="total-amount">$<%= String.format("%.2f", cartTotal) %></p>
                    </div>
                    <a href="checkout.jsp" class="btn-checkout">Proceed to Checkout</a>
                </div>
            </div>
        <% } %>
    </div>
</body>
</html>