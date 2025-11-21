-- ==========================================
-- FOOD APP DATABASE SETUP SCRIPT
-- ==========================================

-- 1. Create and Use the Database
CREATE DATABASE IF NOT EXISTS foodapp_db;
USE foodapp_db;

-- 2. Drop tables if they exist (to ensure a clean slate)
-- Order matters due to Foreign Keys!
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

-- 3. Create Users Table
CREATE TABLE users (
                       id INT NOT NULL AUTO_INCREMENT,
                       username VARCHAR(100) NOT NULL UNIQUE,
                       email VARCHAR(255) NOT NULL UNIQUE,
                       passwordHash VARCHAR(255) NOT NULL,
                       role VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER', -- Roles: CUSTOMER, ADMIN, DRIVER
                       address TEXT,
                       PRIMARY KEY (id)
);

-- 4. Create Products Table
CREATE TABLE products (
                          id INT NOT NULL AUTO_INCREMENT,
                          name VARCHAR(255) NOT NULL,
                          description TEXT,
                          price DECIMAL(10, 2) NOT NULL,
                          imageUrl VARCHAR(255),
                          category VARCHAR(100), -- Added for Menu Categorization
                          PRIMARY KEY (id)
);

-- 5. Create Orders Table
CREATE TABLE orders (
                        id INT NOT NULL AUTO_INCREMENT,
                        user_id INT NOT NULL,
                        orderDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        totalAmount DECIMAL(10, 2) NOT NULL,
                        status VARCHAR(50) NOT NULL DEFAULT 'Pending',
                        deliveryAddress TEXT,
                        driver_id INT NULL, -- Links to a User with role 'DRIVER'
                        PRIMARY KEY (id),
                        FOREIGN KEY (user_id) REFERENCES users(id),
                        FOREIGN KEY (driver_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 6. Create Order Items Table
CREATE TABLE order_items (
                             id INT NOT NULL AUTO_INCREMENT,
                             order_id INT NOT NULL,
                             product_id INT NOT NULL,
                             productName VARCHAR(255) NOT NULL, -- Stored in case product is deleted/changed
                             quantity INT NOT NULL,
                             priceAtTimeOfOrder DECIMAL(10, 2) NOT NULL,
                             PRIMARY KEY (id),
                             FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
                             FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ==========================================
-- OPTIONAL: SEED DATA (Sample Products)
-- ==========================================

INSERT INTO products (name, description, price, imageUrl, category) VALUES
                                                                        ('Classic Burger', 'Juicy beef patty with lettuce, tomato, and cheese.', 8.99, 'burger.jpg', 'Burgers'),
                                                                        ('Double Cheeseburger', 'Two patties, double cheese, special sauce.', 12.50, 'burger.jpg', 'Burgers'),
                                                                        ('Veggie Pizza', 'Mushrooms, peppers, onions, and olives.', 12.50, 'pizza.jpg', 'Pizza'),
                                                                        ('Pepperoni Pizza', 'Classic pepperoni with mozzarella cheese.', 14.00, 'pizza.jpg', 'Pizza'),
                                                                        ('Chocolate Cake', 'Rich dark chocolate cake with frosting.', 4.00, 'cake.jpg', 'Desserts'),
                                                                        ('Cola', 'Refreshing cold soda.', 1.99, 'cola.jpg', 'Drinks');