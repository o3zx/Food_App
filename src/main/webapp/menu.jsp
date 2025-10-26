<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import all necessary Java classes --%>
<%@ page import="org.foodapp.foodapp.ProductDAO" %>
<%@ page import="org.foodapp.foodapp.Product" %>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>

<%
    // 1. Get User (if they are logged in)
    User user = (User) session.getAttribute("user");

    // 2. Data Retrieval (NEW LOGIC)
    ProductDAO productDAO = new ProductDAO();

    // Check if a search term was submitted
    String searchTerm = request.getParameter("search");
    boolean isSearch = false;
    List<Product> products = null;
    Map<String, List<Product>> productMap = null;

    if (searchTerm != null && !searchTerm.trim().isEmpty()) {
        // --- SEARCH MODE ---
        isSearch = true;
        products = productDAO.searchProducts(searchTerm);
        request.setAttribute("products", products); // Store list of products
        request.setAttribute("searchTerm", searchTerm); // Store the search term
    } else {
        // --- CATEGORY MODE (Default) ---
        productMap = productDAO.getProductsGroupedByCategory();
        request.setAttribute("productMap", productMap); // Store map of products
    }
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
        <% if (user != null) { %>
        <a href="profile.jsp">My Profile</a>
        <a href="orderHistory.jsp">My Orders</a>
        <a href="logout.jsp">Logout</a>
        <% } else { %>
        <a href="login.jsp" class="btn">Login / Register</a>
        <% } %>
    </nav>
</header>

<div class="container">
    <div class="welcome-header">
        <% if (user != null) { %>
        <h1>Welcome, <%= user.getUsername() %>!</h1>
        <% } else { %>
        <h1>Welcome, Guest!</h1>
        <% } %>
        <h2>Today's Menu</h2>
    </div>

    <form action="menu.jsp" method="get" class="search-bar">
        <input type="text" name="search" placeholder="Search for food..." value="<%= (searchTerm != null ? searchTerm : "") %>">
        <button type="submit" class="btn">Search</button>
    </form>


    <form action="cart.jsp" method="post" id="menu-form">
        <input type="hidden" name="action" value="batchUpdate">

        <%--
          NEW DISPLAY LOGIC:
          Show search results OR categories
        --%>
        <% if (isSearch) { %>
        <h2 class="category-header">Search Results for "<%= searchTerm %>"</h2>

        <div class="product-list">
            <% if (products.isEmpty()) { %>
            <p>No products found matching your search.</p>
            <% } %>
            <% for (Product product : products) { %>
            <div class="product-card">
                <% if (product.getImageUrl() != null && !product.getImageUrl().isEmpty()) { %>
                <img src="${pageContext.request.contextPath}/uploads/<%= product.getImageUrl() %>" alt="<%= product.getName() %>" class="product-image">
                <% } else { %>
                <img src="${pageContext.request.contextPath}/assets/img/placeholder.png" alt="No image" class="product-image">
                <% } %>
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
                               value="0" min="0" max="99" class="form-group input">
                    </div>
                </div>
            </div>
            <% } // End product loop %>
        </div>

        <% } else { %>
        <%
            for (String category : productMap.keySet()) {
                products = productMap.get(category);
        %>
        <h2 class="category-header"><%= category %></h2>
        <div class="product-list">
            <% for (Product product : products) { %>
            <div class="product-card">
                <% if (product.getImageUrl() != null && !product.getImageUrl().isEmpty()) { %>
                <img src="${pageContext.request.contextPath}/uploads/<%= product.getImageUrl() %>" alt="<%= product.getName() %>" class="product-image">
                <% } else { %>
                <img src="${pageContext.request.contextPath}/assets/img/placeholder.png" alt="No image" class="product-image">
                <% } %>
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
                               value="0" min="0" max="99" class="form-group input">
                    </div>
                </div>
            </div>
            <% } // End product loop %>
        </div>
        <% } // End category loop %>
        <% } // End if (isSearch) %>

        <div class="cart-submit-bar">
            <button type="submit" class="btn">Add Selections to Cart</button>
        </div>
    </form>
</div>
</body>
</html>