<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import all necessary classes --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.Product" %>
<%@ page import="org.foodapp.foodapp.ProductDAO" %>
<%@ page import="java.util.List" %> <%
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

    // 3. Fetch the product's current details
    ProductDAO productDAO = new ProductDAO();
    Product product = productDAO.getProductById(productId);

    if (product == null) {
        response.sendRedirect("adminManageProducts.jsp?error=Product not found.");
        return;
    }

    // 4. Fetch categories for the dropdown
    List<String> categories = productDAO.getAllCategories();
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
            <a href="adminDashboard.jsp">Orders</a>
            <a href="logout">Logout</a>
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
                        <input type="text" id="name" name="name" class="form-input" value="<%= product.getName() %>" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="description" class="form-label">Description</label>
                        <textarea id="description" name="description" class="form-textarea" rows="4"><%= product.getDescription() %></textarea>
                    </div>
                </div>

                <div class="form-row form-row-split">
                    <div class="form-group">
                        <label for="price" class="form-label">Price ($) *</label>
                        <input type="number" id="price" name="price" class="form-input" value="<%= product.getPrice() %>" step="0.01" min="0" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Category *</label>

                        <select id="catSelect" class="form-input" onchange="handleCategoryChange(this)">
                            <option value="">-- Select Existing Category --</option>
                            <% for (String cat : categories) {
                                boolean isSelected = cat.equals(product.getCategory());
                            %>
                            <option value="<%= cat %>" <%= isSelected ? "selected" : "" %>><%= cat %></option>
                            <% } %>
                            <option value="NEW_OPTION" style="font-weight: bold; color: var(--primary);">+ Create New Category</option>
                        </select>

                        <div id="catInputWrapper" style="display: none; margin-top: 10px;">
                            <input type="text" id="catTextInput" class="form-input" placeholder="Type new category name...">
                            <button type="button" class="btn btn-sm btn-outline" onclick="cancelNewCategory()" style="margin-top: 5px;">Cancel / Select Existing</button>
                        </div>

                        <input type="hidden" id="finalCategory" name="category" value="<%= product.getCategory() %>" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Option A: Upload File (Local)</label>
                        <div class="file-input-wrapper">
                            <input type="file" id="imageFile" name="imageFile" class="file-input" accept="image/*">
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
                        <input type="text" id="imageUrl" name="imageUrl" class="form-input" placeholder="https://example.com/image.jpg">
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

        // Reset to the original category value if possible, or first option
        // For simplicity, we just reset to index 0
        selectObject.selectedIndex = 0;

        textWrapper.style.display = "none";
        document.getElementById("catTextInput").required = false;

        // Reset hidden field (user will need to re-select)
        finalInput.value = "";
    }

    document.getElementById("catTextInput").addEventListener("input", function() {
        document.getElementById("finalCategory").value = this.value;
    });
</script>

</body>
</html>