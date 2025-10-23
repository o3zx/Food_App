package org.foodapp.foodapp;
import org.foodapp.foodapp.Order;
import org.foodapp.foodapp.OrderItem;
import java.util.List;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class OrderDAO {

    // --- Simulated Database for Orders ---
    private static final List<Order> mockOrders = new ArrayList<>();
    // We also store the items for each order ID
    private static final Map<Integer, List<OrderItem>> mockOrderItems = new HashMap<>();

    private static int mockOrderIdCounter = 1001;

    /**
     * Simulates creating an order in the database.
     * NOW SAVES to the mock list.
     * @return The mock ID of the created order, or -1 on failure.
     */
    public int createOrder(Order order, List<OrderItem> items) {

        System.out.println("--- MOCK DAO: CREATING ORDER ---");

        if (order == null || items == null || items.isEmpty()) {
            return -1;
        }

        // 1. Simulate getting a new Order ID
        int newOrderId = mockOrderIdCounter++;
        order.setId(newOrderId);

        // 2. Link items to the new order ID
        for (OrderItem item : items) {
            item.setOrderId(newOrderId);
        }

        // 3. "Save" to our mock database
        mockOrders.add(order);
        mockOrderItems.put(newOrderId, items);

        System.out.println("Order saved with ID: " + order.getId());
        System.out.println("Total Amount: $" + String.format("%.2f", order.getTotalAmount()));

        return newOrderId;
    }

    /**
     * Retrieves ALL orders (for the admin).
     * In a real app, you'd filter by status, date, etc.
     */

    /**
     * Retrieves all orders for a specific user.
     */
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> userOrders = new ArrayList<>();

        for (Order order : mockOrders) {
            if (order.getUserId() == userId) {
                userOrders.add(order);
            }
        }

        System.out.println("DAO: Found " + userOrders.size() + " orders for user ID: " + userId);
        return userOrders;
    }

    /**
     * Retrieves a single order by its unique ID.
     */
    public Order getOrderById(int orderId) {
        for (Order order : mockOrders) {
            if (order.getId() == orderId) {
                return order; // Found it
            }
        }
        return null; // Not found
    }




    public List<Order> getAllOrders() {
        System.out.println("DAO: Retrieving all " + mockOrders.size() + " orders.");
        // Return a copy to prevent modification
        return new ArrayList<>(mockOrders);
    }

    /**
     * Retrieves the items for a specific order.
     */
    public List<OrderItem> getItemsForOrder(int orderId) {
        return mockOrderItems.getOrDefault(orderId, new ArrayList<>());
    }

    /**
     * Updates the status of an existing order.
     */
    public boolean updateOrderStatus(int orderId, String newStatus) {
        for (Order order : mockOrders) {
            if (order.getId() == orderId) {
                order.setStatus(newStatus);
                System.out.println("DAO: Updated order " + orderId + " to " + newStatus);
                return true;
            }
        }
        System.out.println("DAO: Failed to find order " + orderId + " to update.");
        return false;
    }
}