-- ========================================
-- E-COMMERCE MANAGEMENT SYSTEM
-- SQL Queries for Viva Preparation
-- ========================================

USE ecommerce_db;

-- ========================================
-- EASY QUERIES (Basic CRUD + Simple Joins)
-- ========================================

-- 1. Display all users
SELECT user_id, first_name, last_name, email, phone_number FROM Users;

-- 2. Display all products with their categories
SELECT p.product_id, p.product_name, p.price, c.category_name 
FROM Products p 
JOIN Categories c ON p.category_id = c.category_id;

-- 3. Display all orders for a specific user (user_id = 1)
SELECT o.order_id, o.order_date, o.total_amount, o.order_status 
FROM Orders o 
WHERE o.user_id = 1;

-- 4. Display products in Electronics category
SELECT product_id, product_name, price, stock_quantity 
FROM Products 
WHERE category_id = 1
ORDER BY price DESC;

-- 5. Display all items in a specific order (order_id = 1)
SELECT oi.order_item_id, p.product_name, oi.quantity, oi.price_at_purchase, 
       (oi.quantity * oi.price_at_purchase) as total_price
FROM OrderItems oi 
JOIN Products p ON oi.product_id = p.product_id 
WHERE oi.order_id = 1;

-- 6. Display cart items for a specific user (user_id = 1)
SELECT c.cart_id, p.product_name, c.quantity, p.price, 
       (c.quantity * p.price) as subtotal
FROM Cart c 
JOIN Products p ON c.product_id = p.product_id 
WHERE c.user_id = 1;

-- 7. Display all delivered orders
SELECT order_id, user_id, order_date, total_amount, order_status 
FROM Orders 
WHERE order_status = 'Delivered'
ORDER BY order_date DESC;

-- 8. Count total products in each category
SELECT c.category_name, COUNT(p.product_id) as product_count
FROM Categories c 
LEFT JOIN Products p ON c.category_id = p.category_id 
GROUP BY c.category_id, c.category_name
ORDER BY product_count DESC;

-- 9. Display all payment transactions with their status
SELECT p.payment_id, o.order_id, p.amount, p.payment_method, p.payment_status 
FROM Payments p 
JOIN Orders o ON p.order_id = o.order_id;

-- 10. Display products with low stock (less than 30 units)
SELECT product_id, product_name, price, stock_quantity 
FROM Products 
WHERE stock_quantity < 30
ORDER BY stock_quantity ASC;

-- ========================================
-- MEDIUM QUERIES (Aggregations, Grouping, Subqueries)
-- ========================================

-- 11. Calculate total revenue from completed orders
SELECT SUM(total_amount) as total_revenue 
FROM Orders 
WHERE order_status = 'Delivered';

-- 12. Find top 5 best-selling products (by quantity sold)
SELECT p.product_id, p.product_name, SUM(oi.quantity) as total_sold, 
       COUNT(DISTINCT oi.order_id) as number_of_orders
FROM OrderItems oi 
JOIN Products p ON oi.product_id = p.product_id 
GROUP BY p.product_id, p.product_name 
ORDER BY total_sold DESC 
LIMIT 5;

-- 13. Find average product rating for products with reviews
SELECT p.product_id, p.product_name, AVG(r.rating) as avg_rating, 
       COUNT(r.review_id) as review_count
FROM Products p 
LEFT JOIN Reviews r ON p.product_id = r.product_id 
GROUP BY p.product_id, p.product_name 
HAVING COUNT(r.review_id) > 0
ORDER BY avg_rating DESC;

-- 14. Find customers who made more than one order
SELECT u.user_id, u.first_name, u.last_name, COUNT(o.order_id) as order_count, 
       SUM(o.total_amount) as total_spent
FROM Users u 
JOIN Orders o ON u.user_id = o.user_id 
GROUP BY u.user_id, u.first_name, u.last_name 
HAVING COUNT(o.order_id) > 1
ORDER BY total_spent DESC;

-- 15. Revenue breakdown by category
SELECT c.category_name, SUM(oi.quantity * oi.price_at_purchase) as category_revenue,
       COUNT(DISTINCT oi.order_id) as orders, COUNT(DISTINCT oi.product_id) as products_sold
FROM OrderItems oi 
JOIN Products p ON oi.product_id = p.product_id 
JOIN Categories c ON p.category_id = c.category_id 
GROUP BY c.category_id, c.category_name 
ORDER BY category_revenue DESC;

-- 16. Find products that have never been ordered
SELECT p.product_id, p.product_name, p.price, p.stock_quantity 
FROM Products p 
WHERE p.product_id NOT IN (SELECT DISTINCT product_id FROM OrderItems)
ORDER BY p.product_name;

-- 17. Calculate average order value per customer
SELECT u.user_id, u.first_name, u.last_name, 
       AVG(o.total_amount) as avg_order_value, 
       COUNT(o.order_id) as total_orders
FROM Users u 
LEFT JOIN Orders o ON u.user_id = o.user_id 
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY avg_order_value DESC;

