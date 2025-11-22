<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import all necessary classes --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.Product" %>
<%@ page import="org.foodapp.foodapp.ProductDAO" %>

<%
    // 1. Admin Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp?error=Access Denied");
        return;
    }

    // 2. Get the product ID from the URL
    int productId = 0;
    try {
        productId = Integer.parseInt(request.getParameter("id"));
    } catch (NumberFormatException e) {
        response.sendRedirect("adminManageProducts.jsp?error=Invalid product ID.");
        return;
    }

    // 3. Fetch the product's current details from the DB
    ProductDAO productDAO = new ProductDAO();
    Product product = productDAO.getProductById(productId);

    // 4. Check if product was found
    if (product == null) {
        response.sendRedirect("adminManageProducts.jsp?error=Product not found.");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product - Admin Dashboard</title>

    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/editProduct.css">
</head>
<body>

<header class="main-header">
    <div class="container">
        <a href="adminDashboard.jsp" class="main-header-logo">FoodApp Admin</a>
        <nav class="main-header-nav">
            <a href="adminDashboard.jsp">Dashboard</a>
            <a href="adminManageProducts.jsp" class="active">Products</a>
            <a href="adminDashboard.jsp">Orders</a> <a href="logout">Logout</a>
        </nav>
    </div>
</header>

<main class="admin-main">
    <div class="container">

        <div class="page-header">
            <h1 class="page-title">Edit Product</h1>
            <p class="page-subtitle">Update details for Product ID: <span class="product-id-badge">#<%= product.getId() %></span></p>
        </div>

        <div class="form-card card">
            <form action="adminProductAction" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= product.getId() %>">

                <div class="form-row">
                    <div class="form-group">
                        <label for="name" class="form-label">Product Name *</label>
                        <input
                                type="text"
                                id="name"
                                name="name"
                                class="form-input"
                                value="<%= product.getName() %>"
                                placeholder="e.g., Cheeseburger Deluxe"
                                required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="description" class="form-label">Description</label>
                        <textarea
                                id="description"
                                name="description"
                                class="form-textarea"
                                rows="4"
                                placeholder="Describe this delicious product..."><%= product.getDescription() %></textarea>
                    </div>
                </div>

                <div class="form-row form-row-split">
                    <div class="form-group">
                        <label for="price" class="form-label">Price ($) *</label>
                        <input
                                type="number"
                                id="price"
                                name="price"
                                class="form-input"
                                value="<%= product.getPrice() %>"
                                step="0.01"
                                min="0"
                                placeholder="9.99"
                                required>
                    </div>

                    <div class="form-group">
                        <label for="category" class="form-label">Category *</label>
                        <input
                                type="text"
                                id="category"
                                name="category"
                                class="form-input"
                                value="<%= product.getCategory() %>"
                                placeholder="e.g., Burgers, Pizza, Salads"
                                required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Option A: Upload File (Local)</label>
                        <div class="file-input-wrapper">
                            <input
                                    type="file"
                                    id="imageFile"
                                    name="imageFile"
                                    class="file-input"
                                    accept="image/*">
                            <label for="imageFile" class="file-input-label">Choose a new image file</label>
                        </div>
                        <div class="current-image-info">
                            <span class="current-image-label">Current image:</span>
                            <span class="current-image-filename"><%= product.getImageUrl() %></span>
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="imageUrl" class="form-label">Option B: Paste Image URL (Cloud)</label>
                        <input
                                type="text"
                                id="imageUrl"
                                name="imageUrl"
                                class="form-input"
                                placeholder="https://example.com/image.jpg">
                        <span class="form-help">If using Cloud Hosting, paste a URL here.</span>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="adminManageProducts.jsp" class="btn btn-outline">Cancel</a>
                    <button type="submit" class="btn btn-primary">Update Product</button>
                </div>

            </form>
        </div>

    </div>
</main>

</body>
</html>