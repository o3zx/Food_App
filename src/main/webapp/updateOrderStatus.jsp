<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import classes --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.OrderDAO" %>

<%
    // 1. Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp?error=Access Denied");
        return;
    }

    // 2. Get Parameters
    String orderIdStr = request.getParameter("orderId");
    String newStatus = request.getParameter("newStatus");

    // 3. Get redirect path, default to admin dashboard
    String redirectPage = request.getParameter("redirect");
    if (redirectPage == null || redirectPage.isEmpty()) {
        redirectPage = "adminDashboard.jsp";
    }

    if (orderIdStr != null && newStatus != null) {
        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderDAO orderDAO = new OrderDAO();
            boolean success = false;

            // 4. NEW: Role-based permissions
            if ("ADMIN".equals(user.getRole())) {
                // Admin can set Preparing or Cancelled (from our old logic)
                if (newStatus.equals("Preparing") || newStatus.equals("Cancelled")) {
                    success = orderDAO.updateOrderStatus(orderId, newStatus);
                }
            } else if ("DRIVER".equals(user.getRole())) {
                // Driver can ONLY set "Delivered"
                if (newStatus.equals("Delivered")) {
                    success = orderDAO.updateOrderStatus(orderId, newStatus);
                }
            }

            // (You could add success/error messages to the redirect here if you want)

        } catch (NumberFormatException e) {
            System.out.println("Invalid Order ID format: " + orderIdStr);
        }
    }

    // 5. Redirect back to the correct page
    response.sendRedirect(redirectPage);
%>