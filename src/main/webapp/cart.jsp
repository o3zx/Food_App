<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import the necessary Java classes --%>
<%@ page import="org.foodapp.foodapp.ProductDAO" %>
<%@ page import="org.foodapp.foodapp.Product" %>
<%@ page import="org.foodapp.foodapp.CartItem" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="org.foodapp.foodapp.User" %>

<!DOCTYPE html>
<html>
<head>
    <title>Shopping Cart</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/cart.css">
</head>
</head>
<body>

<%
    // 1. Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Retrieve the Cart from Session (The Cart is a Map: Product ID -> CartItem)
    // Suppress unchecked warning for the type casting
    @SuppressWarnings("unchecked")
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

    // If the cart doesn't exist, create it
    if (cart == null) {
        cart = new HashMap<>();
        session.setAttribute("cart", cart); // Store the new cart in session
    }

    // 3. Handle Actions (Add/Remove)
    String action = request.getParameter("action");
    String productIdStr = request.getParameter("productId");

    ProductDAO productDAO = new ProductDAO();

    if (action != null && productIdStr != null) {
        try {
            int productId = Integer.parseInt(productIdStr);
            Product product = productDAO.getProductById(productId); // Get product info from DAO (MOCK)

            if ("add".equals(action) && product != null) {
                int quantity = 1;
                String quantityStr = request.getParameter("quantity");
                if (quantityStr != null) {
                    quantity = Integer.parseInt(quantityStr);
                }

                if (cart.containsKey(productId)) {
                    // Item is already in the cart, update quantity
                    CartItem existingItem = cart.get(productId);
                    existingItem.setQuantity(existingItem.getQuantity() + quantity);
                } else {
                    // New item, add to cart
                    cart.put(productId, new CartItem(product, quantity));
                }
            } else if ("remove".equals(action)) {
                // Remove the item entirely
                cart.remove(productId);
            }

            // Redirect to avoid form resubmission on refresh
            response.sendRedirect("cart.jsp");
            return;

        } catch (NumberFormatException e) {
            // Log or handle error if input is not a valid number
            System.out.println("Error parsing ID or quantity: " + e.getMessage());
        }
    }

    // Calculate total for display
    double cartTotal = 0.0;
    for (CartItem item : cart.values()) {
        cartTotal += item.getTotalPrice();
    }

    // Store total in request scope for EL display
    request.setAttribute("cartTotal", cartTotal);
%>

<h1>Shopping Cart</h1>
<a href="menu.jsp">Continue Shopping</a>
<hr>

<%
    if (cart.isEmpty()) {
%>
<p>Your cart is empty.</p>
<%
} else {
%>
<table border="1">
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
    <%
        // Loop through the cart items for display (Replaces <c:forEach>)
        for (CartItem item : cart.values()) {
    %>
    <tr>
        <td><%= item.getProduct().getName() %></td>
        <td>$<%= String.format("%.2f", item.getProduct().getPrice()) %></td>
        <td><%= item.getQuantity() %></td>
        <td>$<%= String.format("%.2f", item.getTotalPrice()) %></td>
        <td>
            <%-- Form to remove item --%>
            <form action="cart.jsp" method="post">
                <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                <input type="hidden" name="action" value="remove">
                <button type="submit">Remove</button>
            </form>
        </td>
    </tr>
    <%
        } // End of cart loop
    %>
    </tbody>
</table>

<h3>Cart Total: **$<%= String.format("%.2f", cartTotal) %>**</h3>

<p><a href="checkout.jsp">Proceed to Checkout</a></p>

<%
    } // End of cart empty check
%>
</body>
</html>