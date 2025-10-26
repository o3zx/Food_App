<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import ALL classes needed for processing --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.CartItem" %>
<%@ page import="org.foodapp.foodapp.Order" %>
<%@ page import="org.foodapp.foodapp.OrderItem" %>
<%@ page import="org.foodapp.foodapp.OrderDAO" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>

<%
    // --- 1. Get User and Cart ---
    User user = (User) session.getAttribute("user");
    @SuppressWarnings("unchecked")
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

    // --- 2. Security/Flow Check ---
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if (cart == null || cart.isEmpty()) {
        response.sendRedirect("menu.jsp");
        return;
    }

    // --- 3. Process the Order ---

    // Create the OrderDAO
    OrderDAO orderDAO = new OrderDAO();

    // Create the main Order object
    Order order = new Order();
    order.setUserId(user.getId());
    order.setOrderDate(new Date()); // Set current date
    order.setStatus("Pending");
    order.setDeliveryAddress(user.getAddress());

    // Create the list of OrderItems
    List<OrderItem> orderItems = new ArrayList<>();
    double totalAmount = 0.0;

    for (CartItem cartItem : cart.values()) {
        OrderItem oi = new OrderItem();
        oi.setProductId(cartItem.getProduct().getId());
        oi.setProductName(cartItem.getProduct().getName());
        oi.setQuantity(cartItem.getQuantity());
        oi.setPriceAtTimeOfOrder(cartItem.getProduct().getPrice());

        orderItems.add(oi);
        totalAmount += cartItem.getTotalPrice();
    }

    order.setTotalAmount(totalAmount);

    // --- 4. Call the DAO ---
    int newOrderId = orderDAO.createOrder(order, orderItems);

    // --- 5. Post-Order Actions ---
    if (newOrderId != -1) {
        // Success!

        // 1. Clear the cart from the session
        session.removeAttribute("cart");

        // 2. Store the new Order ID in session to show on the confirmation page
        session.setAttribute("lastOrderId", newOrderId);

        // 3. Redirect to the confirmation page
        response.sendRedirect("orderConfirmation.jsp");
    } else {
        // Failure
        // Redirect back to checkout with an error message
        response.sendRedirect("checkout.jsp?error=Failed to place order.");
    }
%>