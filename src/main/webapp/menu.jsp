<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import the necessary Java classes --%>
<%@ page import="org.foodapp.foodapp.ProductDAO" %>
<%@ page import="org.foodapp.foodapp.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="org.foodapp.foodapp.User" %>

<!DOCTYPE html>
<html>
<head>
    <title>Food Menu</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/menu.css">

</head>
<body>

<%
    // 1. Authentication Check (Replaces <c:if> and <c:redirect>)
    // Check if the user object exists in the session
    User user = (User) session.getAttribute("user");
    if (user == null) {
        // If not logged in, redirect to the login page immediately
        response.sendRedirect("login.jsp");
        return; // Stop processing the rest of the page
    }

    // 2. Data Retrieval (Controller logic)
    ProductDAO productDAO = new ProductDAO();
    List<Product> products = productDAO.getAllProducts();

    // 3. Store data in Request Scope for cleaner output using EL (optional, but good practice)
    request.setAttribute("products", products);
%>

<h1>Welcome, <%= user.getUsername() %>!</h1>
<h2>Today's Menu (Mocked Products)</h2>

<div class="product-list">
    <%
        // 4. Product Iteration (Replaces <c:forEach>)
        // We use the List stored in the 'products' variable
        for (Product product : products) {
    %>
    <div class="product-card">
        <%-- Using Scriptlet Expressions for output, or EL if stored in request scope --%>
        <h3><%= product.getName() %></h3>
        <p><%= product.getDescription() %></p>
        <p><strong>Price: \$<%= String.format("%.2f", product.getPrice()) %></strong></p>

        <%-- Form to send product ID to a new Cart JSP --%>
        <form action="cart.jsp" method="post" style="display:inline;">
            <input type="hidden" name="productId" value="<%= product.getId() %>">
            <input type="hidden" name="action" value="add">
            <input type="number" name="quantity" value="1" min="1" style="width: 50px;">
            <button type="submit">Add to Cart</button>
        </form>
    </div>
    <hr>
    <%
        } // End of the for loop
    %>
</div>
<p><a href="orderHistory.jsp">My Order History</a> | <a href="logout.jsp">Logout</a></p>

<p><a href="login.jsp">Logout</a></p>
</body>
</html>