-- 18. Find payment methods used in the last 7 days (assuming today's data)
SELECT p.payment_method, COUNT(p.payment_id) as transaction_count, 
       SUM(p.amount) as total_amount
FROM Payments p 
WHERE p.payment_date >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY p.payment_method
ORDER BY total_amount DESC;

-- 19. List customers with pending payment
SELECT DISTINCT u.user_id, u.first_name, u.last_name, u.email, 
       o.order_id, o.total_amount, p.payment_status
FROM Users u 
JOIN Orders o ON u.user_id = o.user_id 
JOIN Payments p ON o.order_id = p.order_id 
WHERE p.payment_status = 'Pending'
ORDER BY o.order_date DESC;

-- 20. Find most reviewed products
SELECT p.product_id, p.product_name, COUNT(r.review_id) as review_count, 
       AVG(r.rating) as avg_rating
FROM Products p 
LEFT JOIN Reviews r ON p.product_id = r.product_id 
GROUP BY p.product_id, p.product_name 
ORDER BY review_count DESC 
LIMIT 10;

-- ========================================
-- HARD QUERIES (Complex, Multiple Joins, Window Functions)
-- ========================================

-- 21. Customer purchase history with product details and order status
SELECT u.user_id, u.first_name, u.last_name, 
       o.order_id, o.order_date, o.order_status,
       GROUP_CONCAT(p.product_name SEPARATOR ', ') as products_purchased,
       SUM(oi.quantity * oi.price_at_purchase) as order_total
FROM Users u 
JOIN Orders o ON u.user_id = o.user_id 
JOIN OrderItems oi ON o.order_id = oi.order_id 
JOIN Products p ON oi.product_id = p.product_id 
GROUP BY u.user_id, u.first_name, u.last_name, o.order_id, o.order_date, o.order_status
ORDER BY o.order_date DESC;

-- 22. Products purchased together (association analysis)
SELECT oi1.product_id as product_1, p1.product_name as product_1_name,
       oi2.product_id as product_2, p2.product_name as product_2_name,
       COUNT(DISTINCT oi1.order_id) as times_bought_together
FROM OrderItems oi1 
JOIN OrderItems oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
JOIN Products p1 ON oi1.product_id = p1.product_id 
JOIN Products p2 ON oi2.product_id = p2.product_id 
GROUP BY oi1.product_id, oi2.product_id, p1.product_name, p2.product_name
HAVING COUNT(DISTINCT oi1.order_id) > 1
ORDER BY times_bought_together DESC;

-- 23. Monthly sales trends (monthly revenue)
SELECT DATE_FORMAT(o.order_date, '%Y-%m') as month, 
       COUNT(DISTINCT o.order_id) as total_orders,
       SUM(o.total_amount) as monthly_revenue,
       AVG(o.total_amount) as avg_order_value
FROM Orders o 
WHERE o.order_status IN ('Delivered', 'Shipped')
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month DESC;

-- 24. Customers who purchased from all categories
SELECT u.user_id, u.first_name, u.last_name, COUNT(DISTINCT c.category_id) as categories_purchased
FROM Users u 
JOIN Orders o ON u.user_id = o.user_id 
JOIN OrderItems oi ON o.order_id = oi.order_id 
JOIN Products p ON oi.product_id = p.product_id 
JOIN Categories c ON p.category_id = c.category_id 
GROUP BY u.user_id, u.first_name, u.last_name 
HAVING COUNT(DISTINCT c.category_id) = (SELECT COUNT(*) FROM Categories)
ORDER BY u.user_id;

-- 25. Rank products by revenue and show position within category
SELECT c.category_name, p.product_id, p.product_name,
       SUM(oi.quantity * oi.price_at_purchase) as product_revenue,
       RANK() OVER (PARTITION BY c.category_id ORDER BY SUM(oi.quantity * oi.price_at_purchase) DESC) as rank_in_category
FROM Products p 
JOIN Categories c ON p.category_id = c.category_id 
LEFT JOIN OrderItems oi ON p.product_id = oi.product_id 
GROUP BY c.category_id, c.category_name, p.product_id, p.product_name
ORDER BY c.category_name, rank_in_category;

-- ========================================
-- BONUS ANALYTICAL QUERIES
-- ========================================

-- Business Metric: Customer Lifetime Value
SELECT u.user_id, u.first_name, u.last_name, 
       COUNT(DISTINCT o.order_id) as total_orders,
       SUM(o.total_amount) as lifetime_value,
       ROUND(AVG(o.total_amount), 2) as avg_order_value,
       MAX(o.order_date) as last_purchase_date
FROM Users u 
LEFT JOIN Orders o ON u.user_id = o.user_id 
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY lifetime_value DESC;

-- Inventory Health: Stock levels and movement
SELECT p.product_id, p.product_name, p.stock_quantity,
       COALESCE(SUM(oi.quantity), 0) as quantity_sold,
       ROUND((p.stock_quantity / (COALESCE(SUM(oi.quantity), 0) + 1)) * 100, 2) as stock_to_sales_ratio
FROM Products p 
LEFT JOIN OrderItems oi ON p.product_id = oi.product_id 
GROUP BY p.product_id, p.product_name, p.stock_quantity
ORDER BY stock_to_sales_ratio DESC;

-- Customer Segmentation: Segment by spending
SELECT u.user_id, u.first_name, u.last_name,
       SUM(o.total_amount) as total_spending,
       CASE 
           WHEN SUM(o.total_amount) > 50000 THEN 'VIP'
           WHEN SUM(o.total_amount) > 10000 THEN 'Premium'
           WHEN SUM(o.total_amount) > 0 THEN 'Regular'
           ELSE 'Inactive'
       END as customer_segment
FROM Users u 
LEFT JOIN Orders o ON u.user_id = o.user_id AND o.order_status != 'Cancelled'
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY total_spending DESC;