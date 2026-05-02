-- ========================================
-- E-COMMERCE MANAGEMENT SYSTEM
-- Sample Data / Test Data
-- ========================================

USE ecommerce_db;

-- ========================================
-- INSERT: Categories
-- ========================================
INSERT INTO Categories (category_name, description) VALUES
('Electronics', 'Electronic devices and gadgets'),
('Clothing', 'Mens and womens clothing'),
('Books', 'Physical and educational books'),
('Home & Kitchen', 'Home appliances and kitchen items'),
('Sports & Outdoors', 'Sports equipment and outdoor gear'),
('Beauty & Personal Care', 'Cosmetics and personal care products');

-- ========================================
-- INSERT: Users (Customers)
-- ========================================
INSERT INTO Users (first_name, last_name, email, phone_number, password_hash, address, city, state, postal_code, country) VALUES
('Rajesh', 'Kumar', 'rajesh.kumar@email.com', '9876543210', 'hashed_password_1', '123 Main St', 'Bengaluru', 'Karnataka', '560001', 'India'),
('Priya', 'Singh', 'priya.singh@email.com', '8765432109', 'hashed_password_2', '456 Oak Ave', 'Mumbai', 'Maharashtra', '400001', 'India'),
('Amit', 'Patel', 'amit.patel@email.com', '7654321098', 'hashed_password_3', '789 Elm St', 'Delhi', 'Delhi', '110001', 'India'),
('Neha', 'Gupta', 'neha.gupta@email.com', '6543210987', 'hashed_password_4', '321 Maple Dr', 'Hyderabad', 'Telangana', '500001', 'India'),
('Vikram', 'Nair', 'vikram.nair@email.com', '5432109876', 'hashed_password_5', '654 Pine Ln', 'Pune', 'Maharashtra', '411001', 'India');

-- ========================================
-- INSERT: Products
-- ========================================
INSERT INTO Products (product_name, description, price, category_id, stock_quantity, sku, manufacturer) VALUES
-- Electronics
('Apple iPhone 14', 'Latest Apple smartphone', 79999.00, 1, 25, 'SKU-001', 'Apple Inc'),
('Samsung Galaxy S23', 'Premium Android phone', 74999.00, 1, 30, 'SKU-002', 'Samsung'),
('Sony Headphones WH-1000XM4', 'Noise cancelling headphones', 29999.00, 1, 50, 'SKU-003', 'Sony'),
('Mi 11X Pro', 'Budget flagship phone', 39999.00, 1, 40, 'SKU-004', 'Xiaomi'),

-- Clothing
('Blue Cotton T-Shirt', 'Comfortable cotton t-shirt', 499.00, 2, 100, 'SKU-005', 'Brand A'),
('Black Jeans', 'Slim fit denim jeans', 1299.00, 2, 75, 'SKU-006', 'Brand B'),
('White Running Shoes', 'Sports running shoes', 3999.00, 2, 60, 'SKU-007', 'Nike'),
('Winter Jacket', 'Warm winter jacket', 5999.00, 2, 30, 'SKU-008', 'Brand C'),

-- Books
('The Lean Startup', 'Business and entrepreneurship book', 599.00, 3, 45, 'SKU-009', 'Penguin Books'),
('Data Science Handbook', 'Complete data science guide', 899.00, 3, 35, 'SKU-010', 'Tech Books'),
('Python Programming', 'Learn Python from basics', 749.00, 3, 55, 'SKU-011', 'Tech Books'),

-- Home & Kitchen
('Electric Kettle', 'Fast boiling kettle', 1299.00, 4, 40, 'SKU-012', 'Philips'),
('Non-stick Frying Pan', 'Durable frying pan', 899.00, 4, 50, 'SKU-013', 'Brand D'),
('LED Desk Lamp', 'Bright and adjustable lamp', 1999.00, 4, 25, 'SKU-014', 'Philips'),

-- Sports & Outdoors
('Cricket Bat', 'Professional cricket bat', 4999.00, 5, 20, 'SKU-015', 'Brand E'),
('Yoga Mat', 'Non-slip yoga mat', 999.00, 5, 80, 'SKU-016', 'Brand F'),

