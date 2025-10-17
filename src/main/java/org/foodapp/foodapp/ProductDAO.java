package org.foodapp.foodapp;

import org.foodapp.foodapp.Product;
import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;

public class ProductDAO {
    // Mock Product Data (must match the IDs in the menu.jsp)
    private static final List<Product> MOCK_PRODUCTS = Arrays.asList(
            new Product(101, "Mock Burger", "Menu item 1 from MOCK data.", 8.99, "burger.jpg"),
            new Product(102, "Mock Pizza", "Menu item 2 from MOCK data.", 12.50, "pizza.jpg"),
            new Product(103, "Mock Dessert", "Menu item 3 from MOCK data.", 4.00, "cake.jpg")
    );

    // Read all products
    public List<Product> getAllProducts() {
        return MOCK_PRODUCTS;
    }

    // Read product by ID (CRUCIAL for Cart logic)
    public Product getProductById(int id) {
        for (Product product : MOCK_PRODUCTS) {
            if (product.getId() == id) {
                return product;
            }
        }
        return null; // Return null if not found
    }
}