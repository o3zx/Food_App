<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import all necessary classes --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.Product" %>
<%@ page import="org.foodapp.foodapp.ProductDAO" %>
<%@ page import="java.util.List" %>

<%
    // 1. Admin Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp?error=Access Denied");
        return;
    }

    // 2. Get all products from the database
    ProductDAO productDAO = new ProductDAO();
    List<Product> products = productDAO.getAllProducts();

    // 3. Check for any success/error messages (after an action)
    String successMessage = request.getParameter("success");
    String errorMessage = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products - Admin Dashboard</title>

    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/adminManageProducts.css">
</head>
<body>

<header class="main-header">
    <div class="container">
        <a href="adminDashboard.jsp" class="main-header-logo">FoodApp Admin</a>
        <nav class="main-header-nav">
            <a href="adminDashboard.jsp">Dashboard</a>
            <a href="adminManageProducts.jsp" class="active">Products</a>
            <a href="logout">Logout</a>
        </nav>
    </div>
</header>

<main class="admin-main">
    <div class="container">

        <div class="dashboard-header">
            <div class="dashboard-header-content">
                <h1 class="page-title">Product Management</h1>
                <p class="page-subtitle">Manage your menu items and inventory</p>
            </div>
            <div class="dashboard-header-actions">
                <a href="adminAddProduct.jsp" class="btn btn-primary">
                    <span class="btn-icon">+</span>
                    Add New Product
                </a>
                <a href="adminDashboard.jsp" class="btn btn-outline">
                    <span class="btn-icon">←</span>
                    Back to Orders
                </a>
            </div>
        </div>

        <% if (successMessage != null) { %>
        <div class="alert alert-success">
            <%= successMessage %>
        </div>
        <% } %>
        <% if (errorMessage != null) { %>
        <div class="alert alert-error">
            <%= errorMessage %>
        </div>
        <% } %>

        <div class="products-section">
            <div class="section-header">
                <h2 class="section-title">All Products (<%= products.size() %>)</h2>
            </div>

            <% if (products.isEmpty()) { %>
            <div class="empty-state card">
                <div class="empty-state-icon">🍽️</div>
                <h3 class="empty-state-title">No Products Yet</h3>
                <p class="empty-state-text">Start building your menu by adding your first product.</p>
                <a href="adminAddProduct.jsp" class="btn btn-primary">Add First Product</a>
            </div>
            <% } else { %>
            <div class="table-wrapper">
                <table class="styled-table products-table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Product Name</th>
                        <th>Price</th>
                        <th>Description</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Product p : products) { %>
                    <tr class="product-row">
                        <td>
                            <span class="product-id">#<%= p.getId() %></span>
                        </td>
                        <td>
                            <span class="product-name"><%= p.getName() %></span>
                        </td>
                        <td>
                            <span class="product-price">$<%= String.format("%.2f", p.getPrice()) %></span>
                        </td>
                        <td>
                            <span class="product-description"><%= p.getDescription() %></span>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <a href="adminEditProduct.jsp?id=<%= p.getId() %>" class="btn btn-sm btn-secondary">
                                    Edit
                                </a>

                                <form action="adminProductAction" method="post" class="delete-form">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="productId" value="<%= p.getId() %>">
                                    <button type="submit"
                                            class="btn btn-sm btn-danger"
                                            onclick="return confirm('Are you sure you want to delete this product?');">
                                        Delete
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <% } // end for loop %>
                    </tbody>
                </table>
            </div>
            <% } // end else %>
        </div>

    </div>
</main>

</body>
</html>