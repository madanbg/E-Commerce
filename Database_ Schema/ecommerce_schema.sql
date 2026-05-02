-- ========================================
-- E-COMMERCE MANAGEMENT SYSTEM
-- Database Schema
-- ========================================

-- Drop database if exists (careful with this!)
DROP DATABASE IF EXISTS ecommerce_db;

-- Create Database
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- ========================================
-- TABLE 1: Users (Customers)
-- ========================================
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    password_hash VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(10),
    country VARCHAR(50),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME,
    is_active BOOLEAN DEFAULT TRUE
);

-- ========================================
-- TABLE 2: Categories (Product Categories)
-- ========================================
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================================
-- TABLE 3: Products (Product Catalog)
-- ========================================
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    category_id INT NOT NULL,
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    sku VARCHAR(50) UNIQUE,
    manufacturer VARCHAR(100),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE RESTRICT
);

-- ========================================
-- TABLE 4: Cart (Shopping Cart)
-- ========================================
CREATE TABLE Cart (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product (user_id, product_id)
);

-- ========================================
-- TABLE 5: Orders (Customer Orders)
-- ========================================
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(12, 2) NOT NULL CHECK (total_amount >= 0),
    order_status ENUM('Pending', 'Confirmed', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    delivery_address VARCHAR(255) NOT NULL,
    delivery_city VARCHAR(50),
    delivery_state VARCHAR(50),
    delivery_postal_code VARCHAR(10),
    estimated_delivery_date DATE,
    actual_delivery_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE RESTRICT
);

-- ========================================
-- TABLE 6: OrderItems (Items in Each Order)
-- ========================================
CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_purchase DECIMAL(10, 2) NOT NULL CHECK (price_at_purchase >= 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE RESTRICT
);

-- ========================================
-- TABLE 7: Payments (Payment Records)
-- ========================================
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL UNIQUE,
    amount DECIMAL(12, 2) NOT NULL CHECK (amount >= 0),
    payment_method ENUM('Credit Card', 'Debit Card', 'UPI', 'Net Banking', 'Wallet', 'Cash on Delivery') DEFAULT 'Credit Card',
    payment_status ENUM('Pending', 'Completed', 'Failed', 'Refunded') DEFAULT 'Pending',
    transaction_id VARCHAR(100),
    payment_date DATETIME,
    refund_date DATETIME,
    refund_amount DECIMAL(12, 2) CHECK (refund_amount >= 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE RESTRICT
);

-- ========================================
-- TABLE 8: Reviews (Product Reviews)
-- ========================================
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    helpful_count INT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product_review (user_id, product_id)
);

-- ========================================
-- INDEXES (For Performance Optimization)
-- ========================================

-- Users indexes
CREATE INDEX idx_user_email ON Users(email);
CREATE INDEX idx_user_created_date ON Users(created_date);

-- Products indexes
CREATE INDEX idx_product_category ON Products(category_id);
CREATE INDEX idx_product_name ON Products(product_name);
CREATE INDEX idx_product_sku ON Products(sku);

-- Cart indexes
CREATE INDEX idx_cart_user ON Cart(user_id);
CREATE INDEX idx_cart_product ON Cart(product_id);

-- Orders indexes
CREATE INDEX idx_order_user ON Orders(user_id);
CREATE INDEX idx_order_date ON Orders(order_date);
CREATE INDEX idx_order_status ON Orders(order_status);

-- OrderItems indexes
CREATE INDEX idx_orderitem_order ON OrderItems(order_id);
CREATE INDEX idx_orderitem_product ON OrderItems(product_id);

-- Payments indexes
CREATE INDEX idx_payment_order ON Payments(order_id);
CREATE INDEX idx_payment_status ON Payments(payment_status);

-- Reviews indexes
CREATE INDEX idx_review_product ON Reviews(product_id);
CREATE INDEX idx_review_user ON Reviews(user_id);
CREATE INDEX idx_review_rating ON Reviews(rating);

-- ========================================
-- END OF SCHEMA
-- ========================================