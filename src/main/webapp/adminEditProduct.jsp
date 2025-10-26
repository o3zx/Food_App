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
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/login.css">
</head>
<body>

<div class="container">
    <div class="login-container">
        <div class="login-card"> <h1>Edit Product (ID: <%= product.getId() %>)</h1>

            <form action="adminProductAction.jsp" method="post" enctype="multipart/form-data">

                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= product.getId() %>">

                <div class="form-group">
                    <label for="name">Product Name:</label>
                    <input type="text" id="name" name="name" value="<%= product.getName() %>" required>
                </div>

                <div class="form-group">
                    <label for="description">Description:</label>
                    <input type="text" id="description" name="description" value="<%= product.getDescription() %>">
                </div>

                <div class=("form-group")>
                <label for="price">Price:</label>
                <input type="number" id="price" name="price" value="<%= product.getPrice() %>" step="0.01" min="0" required>
        </div>

                <div class="form-group">
                    <label for="imageFile">Upload New Image (Optional):</label>
                    <input type="file" id="imageFile" name="imageFile" class="form-group input">
                    <p style="font-size: 14px; margin-top: 8px;">
                        Current file: <%= product.getImageUrl() %>
                    </p>
                </div>
                <div class="form-group">
                    <label for="category">Category:</label>
                    <input type="text" id="category" name="category" value="<%= product.getCategory() %>" required>
                </div>

        <button type="submit" class="btn">Update Product</button>
        </form>

        <p style="text-align: center; margin-top: 20px;">
            <a href="adminManageProducts.jsp">Cancel</a>
        </p>
    </div>
</div>
</div>

</body>
</html>