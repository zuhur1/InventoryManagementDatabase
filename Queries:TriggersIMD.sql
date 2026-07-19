SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;
USE inventory_management_db;
/* This Section creates Queries to retrive specific information that gives insights. As well as creating a view of products that are low in stock and a Trigger 
that update in stock quantity when a new order is placed. */

/* 1. Retrieve all warranties linked to product sales */

SELECT c.customer_name, p.product_name, w.warranty_start_date, w.warranty_end_date
FROM Customers c
JOIN Sales s ON c.customer_id = s.customer_id
JOIN Warranties w ON s.sale_id = w.sale_id
JOIN Products p ON w.product_id = p.product_id;

/* 2. Find all payment methods used by customers */

SELECT 
    pm.payment_type,
    pm.payment_date,
    c.customer_name
FROM Payment_Methods pm
JOIN Sales s ON pm.sale_id = s.sale_id
JOIN Customers c ON s.customer_id = c.customer_id;

/* 3. List product returns and the reason for return */

SELECT r.return_reason, return_date, s.sale_id, c.customer_name, p.product_name
FROM Returns r
JOIN Sales s ON r.sale_id = s.sale_id
JOIN Customers c ON s.customer_id = c.customer_id
JOIN Products p ON s.product_id = p.product_id;

/* 4. Show all invoices for customer sales */

SELECT 
    c.customer_name,
    i.invoice_date,
    i.total_amount
FROM Invoices i
JOIN Sales s 
    ON i.sale_id = s.sale_id
JOIN Customers c 
    ON s.customer_id = c.customer_id;

/* 5. List products and their discount details */

SELECT  p.product_name, d.discount_percentage, d.discount_start_date, d.discount_end_date
FROM Discounts d
JOIN Products p ON d.product_id = p.product_id;

/* 6. Find total sales by customer */

SELECT c.customer_name, SUM(s.quantity_sold) AS total_quantity
FROM Customers c
JOIN Sales s ON s.customer_id = c.customer_id
GROUP BY c.customer_name;

/* 7. Show payment methods for sales between '2024-09-05' and '2024-09-10' */

SELECT pm.payment_date, pm.payment_type, c.customer_name
FROM Payment_Methods pm
JOIN Sales s ON pm.sale_id = s.sale_id
JOIN Customers c ON s.customer_id = c.customer_id
WHERE pm.payment_date BETWEEN '2024-09-05' AND '2024-09-10';

/* 8. List all products that have been sold with a warranty */

SELECT 
    p.product_name,
    w.warranty_start_date,
    w.warranty_end_date
FROM Products p
JOIN Warranties w 
    ON p.product_id = w.product_id;

/* 9. Find all returns that happened after a specific date */

SELECT re.return_reason, RE.return_date, s.sale_id, c.customer_name, p.product_name
FROM Returns re
JOIN Sales s ON re.sale_id = s.sale_id
JOIN Customers c ON s.customer_id = c.customer_id
JOIN Products p ON s.product_id = p.product_id
WHERE re.return_date > '2024-09-01';

/* 10. List all customers and the products they purchased */

SELECT p.product_name, c.customer_name
FROM Sales s
JOIN Products p on s.product_id = p.product_id
JOIN Customers c on s.customer_id = c.customer_id;

/* 11. Find all shipments made between '2024-09-09' and '2024-09-11' */

SELECT * FROM Shipments WHERE shipment_date BETWEEN '2024-09-09' AND'2024-09-11';

/* 12. Find the tracking numbers for shipments handled by 'Tech Supplies Ltd.' */

SELECT 
    sh.tracking_number,
    sp.supplier_name
FROM Shipments sh
JOIN Orders o 
    ON sh.order_id = o.order_id
JOIN Suppliers sp 
    ON o.supplier_id = sp.supplier_id
WHERE sp.supplier_name = 'Tech Supplies Ltd.';

/* 13. Find the total quantity of 'Laptop' sold to customers */

SELECT SUM(quantity_sold) AS total_customers
FROM Sales s
JOIN Products p on s.product_id = p.product_id
WHERE product_name = 'Laptop';

/* 14. Find the names and contact information of customers who made a purchase of more than 2 items */

SELECT c.customer_name, c.customer_email, c.phone_number, SUM(sa.quantity_sold) AS total_items
FROM Customers c
JOIN Sales sa ON c.customer_id = sa.customer_id
GROUP BY c.customer_name, c.customer_email, c.phone_number
HAVING SUM(sa.quantity_sold) > 2;

/* 15. Find shipments that have not been assigned a tracking number */

SELECT * FROM Shipments WHERE tracking_number is NULL;


/* 17. Retrieve all sales with their corresponding invoices and discounts */

SELECT s.sale_id, p.product_name, i.invoice_date, i.total_amount, d.discount_percentage
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
JOIN Invoices i ON s.sale_id = i.sale_id
LEFT JOIN Discounts d ON p.product_id = d.product_id;

/*  18. Product Returns Rate */

SELECT
    p.product_name,
    COUNT(r.return_id) / COUNT(s.sale_id) AS return_rate
FROM Products p
LEFT JOIN Sales s
    ON p.product_id = s.product_id
LEFT JOIN Returns r
    ON s.sale_id = r.sale_id
GROUP BY p.product_name;

/*  19. Order Fullfillment Time: Tracks how long it takes for an order to be shipped after it is placed */

SELECT 
    o.order_id,
    DATEDIFF(s.shipment_date, o.order_date) AS fulfillment_time
FROM Orders o
JOIN Shipments s 
    ON o.order_id = s.order_id;

/* 20. Discount Utilization: Tracks how often discounts are applied to orders */

SELECT 
    d.discount_percentage,
    COUNT(s.sale_id) AS discount_usage
FROM Sales s
JOIN Products p
    ON s.product_id = p.product_id
JOIN Discounts d
    ON p.product_id = d.product_id
GROUP BY d.discount_percentage;

/* 21. Products low on stock: shows which products are low on stock, meaning there is a quantity of less than 10 on hand */
DROP VIEW IF EXISTS `Low_Stock_Products`;
CREATE VIEW Low_Stock_Products AS
SELECT p.product_id, p.product_name, p.stock_quantity
FROM Products p
WHERE p.stock_quantity < 10;

/* 22. Trigger: Update Stock Quantity After Sale */

DELIMITER //

CREATE TRIGGER Update_Stock_After_Sale
AFTER INSERT ON Sales
FOR EACH ROW
BEGIN

UPDATE Products
SET stock_quantity = stock_quantity - NEW.quantity_sold
WHERE product_id = NEW.product_id;

END //

DELIMITER ;

SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;
