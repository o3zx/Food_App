<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import User class for authentication --%>
<%@ page import="org.foodapp.foodapp.User" %>

<%
    // 1. Admin Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp?error=Access Denied");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Product - Admin Dashboard</title>

    <!-- Global Styles -->
    <link rel="stylesheet" href="assets/css/style.css">
    <!-- Page-Specific Styles -->
    <link rel="stylesheet" href="assets/css/addProduct.css">
</head>
<body>

<!-- Main Header -->
<header class="main-header">
    <div class="container">
        <a href="adminDashboard.jsp" class="main-header-logo">FoodApp Admin</a>
        <nav class="main-header-nav">
            <a href="adminDashboard.jsp">Dashboard</a>
            <a href="adminManageProducts.jsp">Products</a>
            <a href="adminManageOrders.jsp">Orders</a>
            <a href="logout">Logout</a>
        </nav>
    </div>
</header>

<!-- Main Content -->
<main class="admin-main">
    <div class="container">

        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">Add New Product</h1>
            <p class="page-subtitle">Add a delicious new item to your menu</p>
        </div>

        <!-- Add Product Form Card -->
        <div class="form-card card">
            <form action="adminProductAction" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">

                <div class="form-row">
                    <div class="form-group">
                        <label for="name" class="form-label">Product Name *</label>
                        <input
                                type="text"
                                id="name"
                                name="name"
                                class="form-input"
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
                                placeholder="Describe this delicious product..."></textarea>
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
                                placeholder="e.g., Burgers, Pizza, Salads"
                                required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="imageFile" class="form-label">Product Image
                            <br>
                            <span class="file-input-label">Choose an image file</span></label>
                        <div class="file-input-wrapper">
                            <input
                                    type="file"
                                    id="imageFile"
                                    name="imageFile"
                                    class="form-input file-input"
                                    accept="/uploads/*">

                        </div>
                        <span class="form-help">Recommended: JPG or PNG, max 5MB</span>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <a href="adminManageProducts.jsp" class="btn btn-outline">Cancel</a>
                    <button type="submit" class="btn btn-primary">Add Product</button>
                </div>

            </form>
        </div>

    </div>
</main>

</body>
</html>