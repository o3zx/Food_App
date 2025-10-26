package org.foodapp.foodapp;

import org.foodapp.foodapp.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    /**
     * Creates a new order in the database.
     * This method uses a transaction to save to both 'orders' and 'order_items'.
     *
     * @param order The main Order object.
     * @param items The List of OrderItem objects.
     * @return The new order's ID if successful, or -1 on failure.
     */
    public int createOrder(Order order, List<OrderItem> items) {
        String sqlOrder = "INSERT INTO orders (user_id, totalAmount, status, deliveryAddress) VALUES (?, ?, ?,?)";
        String sqlItem = "INSERT INTO order_items (order_id, product_id, productName, quantity, priceAtTimeOfOrder) VALUES (?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psItem = null;
        ResultSet rs = null;
        int orderId = -1;

        try {
            conn = DBUtil.getConnection();
            // --- Start Transaction ---
            conn.setAutoCommit(false);

            // 1. Insert the main Order and get its new ID
            psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, order.getUserId());
            psOrder.setDouble(2, order.getTotalAmount());
            psOrder.setString(3, "Pending"); // Default status
            psOrder.setString(4, order.getDeliveryAddress());
            psOrder.executeUpdate();

            // 2. Get the auto-generated order ID
            rs = psOrder.getGeneratedKeys();
            if (rs.next()) {
                orderId = rs.getInt(1);
            } else {
                throw new SQLException("Failed to create order, no ID obtained.");
            }

            // 3. Insert all OrderItems using the new orderId
            psItem = conn.prepareStatement(sqlItem);
            for (OrderItem item : items) {
                psItem.setInt(1, orderId); // Link to the new order
                psItem.setInt(2, item.getProductId());
                psItem.setString(3, item.getProductName());
                psItem.setInt(4, item.getQuantity());
                psItem.setDouble(5, item.getPriceAtTimeOfOrder());
                psItem.addBatch(); // Add this query to a "batch"
            }
            psItem.executeBatch(); // Execute all item inserts at once

            // 4. If all queries succeeded, commit the transaction
            conn.commit();
            // --- End Transaction ---

        } catch (SQLException e) {
            System.err.println("Error creating order (Transaction failed): " + e.getMessage());
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback(); // 5. If anything failed, roll back all changes
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            orderId = -1; // Indicate failure
        } finally {
            // 6. Clean up resources
            try {
                if (rs != null) rs.close();
                if (psOrder != null) psOrder.close();
                if (psItem != null) psItem.close();
                if (conn != null) {
                    conn.setAutoCommit(true); // Reset to default
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return orderId;
    }

    /**
     * Retrieves all orders for a specific user.
     * @param userId The user's ID.
     * @return A List of Order objects.
     */
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY orderDate DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapRowToOrder(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Retrieves all orders in the system (for the admin).
     * @return A List of all Order objects.
     */
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY orderDate DESC";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                orders.add(mapRowToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Retrieves a single order by its ID.
     * @param orderId The order's ID.
     * @return The Order object if found, otherwise null.
     */
    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM orders WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToOrder(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Retrieves all order items for a specific order.
     * @param orderId The order's ID.
     * @return A List of OrderItem objects.
     */
    public List<OrderItem> getItemsForOrder(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getInt("id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setProductName(rs.getString("productName"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPriceAtTimeOfOrder(rs.getDouble("priceAtTimeOfOrder"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    /**
     * Updates the status of an existing order.
     * @param orderId The ID of the order to update.
     * @param newStatus The new status string (e.g., "Preparing").
     * @return true if successful, false otherwise.
     */
    public boolean updateOrderStatus(int orderId, String newStatus) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Helper method to map a ResultSet row to an Order object.
     * Avoids duplicate code.
     */
    private Order mapRowToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setOrderDate(rs.getTimestamp("orderDate"));
        order.setTotalAmount(rs.getDouble("totalAmount"));
        order.setStatus(rs.getString("status"));
        order.setDeliveryAddress(rs.getString("deliveryAddress"));
        return order;
    }
}