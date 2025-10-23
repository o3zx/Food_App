<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import the necessary Java classes --%>
<%@ page import="org.foodapp.foodapp.ProductDAO" %>
<%@ page import="org.foodapp.foodapp.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="org.foodapp.foodapp.User" %>

<%
    // 1. Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Data Retrieval
    ProductDAO productDAO = new ProductDAO();
    List<Product> products = productDAO.getAllProducts();

    // 3. Store data in Request Scope
    request.setAttribute("products", products);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Food Menu - Food Ordering App</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/menu.css">
</head>
<body>

<header class="main-header">
    <a href="menu.jsp" class="logo">FoodApp</a>
    <nav>
        <a href="cart.jsp">🛒 Cart</a>
        <a href="orderHistory.jsp">My Orders</a>
        <a href="logout.jsp">Logout</a>
    </nav>
</header>

<div class="container">
    <div class="welcome-header">
        <h1>Welcome, <%= user.getUsername() %>!</h1>
        <h2>Today's Menu</h2>
    </div>

    <form action="cart.jsp" method="post" id="menu-form">
        <input type="hidden" name="action" value="batchUpdate">

        <div class="product-list">
            <% for (Product product : products) { %>
            <div class="product-card">

                <div class="product-card-body">
                    <h3><%= product.getName() %></h3>
                    <p><%= product.getDescription() %></p>
                </div>

                <div class="product-card-footer">
                    <span class="product-price">$<%= String.format("%.2f", product.getPrice()) %></span>

                    <div class="form-group">
                        <label for="quantity-<%= product.getId() %>">Qty:</label>
                        <input type="number"
                               id="quantity-<%= product.getId() %>"
                               name="quantity_<%= product.getId() %>"
                               value="0"
                               min="0"
                               max="99"
                               class="form-group input">
                    </div>

                </div>
            </div>
            <% } // End product loop %>
        </div>

        <div class="cart-submit-bar">
            <button type="submit" class="btn">Add Selections to Cart</button>
        </div>

    </form>
</div>
</body>
</html>