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
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>

<div class="container">
    <div class="dashboard-header">
        <h1>Manage Products</h1>
        <div>
            <a href="adminAddProduct.jsp" class="btn">Add New Product</a>
            <a href="adminDashboard.jsp" class="btn">Back to Orders</a>
        </div>
    </div>

    <% if (successMessage != null) { %>
    <p class="success-message"><%= successMessage %></p>
    <% } %>
    <% if (errorMessage != null) { %>
    <p class="error-message"><%= errorMessage %></p>
    <% } %>

    <table class="styled-table">
        <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Price</th>
            <th>Description</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <% if (products.isEmpty()) { %>
        <tr>
            <td colspan="5">No products found.</td>
        </tr>
        <% } else { %>
        <% for (Product p : products) { %>
        <tr>
            <td><%= p.getId() %></td>
            <td><%= p.getName() %></td>
            <td>$<%= String.format("%.2f", p.getPrice()) %></td>
            <td><%= p.getDescription() %></td>
            <td>
                <a href="adminEditProduct.jsp?id=<%= p.getId() %>" class="btn">Edit</a>

                <form action="adminProductAction.jsp" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="productId" value="<%= p.getId() %>">
                    <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this product?');">Delete</button>
                </form>
            </td>
        </tr>
        <% } // end for loop %>
        <% } // end else %>
        </tbody>
    </table>
</div>

</body>
</html>