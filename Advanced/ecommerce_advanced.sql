USE ecommerce_db;

-- =============================
-- FIXED TRIGGERS
-- =============================

DELIMITER //

DROP TRIGGER IF EXISTS UpdateProductStockOnOrderItem //
CREATE TRIGGER UpdateProductStockOnOrderItem
AFTER INSERT ON OrderItems
FOR EACH ROW
BEGIN
    UPDATE Products 
    SET stock_quantity = stock_quantity - NEW.quantity 
    WHERE product_id = NEW.product_id;
END //

DROP TRIGGER IF EXISTS UpdateOrderTotalOnItemAdd //
CREATE TRIGGER UpdateOrderTotalOnItemAdd
AFTER INSERT ON OrderItems
FOR EACH ROW
BEGIN
    UPDATE Orders 
    SET total_amount = total_amount + (NEW.quantity * NEW.price_at_purchase)
    WHERE order_id = NEW.order_id;
END //

DROP TRIGGER IF EXISTS PreventNegativeStock //
CREATE TRIGGER PreventNegativeStock
BEFORE UPDATE ON Products
FOR EACH ROW
BEGIN
    IF NEW.stock_quantity < 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Stock cannot be negative';
    END IF;
END //

DROP TRIGGER IF EXISTS ClearCartAfterOrder //
CREATE TRIGGER ClearCartAfterOrder
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    DELETE FROM Cart WHERE user_id = NEW.user_id;
END //

DROP TRIGGER IF EXISTS UpdateOrderStatusOnPayment //
CREATE TRIGGER UpdateOrderStatusOnPayment
AFTER UPDATE ON Payments
FOR EACH ROW
BEGIN
    IF NEW.payment_status = 'Completed' AND OLD.payment_status != 'Completed' THEN
        UPDATE Orders 
        SET order_status = 'Confirmed'
        WHERE order_id = NEW.order_id;
    END IF;
END //

DROP TRIGGER IF EXISTS UpdateProductAvailability //
CREATE TRIGGER UpdateProductAvailability
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    IF NEW.stock_quantity = 0 THEN
        UPDATE Products SET is_available = FALSE WHERE product_id = NEW.product_id;
    ELSEIF NEW.stock_quantity > 0 AND OLD.stock_quantity = 0 THEN
        UPDATE Products SET is_available = TRUE WHERE product_id = NEW.product_id;
    END IF;
END //

DELIMITER ;