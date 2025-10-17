package org.foodapp.foodapp;

public class OrderItem {
    private int id;
    private int orderId;
    private int productId;
    private String productName; // Store name in case product is deleted later
    private int quantity;
    private double priceAtTimeOfOrder;


    public OrderItem() {}



    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getPriceAtTimeOfOrder() { return priceAtTimeOfOrder; }
    public void setPriceAtTimeOfOrder(double priceAtTimeOfOrder) { this.priceAtTimeOfOrder = priceAtTimeOfOrder; }
}