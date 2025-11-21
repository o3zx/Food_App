package org.foodapp.foodapp.Controller;

import org.foodapp.foodapp.CartItem;
import org.foodapp.foodapp.Order;
import org.foodapp.foodapp.OrderDAO;
import org.foodapp.foodapp.OrderItem;
import org.foodapp.foodapp.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@WebServlet("/placeOrder") // Maps to the URL "/placeOrder"
public class OrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // 1. Get User and Cart from Session
        User user = (User) session.getAttribute("user");
        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

        // 2. Security & Validation Check
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("menu.jsp");
            return;
        }

        // 3. Prepare the Order Object
        Order order = new Order();
        order.setUserId(user.getId());
        order.setOrderDate(new Date());
        order.setStatus("Pending");
        order.setDeliveryAddress(user.getAddress()); // Use the user's profile address

        // 4. Prepare the Order Items & Calculate Total
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

        // 5. Call DAO to save everything
        OrderDAO orderDAO = new OrderDAO();
        int newOrderId = orderDAO.createOrder(order, orderItems);

        // 6. Handle Success/Failure
        if (newOrderId != -1) {
            // Success: Clear cart and redirect to confirmation
            session.removeAttribute("cart");
            session.setAttribute("lastOrderId", newOrderId);
            response.sendRedirect("orderConfirmation.jsp");
        } else {
            // Failure: Send back to checkout with error
            response.sendRedirect("checkout.jsp?error=Failed to place order. Please try again.");
        }
    }
}