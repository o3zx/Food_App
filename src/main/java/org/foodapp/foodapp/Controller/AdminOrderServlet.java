package org.foodapp.foodapp.Controller;

import org.foodapp.foodapp.User;
import org.foodapp.foodapp.OrderDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/adminOrderAction") // One URL for all admin order tasks
public class AdminOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 1. Admin Security Check
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("login.jsp?error=Access Denied");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        String action = request.getParameter("action"); // We'll add this hidden field to the forms
        String redirectURL = "adminDashboard.jsp";

        try {
            // --- CASE 1: ASSIGN DRIVER ---
            if ("assign".equals(action)) {
                String orderIdStr = request.getParameter("orderId");
                String driverIdStr = request.getParameter("driverId");

                if (orderIdStr != null && driverIdStr != null) {
                    int orderId = Integer.parseInt(orderIdStr);
                    int driverId = Integer.parseInt(driverIdStr);

                    boolean success = orderDAO.assignDriverToOrder(orderId, driverId);
                    if (success) {
                        redirectURL += "?success=Driver assigned successfully!";
                    } else {
                        redirectURL += "?error=Failed to assign driver.";
                    }
                }
            }

            // --- CASE 2: DELETE ORDER ---
            else if ("delete".equals(action)) {
                String orderIdStr = request.getParameter("orderId");

                if (orderIdStr != null) {
                    int orderId = Integer.parseInt(orderIdStr);
                    boolean success = orderDAO.deleteOrder(orderId);

                    if (success) {
                        redirectURL += "?success=Order deleted successfully!";
                    } else {
                        redirectURL += "?error=Failed to delete order.";
                    }
                }
            }

        } catch (NumberFormatException e) {
            redirectURL += "?error=Invalid ID format.";
            e.printStackTrace();
        }

        response.sendRedirect(redirectURL);
    }
}