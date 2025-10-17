<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import classes --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.OrderDAO" %>

<%
    // 1. Admin Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp?error=Access Denied");
        return;
    }

    // 2. Get Parameters
    String orderIdStr = request.getParameter("orderId");
    String newStatus = request.getParameter("newStatus");

    if (orderIdStr != null && newStatus != null) {
        try {
            int orderId = Integer.parseInt(orderIdStr);

            // 3. Call DAO
            OrderDAO orderDAO = new OrderDAO();
            orderDAO.updateOrderStatus(orderId, newStatus);

        } catch (NumberFormatException e) {
            // Handle error
            System.out.println("Invalid Order ID format: " + orderIdStr);
        }
    }

    // 4. Redirect back to the dashboard
    response.sendRedirect("adminDashboard.jsp");
%>