package org.foodapp.foodapp;

import org.foodapp.foodapp.util.DBUtil; // Import our DB connection utility
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;

public class ProductDAO {

    /**
     * Fetches all products from the database.
     * @return A List of Product objects.
     */
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        // Simple SQL query to get all products
        String sql = "SELECT * FROM products";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            // Loop through all rows in the result set
            while (rs.next()) {
                // Use the helper method that correctly gets the category
                products.add(mapRowToProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    /**
     * Fetches a single product by its ID.
     * @param id The product's ID.
     * @return The Product object if found, otherwise null.
     */
    public Product getProductById(int id) {
        String sql = "SELECT * FROM products WHERE id = ?";
        Product product = null;

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id); // Set the ID for the '?' placeholder

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    product = mapRowToProduct(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching product by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return product;
    }

    public boolean deleteProduct(int id) {
        String sql = "DELETE FROM products WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            // Special check: If this fails due to a 'foreign key constraint'
            // (meaning the product is in an old order), we can't delete it.
            System.err.println("Error deleting product: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Helper method to map a ResultSet row to a Product object.
     * I created this to avoid duplicate code in getAllProducts and getProductById.
     */
    private Product mapRowToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setID(rs.getInt("id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getDouble("price"));
        product.setImageUrl(rs.getString("imageUrl"));
        product.setCategory(rs.getString("category"));
        return product;
    }
    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET name = ?, description = ?, price = ?, imageUrl = ?, category = ? WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setDouble(3, product.getPrice());
            ps.setString(4, product.getImageUrl());
            ps.setString(5, product.getCategory());
            ps.setInt(6, product.getId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean addProduct(Product product) {
        String sql = "INSERT INTO products (name, description, price, imageUrl, category) VALUES (?, ?, ?, ?,?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setDouble(3, product.getPrice());
            ps.setString(4, product.getImageUrl()); // Can be null or empty
            ps.setString(5, product.getCategory());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public Map<String, List<Product>> getProductsGroupedByCategory() {

        Map<String, List<Product>> productMap = new LinkedHashMap<>();

        // Order by category to group them together
        String sql = "SELECT * FROM products ORDER BY category, name";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                // Use our existing helper to create the product
                Product product = mapRowToProduct(rs);
                String category = product.getCategory();

                // If the map doesn't have this category yet, create a new list for it
                if (!productMap.containsKey(category)) {
                    productMap.put(category, new ArrayList<>());
                }

                // Add the current product to its category's list
                productMap.get(category).add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return productMap;
    }
    public List<Product> searchProducts(String searchTerm) {
        List<Product> products = new ArrayList<>();
        // SQL query that searches name AND description
        String sql = "SELECT * FROM products WHERE name LIKE ? OR description LIKE ?";

        // We add '%' to the search term to match any part of the text
        String query = "%" + searchTerm + "%";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, query);
            ps.setString(2, query);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // Use our existing helper to create the product
                    products.add(mapRowToProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error searching products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
}


