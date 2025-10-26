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
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Product</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/login.css">
</head>
<body>

<div class="container">
    <div class="login-container">
        <div class="login-card"> <h1>Add New Product</h1>

            <form action="adminProductAction.jsp" method="post" enctype="multipart/form-data">

                <input type="hidden" name="action" value="add">

                <div class="form-group">
                    <label for="name">Product Name:</label>
                    <input type="text" id="name" name="name" required>
                </div>

                <div class="form-group">
                    <label for="description">Description:</label>
                    <input type="text" id="description" name="description">
                </div>

                <div class="form-group">
                    <label for="price">Price (e.g., 9.99):</label>
                    <input type="number" id="price" name="price" step="0.01" min="0" required>
                </div>

                <div class="form-group">
                    <label for="imageFile">Product Image:</label>
                    <input type="file" id="imageFile" name="imageFile" class="form-group input">
                </div>

                <div class="form-group">
                    <label for="category">Category (e.g., Burgers, Pizza):</label>
                    <input type="text" id="category" name="category" required>
                </div>

                <button type="submit" class="btn">Add Product</button>
            </form>

            <p style="text-align: center; margin-top: 20px;">
                <a href="adminManageProducts.jsp">Cancel</a>
            </p>
        </div>
    </div>
</div>

</body>
</html>