-- Beauty & Personal Care
('Face Moisturizer', 'Daily face moisturizer', 399.00, 6, 100, 'SKU-017', 'Brand G'),
('Hair Shampoo', 'Nourishing shampoo', 299.00, 6, 120, 'SKU-018', 'Brand H');

-- ========================================
-- INSERT: Cart (Shopping Cart Items)
-- ========================================
INSERT INTO Cart (user_id, product_id, quantity) VALUES
(1, 1, 1),      -- Rajesh added iPhone
(1, 3, 2),      -- Rajesh added 2 headphones
(2, 5, 3),      -- Priya added 3 t-shirts
(2, 7, 1),      -- Priya added shoes
(3, 9, 2),      -- Amit added 2 books
(4, 12, 1),     -- Neha added kettle
(5, 15, 1);     -- Vikram added cricket bat

-- ========================================
-- INSERT: Orders
-- ========================================
INSERT INTO Orders (user_id, total_amount, order_status, delivery_address, delivery_city, delivery_state, delivery_postal_code, estimated_delivery_date, actual_delivery_date) VALUES
(1, 99999.00, 'Delivered', '123 Main St', 'Bengaluru', 'Karnataka', '560001', '2024-04-25', '2024-04-24'),
(2, 4799.00, 'Shipped', '456 Oak Ave', 'Mumbai', 'Maharashtra', '400001', '2024-04-28', NULL),
(3, 1198.00, 'Delivered', '789 Elm St', 'Delhi', 'Delhi', '110001', '2024-04-20', '2024-04-20'),
(4, 1299.00, 'Confirmed', '321 Maple Dr', 'Hyderabad', 'Telangana', '500001', '2024-04-27', NULL),
(5, 4999.00, 'Delivered', '654 Pine Ln', 'Pune', 'Maharashtra', '411001', '2024-04-22', '2024-04-22');

-- ========================================
-- INSERT: OrderItems
-- ========================================
INSERT INTO OrderItems (order_id, product_id, quantity, price_at_purchase) VALUES
(1, 1, 1, 79999.00),    -- Order 1: iPhone
(1, 3, 1, 29999.00),    -- Order 1: Headphones
(2, 5, 3, 499.00),      -- Order 2: 3 t-shirts
(2, 7, 1, 3999.00),     -- Order 2: shoes
(3, 9, 2, 599.00),      -- Order 3: 2 books
(4, 12, 1, 1299.00),    -- Order 4: kettle
(5, 15, 1, 4999.00);    -- Order 5: cricket bat

-- ========================================
-- INSERT: Payments
-- ========================================
INSERT INTO Payments (order_id, amount, payment_method, payment_status, transaction_id, payment_date) VALUES
(1, 99999.00, 'Credit Card', 'Completed', 'TXN-001', '2024-04-17 10:30:00'),
(2, 4799.00, 'UPI', 'Completed', 'TXN-002', '2024-04-18 11:45:00'),
(3, 1198.00, 'Debit Card', 'Completed', 'TXN-003', '2024-04-19 09:15:00'),
(4, 1299.00, 'Net Banking', 'Pending', 'TXN-004', NULL),
(5, 4999.00, 'Wallet', 'Completed', 'TXN-005', '2024-04-21 14:20:00');

-- ========================================
-- INSERT: Reviews
-- ========================================
INSERT INTO Reviews (product_id, user_id, rating, comment) VALUES
(1, 1, 5, 'Excellent phone! Very fast and reliable.'),
(1, 2, 4, 'Good phone but a bit expensive.'),
(3, 1, 5, 'Amazing headphones, great noise cancellation!'),
(5, 2, 4, 'Good quality t-shirt, fits well.'),
(7, 2, 5, 'Comfortable shoes, worth the price.'),
(9, 3, 5, 'Highly recommended book for startups.'),
(12, 4, 4, 'Kettle works great, heats water quickly.'),
(15, 5, 5, 'Great cricket bat, good performance.'),
(2, 3, 4, 'Good phone, decent performance.');

-- ========================================
-- Verify Data Insertion
-- ========================================
-- Run these queries to verify data:
-- SELECT COUNT(*) FROM Users;
-- SELECT COUNT(*) FROM Products;
-- SELECT COUNT(*) FROM Orders;
-- SELECT * FROM Users LIMIT 5;
-- SELECT * FROM Products LIMIT 5;