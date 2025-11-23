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

    // 2. Get Cart to pre-fill quantities
    @SuppressWarnings("unchecked")
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
    if (cart == null) {
        cart = new HashMap<>();
    }

    // 3. Data Retrieval
    ProductDAO productDAO = new ProductDAO();
    String searchTerm = request.getParameter("search");
    boolean isSearch = false;
    List<Product> products = null;
    Map<String, List<Product>> productMap = null;

    if (searchTerm != null && !searchTerm.trim().isEmpty()) {
        isSearch = true;
        products = productDAO.searchProducts(searchTerm);
        request.setAttribute("products", products);
        request.setAttribute("searchTerm", searchTerm);
    } else {
        productMap = productDAO.getProductsGroupedByCategory();
        request.setAttribute("productMap", productMap);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu - FoodApp</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/menu.css">
</head>
<body>

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

<main class="menu-main">
    <div class="container">

        <div class="welcome-section">
            <% if (user != null) { %>
            <h1 class="welcome-title">Welcome back, <span class="user-name"><%= user.getUsername() %></span>!</h1>
            <% } else { %>
            <h1 class="welcome-title">Welcome to FoodApp!</h1>
            <% } %>
            <p class="welcome-subtitle">Discover delicious meals delivered to your doorstep</p>
        </div>

        <div class="search-section">
            <form action="menu.jsp" method="get" class="search-form">
                <div class="search-input-wrapper">
                    <input type="text" name="search" class="search-input" placeholder="Search for your favorite food..." value="<%= (searchTerm != null ? searchTerm : "") %>">
                    <button type="submit" class="btn btn-primary search-btn">🔍 Search</button>
                </div>
            </form>
        </div>

        <form action="cart.jsp" method="post" id="menu-form" class="menu-form">
            <input type="hidden" name="action" value="batchUpdate">

            <%-- DISPLAY LOGIC --%>
            <% if (isSearch) { %>

            <div class="search-results-header">
                <h2 class="section-title">Search Results for "<%= searchTerm %>"</h2>
                <a href="menu.jsp" class="btn btn-outline btn-sm">Clear Search</a>
            </div>

            <% if (products.isEmpty()) { %>
            <div class="empty-state card">
                <div class="empty-state-icon">🔍</div>
                <h3 class="empty-state-title">No Results Found</h3>
                <p class="empty-state-text">We couldn't find any products matching "<%= searchTerm %>".</p>
                <a href="menu.jsp" class="btn btn-primary">Browse All Menu</a>
            </div>
            <% } else { %>
            <div class="products-grid">
                <% for (Product product : products) {
                    int currentQuantity = cart.containsKey(product.getId()) ? cart.get(product.getId()).getQuantity() : 0;
                %>
                <div class="product-card">
                    <div class="product-image-wrapper">
                        <%-- SMART IMAGE LOGIC --%>
                        <%
                            String img = product.getImageUrl();
                            if (img != null && !img.isEmpty()) {
                                if (img.startsWith("http")) {
                        %>
                        <img src="<%= img %>" alt="<%= product.getName() %>" class="product-image" onerror="this.src='${pageContext.request.contextPath}/assets/img/placeholder.png';">
                        <%      } else { %>
                        <img src="${pageContext.request.contextPath}/uploads/<%= img %>" alt="<%= product.getName() %>" class="product-image" onerror="this.src='${pageContext.request.contextPath}/assets/img/placeholder.png';">
                        <%      }
                        } else {
                        %>
                        <img src="${pageContext.request.contextPath}/assets/img/placeholder.png" alt="No image" class="product-image">
                        <%  } %>
                    </div>
                    <div class="product-info">
                        <h3 class="product-name"><%= product.getName() %></h3>
                        <p class="product-description"><%= product.getDescription() %></p>
                        <div class="product-footer">
                            <span class="product-price">$<%= String.format("%.2f", product.getPrice()) %></span>
                            <div class="quantity-selector">
                                <button type="button" class="quantity-btn quantity-btn-minus" onclick="decrementQuantity(<%= product.getId() %>)">−</button>
                                <input type="number" id="quantity-<%= product.getId() %>" name="quantity_<%= product.getId() %>" value="<%= currentQuantity %>" min="0" max="99" class="quantity-input" readonly>
                                <button type="button" class="quantity-btn quantity-btn-plus" onclick="incrementQuantity(<%= product.getId() %>)">+</button>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>

            <% } else { %>

            <%
                for (String category : productMap.keySet()) {
                    products = productMap.get(category);
            %>
            <div class="category-section">
                <h2 class="category-title"><%= category %></h2>
                <div class="products-grid">
                    <% for (Product product : products) {
                        int currentQuantity = cart.containsKey(product.getId()) ? cart.get(product.getId()).getQuantity() : 0;
                    %>
                    <div class="product-card">
                        <div class="product-image-wrapper">
                            <%-- SMART IMAGE LOGIC --%>
                            <%
                                String img = product.getImageUrl();
                                if (img != null && !img.isEmpty()) {
                                    if (img.startsWith("http")) {
                            %>
                            <img src="<%= img %>" alt="<%= product.getName() %>" class="product-image" onerror="this.src='${pageContext.request.contextPath}/assets/img/placeholder.png';">
                            <%      } else { %>
                            <img src="${pageContext.request.contextPath}/uploads/<%= img %>" alt="<%= product.getName() %>" class="product-image" onerror="this.src='${pageContext.request.contextPath}/assets/img/placeholder.png';">
                            <%      }
                            } else {
                            %>
                            <img src="${pageContext.request.contextPath}/assets/img/placeholder.png" alt="No image" class="product-image">
                            <%  } %>
                        </div>
                        <div class="product-info">
                            <h3 class="product-name"><%= product.getName() %></h3>
                            <p class="product-description"><%= product.getDescription() %></p>
                            <div class="product-footer">
                                <span class="product-price">$<%= String.format("%.2f", product.getPrice()) %></span>
                                <div class="quantity-selector">
                                    <button type="button" class="quantity-btn quantity-btn-minus" onclick="decrementQuantity(<%= product.getId() %>)">−</button>
                                    <input type="number" id="quantity-<%= product.getId() %>" name="quantity_<%= product.getId() %>" value="<%= currentQuantity %>" min="0" max="99" class="quantity-input" readonly>
                                    <button type="button" class="quantity-btn quantity-btn-plus" onclick="incrementQuantity(<%= product.getId() %>)">+</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } %>
            <% } %>

            <div class="cart-submit-bar">
                <div class="container">
                    <button type="submit" class="btn btn-primary btn-lg">🛒 Add Selections to Cart</button>
                </div>
            </div>
        </form>

    </div>
</main>

<script>
    function incrementQuantity(productId) {
        const input = document.getElementById('quantity-' + productId);
        let value = parseInt(input.value) || 0;
        if (value < 99) {
            input.value = value + 1;
            updateInputStyle(input);
        }
    }

    function decrementQuantity(productId) {
        const input = document.getElementById('quantity-' + productId);
        let value = parseInt(input.value) || 0;
        if (value > 0) {
            input.value = value - 1;
            updateInputStyle(input);
        }
    }

    function updateInputStyle(input) {
        if (parseInt(input.value) > 0) {
            input.classList.add('has-value');
        } else {
            input.classList.remove('has-value');
        }
    }

    // Initialize styles on page load
    document.addEventListener('DOMContentLoaded', function() {
        const inputs = document.querySelectorAll('.quantity-input');
        inputs.forEach(input => updateInputStyle(input));
    });
</script>

</body>
</html>