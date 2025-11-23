-- ==========================================
-- FOODAPP DATABASE MASTER SCRIPT
-- ==========================================

-- 1. Create and Select Database
CREATE DATABASE IF NOT EXISTS foodapp_db;
USE foodapp_db;

-- 2. Reset Database (Drop old tables to prevent conflicts)
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

-- ==========================================
-- TABLE CREATION
-- ==========================================

-- 3. Users Table
CREATE TABLE users (
                       id INT NOT NULL AUTO_INCREMENT,
                       username VARCHAR(100) NOT NULL UNIQUE,
                       email VARCHAR(255) NOT NULL UNIQUE,
                       passwordHash VARCHAR(255) NOT NULL, -- Stores BCrypt Hash
                       role VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER', -- Roles: CUSTOMER, ADMIN, DRIVER
                       address TEXT,
                       PRIMARY KEY (id)
);

-- 4. Products Table
CREATE TABLE products (
                          id INT NOT NULL AUTO_INCREMENT,
                          name VARCHAR(255) NOT NULL,
                          description TEXT,
                          price DECIMAL(10, 2) NOT NULL,
                          imageUrl TEXT, -- Changed to TEXT to support long URLs
                          category VARCHAR(100),
                          PRIMARY KEY (id)
);

-- 5. Orders Table
CREATE TABLE orders (
                        id INT NOT NULL AUTO_INCREMENT,
                        user_id INT NOT NULL,
                        orderDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        totalAmount DECIMAL(10, 2) NOT NULL,
                        status VARCHAR(50) NOT NULL DEFAULT 'Pending',
                        deliveryAddress TEXT,
                        driver_id INT NULL, -- Assigned Driver
                        PRIMARY KEY (id),
                        FOREIGN KEY (user_id) REFERENCES users(id),
                        FOREIGN KEY (driver_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 6. Order Items Table
CREATE TABLE order_items (
                             id INT NOT NULL AUTO_INCREMENT,
                             order_id INT NOT NULL,
                             product_id INT NOT NULL,
                             productName VARCHAR(255) NOT NULL,
                             quantity INT NOT NULL,
                             priceAtTimeOfOrder DECIMAL(10, 2) NOT NULL,
                             PRIMARY KEY (id),
                             FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
                             FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ==========================================
-- DATA SEEDING (Pre-loaded Data)
-- ==========================================

-- 7. Insert Users (Admin & Driver)
-- The password for both accounts is: password123
-- The hash below corresponds to 'password123' generated via BCrypt.
INSERT INTO users (username, email, passwordHash, role, address) VALUES
                                                                     ('admin', 'admin@foodapp.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRkgVduVkzCz./sFj3fO.g/tpw6', 'ADMIN', 'FoodApp HQ'),
                                                                     ('driver1', 'driver@foodapp.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRkgVduVkzCz./sFj3fO.g/tpw6', 'DRIVER', 'Delivery Station 1');

-- 8. Insert Products (With Live Images)
INSERT INTO products (name, description, price, category, imageUrl) VALUES
-- Burgers
('Classic Cheeseburger', 'Juicy beef patty with fresh lettuce and tomato on a wooden board.', 8.99, 'Burgers', 'https://media.istockphoto.com/id/1309352410/photo/cheeseburger-with-tomato-and-lettuce-on-wooden-board.jpg?s=612x612&w=0&k=20&c=lfsA0dHDMQdam2M1yvva0_RXfjAyp4gyLtx4YUJmXgg='),
('Double Smash Burger', 'Two crispy smashed patties with melted cheese and special sauce.', 12.50, 'Burgers', 'https://www.kitchensanctuary.com/wp-content/uploads/2024/07/Smash-Burgers-square-FS.jpg'),

-- Pizza
('Margherita Pizza', 'Classic Italian pizza with tomato sauce, fresh mozzarella, and basil.', 12.50, 'Pizza', 'https://assets.surlatable.com/m/15a89c2d9c6c1345/72_dpi_webp-REC-283110_Pizza.jpg'),
('Pepperoni Feast', 'Loaded with spicy pepperoni slices and extra mozzarella cheese.', 14.00, 'Pizza', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQqPdw5UHoUzZbshSYx6C6IFyFatnpjQ8TAA&s?'),

-- Desserts
('Creamy Cheesecake', 'No-bake cheesecake with a buttery graham cracker crust.', 6.50, 'Desserts', 'https://www.recipetineats.com/tachyon/2024/09/No-bake-cheesecake_8.jpg'),
('Tiramisu', 'Elegant Italian dessert with espresso-soaked ladyfingers and mascarpone.', 7.00, 'Desserts', 'https://bakewithzoha.com/wp-content/uploads/2025/06/tiramisu-featured.jpg'),

-- Drinks
('Coca-Cola', 'Ice cold original taste Coca-Cola can.', 1.99, 'Drinks', 'https://www.coca-cola.com/content/dam/onexp/xf/en/product-images/coca-cola-original-taste-can.png'),
('Virgin Mojito', 'Refreshing mint and lime mocktail over crushed ice.', 4.50, 'Drinks', 'https://www.saveur.com/uploads/2007/02/SAVEUR_Mojito_1149-Edit-scaled.jpg?format=auto&optimize=high&width=1440');