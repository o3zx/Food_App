<link rel="stylesheet" href="assets/css/style.css">
<!-- Page-Specific Styles -->
<link rel="stylesheet" href="assets/css/menu.css">


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import all necessary Java classes --%>
<%@ page import="org.foodapp.foodapp.ProductDAO" %>
<%@ page import="org.foodapp.foodapp.Product" %>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.foodapp.foodapp.CartItem" %>
<%@ page import="java.util.HashMap" %>

<%
    // 1. Get User (if they are logged in)
    User user = (User) session.getAttribute("user");
    @SuppressWarnings("unchecked")
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
    if (cart == null) {
        cart = new HashMap<>();
    }
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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu - FoodApp</title>

    <!-- Global Styles -->

</head>
<body>

<!-- Main Header -->
<header class="main-header">
    <div class="container">
        <a href="menu.jsp" class="main-header-logo">FoodApp</a>
        <nav class="main-header-nav">
            <a href="menu.jsp" class="active">Menu</a>
            <a href="cart.jsp">🛒 Cart</a>
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
<main class="menu-main">
    <div class="container">

        <!-- Welcome Header -->
        <div class="welcome-section">
            <% if (user != null) { %>
            <h1 class="welcome-title">Welcome back, <span class="user-name"><%= user.getUsername() %></span>!</h1>
            <% } else { %>
            <h1 class="welcome-title">Welcome to FoodApp!</h1>
            <% } %>
            <p class="welcome-subtitle">Discover delicious meals delivered to your doorstep</p>
        </div>

        <!-- Search Bar -->
        <div class="search-section">
            <form action="menu.jsp" method="get" class="search-form">
                <div class="search-input-wrapper">
                    <input
                            type="text"
                            name="search"
                            class="search-input"
                            placeholder="Search for your favorite food..."
                            value="<%= (searchTerm != null ? searchTerm : "") %>">
                    <button type="submit" class="btn btn-primary search-btn">
                        🔍 Search
                    </button>
                </div>
            </form>
        </div>

        <!-- Menu Form -->
        <form action="cart.jsp" method="post" id="menu-form" class="menu-form">
            <input type="hidden" name="action" value="batchUpdate">

            <%--
              NEW DISPLAY LOGIC:
              Show search results OR categories
            --%>
            <% if (isSearch) { %>
            <!-- Search Results Section -->
            <div class="search-results-header">
                <h2 class="section-title">Search Results for "<%= searchTerm %>"</h2>
                <a href="menu.jsp" class="btn btn-outline btn-sm">Clear Search</a>
            </div>

            <% if (products.isEmpty()) { %>
            <div class="empty-state card">
                <div class="empty-state-icon">🔍</div>
                <h3 class="empty-state-title">No Results Found</h3>
                <p class="empty-state-text">We couldn't find any products matching "<%= searchTerm %>". Try a different search term.</p>
                <a href="menu.jsp" class="btn btn-primary">Browse All Menu</a>
            </div>
            <% } else { %>
            <div class="products-grid">
                <% for (Product product : products) { %>
                <%
                    // --- ADD THIS LOGIC ---
                    int currentQuantity = 0;
                    if (cart.containsKey(product.getId())) {
                        currentQuantity = cart.get(product.getId()).getQuantity();
                    }
                %>
                <div class="product-card">
                    <div class="product-image-wrapper">
                        <% if (product.getImageUrl() != null && !product.getImageUrl().isEmpty()) { %>
                        <img src="${pageContext.request.contextPath}/uploads/<%= product.getImageUrl() %>"
                             alt="<%= product.getName() %>"
                             class="product-image">
                        <% } else { %>
                        <img src="${pageContext.request.contextPath}/assets/img/placeholder.png"
                             alt="No image"
                             class="product-image">
                        <% } %>
                    </div>
                    <div class="product-info">
                        <h3 class="product-name"><%= product.getName() %></h3>
                        <p class="product-description"><%= product.getDescription() %></p>
                        <div class="product-footer">
                            <span class="product-price">$<%= String.format("%.2f", product.getPrice()) %></span>
                            <div class="quantity-selector">
                                <label for="quantity-<%= product.getId() %>" class="quantity-label">Qty:</label>
                                <input
                                        type="number"
                                        id="quantity-<%= product.getId() %>"
                                        name="quantity_<%= product.getId() %>"
                                        value="<%= currentQuantity %>"
                                        min="0"
                                        max="99"
                                        class="quantity-input">
                            </div>
                        </div>
                    </div>
                </div>
                <% } // End product loop %>
            </div>
            <% } %>

            <% } else { %>
            <!-- Category Mode (Default) -->
            <%
                for (String category : productMap.keySet()) {
                    products = productMap.get(category);
            %>
            <div class="category-section">
                <h2 class="category-title"><%= category %></h2>
                <div class="products-grid">
                    <% for (Product product : products) { %>
                    <%
                        // --- ADD THIS LOGIC ---
                        int currentQuantity = 0;
                        if (cart.containsKey(product.getId())) {
                            currentQuantity = cart.get(product.getId()).getQuantity();
                        }
                    %>
                    <div class="product-card">
                        <div class="product-image-wrapper">
                            <% if (product.getImageUrl() != null && !product.getImageUrl().isEmpty()) { %>
                            <img src="${pageContext.request.contextPath}/uploads/<%= product.getImageUrl() %>"
                                 alt="<%= product.getName() %>"
                                 class="product-image">
                            <% } else { %>
                            <img src="${pageContext.request.contextPath}/assets/img/placeholder.png"
                                 alt="No image"
                                 class="product-image">
                            <% } %>
                        </div>
                        <div class="product-info">
                            <h3 class="product-name"><%= product.getName() %></h3>
                            <p class="product-description"><%= product.getDescription() %></p>
                            <div class="product-footer">
                                <span class="product-price">$<%= String.format("%.2f", product.getPrice()) %></span>
                                <div class="quantity-selector">
                                    <label for="quantity-<%= product.getId() %>" class="quantity-label">Qty:</label>
                                    <input
                                            type="number"
                                            id="quantity-<%= product.getId() %>"
                                            name="quantity_<%= product.getId() %>"
                                            value="<%= currentQuantity %>"
                                            min="0"
                                            max="99"
                                            class="quantity-input">
                                </div>
                            </div>
                        </div>
                    </div>
                    <% } // End product loop %>
                </div>
            </div>
            <% } // End category loop %>
            <% } // End if (isSearch) %>

            <!-- Floating Cart Submit Bar -->
            <div class="cart-submit-bar">
                <div class="container">
                    <button type="submit" class="btn btn-primary btn-lg">
                        🛒 Add Selections to Cart
                    </button>
                </div>
            </div>
        </form>

    </div>
</main>

</body>
</html>