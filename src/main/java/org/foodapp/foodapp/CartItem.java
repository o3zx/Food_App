package org.foodapp.foodapp;

public class CartItem {
    private Product product;
    private int quantity;


    public CartItem(Product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
    }


    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }


    public double getTotalPrice() {
        // Ensure price is not null before calculating
        if (product != null) {
            return product.getPrice() * quantity;
        }
        return 0.0;
    }
}
