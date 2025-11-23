<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import necessary classes --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.ProductDAO" %>
<%@ page import="java.util.List" %>

<%
    // 1. Admin Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp?error=Access Denied");
        return;
    }

    // 2. Fetch categories for the dropdown
    ProductDAO productDAO = new ProductDAO();
    List<String> categories = productDAO.getAllCategories();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Product - Admin Dashboard</title>

    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/addProduct.css">
</head>
<body>

<header class="main-header">
    <div class="container">
        <a href="adminDashboard.jsp" class="main-header-logo">FoodApp Admin</a>
        <nav class="main-header-nav">
            <a href="adminDashboard.jsp">Dashboard</a>
            <a href="adminManageProducts.jsp">Products</a>
            <a href="adminDashboard.jsp">Orders</a>
            <a href="logout">Logout</a>
        </nav>
    </div>
</header>

<main class="admin-main">
    <div class="container">

        <div class="page-header">
            <h1 class="page-title">Add New Product</h1>
            <p class="page-subtitle">Add a delicious new item to your menu</p>
        </div>

        <div class="form-card card">
            <form action="adminProductAction" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">

                <div class="form-row">
                    <div class="form-group">
                        <label for="name" class="form-label">Product Name *</label>
                        <input type="text" id="name" name="name" class="form-input" placeholder="e.g., Cheeseburger Deluxe" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="description" class="form-label">Description</label>
                        <textarea id="description" name="description" class="form-textarea" rows="4" placeholder="Describe this delicious product..."></textarea>
                    </div>
                </div>

                <div class="form-row form-row-split">
                    <div class="form-group">
                        <label for="price" class="form-label">Price ($) *</label>
                        <input type="number" id="price" name="price" class="form-input" step="0.01" min="0" placeholder="9.99" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Category *</label>

                        <select id="catSelect" class="form-input" onchange="handleCategoryChange(this)">
                            <option value="">-- Select Existing Category --</option>
                            <% for (String cat : categories) { %>
                            <option value="<%= cat %>"><%= cat %></option>
                            <% } %>
                            <option value="NEW_OPTION" style="font-weight: bold; color: var(--primary);">+ Create New Category</option>
                        </select>

                        <div id="catInputWrapper" style="display: none; margin-top: 10px;">
                            <input type="text" id="catTextInput" class="form-input" placeholder="Type new category name...">
                            <button type="button" class="btn btn-sm btn-outline" onclick="cancelNewCategory()" style="margin-top: 5px;">Cancel / Select Existing</button>
                        </div>

                        <input type="hidden" id="finalCategory" name="category" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Option A: Upload Image (Local)</label>
                        <label for="imageFile" class="file-input-label">Choose an image file</label>
                        <input type="file" id="imageFile" name="imageFile" class="file-input" accept="image/*" style="position: absolute; opacity: 0; width: 0.1px; height: 0.1px;">
                        <span class="form-help">Recommended: JPG or PNG, max 5MB</span>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="imageUrl" class="form-label">Option B: Paste Image URL (Cloud)</label>
                        <input type="text" id="imageUrl" name="imageUrl" class="form-input" placeholder="https://example.com/image.jpg">
                        <span class="form-help">Use this for the hosted demo (Render).</span>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="adminManageProducts.jsp" class="btn btn-outline">Cancel</a>
                    <button type="submit" class="btn btn-primary">Add Product</button>
                </div>

            </form>
        </div>

    </div>
</main>

<script>
    function handleCategoryChange(selectObject) {
        var value = selectObject.value;
        var textWrapper = document.getElementById("catInputWrapper");
        var finalInput = document.getElementById("finalCategory");

        if (value === "NEW_OPTION") {
            selectObject.style.display = "none";
            textWrapper.style.display = "block";
            document.getElementById("catTextInput").required = true;
            document.getElementById("catTextInput").focus();
            finalInput.value = "";
        } else {
            finalInput.value = value;
        }
    }

    function cancelNewCategory() {
        var selectObject = document.getElementById("catSelect");
        var textWrapper = document.getElementById("catInputWrapper");
        var finalInput = document.getElementById("finalCategory");

        selectObject.style.display = "block";
        selectObject.value = "";
        textWrapper.style.display = "none";
        document.getElementById("catTextInput").required = false;
        finalInput.value = "";
    }

    document.getElementById("catTextInput").addEventListener("input", function() {
        document.getElementById("finalCategory").value = this.value;
    });
</script>

</body>
</html>