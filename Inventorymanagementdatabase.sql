-- Set Up the Database; this includes setting foreign key checks and creating the database
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;

Drop Database if exists inventory_management_db;
CREATE DATABASE inventory_management_db;
USE inventory_management_db;

/* Create the Entities in the database and populate them with data entries. This database consists of the following tables: 
- Products, Suppliers, Orders, Customers, Sales, Shipments, Warrenties, Payment_methods, Returns, Invoices, Discounts */

DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(100),
    price DECIMAL(10, 2),
    stock_quantity INT
);

INSERT INTO Products (product_name, category, price, stock_quantity) VALUES
	('Laptop', 'Electronics', 800.00, 50),
	('Desk Chair', 'Furniture', 120.00, 100),
	('Office Desk', 'Furniture', 250.00, 30);

DROP TABLE IF EXISTS Suppliers;
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    phone_number VARCHAR(15)
);

INSERT INTO Suppliers (supplier_name, contact_name, phone_number) VALUES
	('Tech Supplies Ltd.', 'John Smith', '555-1234'),
	('Furniture Depot', 'Alice Brown', '555-5678');

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    supplier_id INT,
    order_date DATE,
    quantity_ordered INT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE CASCADE
);

INSERT INTO Orders (product_id, supplier_id, order_date, quantity_ordered) VALUES	
	(1, 1, '2024-09-01', 20),
	(2, 2, '2024-09-02', 50),
	(3, 2, '2024-09-03', 10);


DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
	customer_name VARCHAR(100) NOT NULL,
	customer_email VARCHAR(100),
	phone_number VARCHAR(15)
);

INSERT INTO Customers (customer_name, customer_email, phone_number) VALUES
	('Alice Green', 'alice@example.com', '555-1234'),
	('Bob White', 'bob@example.com', '555-5678'),
	('Charlie Black', 'charlie@example.com', '555-9012');

DROP TABLE IF EXISTS Sales;
CREATE TABLE Sales (
	sale_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    product_id INT,
    sale_date DATE,
    quantity_sold INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
);

INSERT INTO Sales (customer_id, product_id, sale_date, quantity_sold) VALUES
	(1, 1, '2024-09-05', 2),
	(1, 2, '2024-09-06', 1),
	(2, 1, '2024-09-07', 3),
	(3, 3, '2024-09-08', 5);

DROP TABLE IF EXISTS Shipments;
CREATE TABLE Shipments(
	sale_id INT,
	supplier_id INT,
	shipment_date DATE,
	tracking_number VARCHAR(100),
	FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE CASCADE
);

INSERT INTO Shipments (sale_id, supplier_id, shipment_date, tracking_number) VALUES
	(1, 1, '2024-09-09', 'TRACK12345'),
	(2, 2, '2024-09-10', 'TRACK67890'),
	(3, 2, '2024-09-11', 'TRACK09876');

DROP TABLE IF EXISTS Warranties;
CREATE TABLE Warranties (
	warranty_id INT PRIMARY KEY AUTO_INCREMENT,
	warranty_start_date DATE,
    warranty_end_date DATE,
    sale_id INT,
    product_id INT,
    FOREIGN KEY (sale_id) REFERENCES Sales(sale_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
    );

INSERT INTO Warranties (sale_id, product_id, warranty_start_date, warranty_end_date) VALUES
	(1, 1, '2024-09-06', '2025-09-06'),
	(2, 2, '2024-09-07', '2025-09-07'),
	(3, 3, '2024-09-08', '2026-09-08');

DROP TABLE IF EXISTS Payment_Methods;
CREATE TABLE Payment_Methods(
	payment_method_id INT PRIMARY KEY AUTO_INCREMENT,
	payment_type VARCHAR(100) NOT NULL,
    payment_date DATE,
    card_last_four_digits INT,
    sale_id INT,
    FOREIGN KEY (sale_id) REFERENCES Sales(sale_id) ON DELETE CASCADE
    );

INSERT INTO Payment_Methods (sale_id, payment_type, payment_date, card_last_four_digits) VALUES
	(1, 'Credit Card', '2024-09-05', '1234'),
	(2, 'PayPal', '2024-09-06', NULL),
	(3, 'Debit Card', '2024-09-07', '5678');


DROP TABLE IF EXISTS Returns;
CREATE TABLE Returns (
	return_id INT PRIMARY KEY AUTO_INCREMENT,
	return_date DATE,
    return_reason VARCHAR(100),
    sale_id INT,
    product_id INT,
    FOREIGN KEY (sale_id) REFERENCES Sales(sale_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
    );

INSERT INTO Returns (sale_id, product_id, return_date, return_reason) VALUES
	(1, 1, '2024-09-10', 'Defective product'),
	(2, 2, '2024-09-11', 'Wrong item delivered'),
	(3, 3, '2024-09-12', 'Changed mind');

DROP TABLE IF EXISTS Invoices;
CREATE TABLE Invoices (
	invoice_id INT AUTO_INCREMENT PRIMARY KEY,
	invoice_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    sale_id INT NOT NULL,
    FOREIGN KEY (sale_id) REFERENCES Sales(sale_id) ON DELETE CASCADE
    );
    
INSERT INTO Invoices (sale_id, invoice_date, total_amount) VALUES
	(1, '2024-09-05', 999.99),
	(2, '2024-09-06', 499.99),
	(3, '2024-09-07', 799.99);

DROP TABLE IF EXISTS Discounts;
CREATE TABLE Discounts(
	discount_id INT PRIMARY KEY AUTO_INCREMENT,
	discount_percentage DECIMAL(5,2),
    discount_start_date DATE,
    discount_end_date DATE, 
    product_id INT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
    );
INSERT INTO Discounts (product_id, discount_percentage, discount_start_date, discount_end_date) VALUES
	(1, 10.00, '2024-09-01', '2024-09-10'),
	(2, 15.00, '2024-09-05', '2024-09-15'),
	(3, 5.00, '2024-09-10', '2024-09-20');

/* This Section creates Queries to retrive specific information that gives insights. As well as creating a view of products that are low in stock and a Trigger 
that update in stock quantity when a new order is placed. */

/* 1. Retrieve all warranties linked to product sales */

SELECT c.customer_name, p.product_name, w.warranty_start_date, w.warranty_end_date
FROM Customers c
JOIN Sales s ON c.customer_id = s.customer_id
JOIN Warranties w ON s.sale_id = w.sale_id
JOIN Products p ON w.product_id = p.product_id;

/* 2. Find all payment methods used by customers */

SELECT s.payment_type, s.payment_date, k.customer_name
FROM Payment_Methods s
JOIN Sales o ON o.sale_id = s.sale_id
JOIN Customers k on k.customer_id = o.customer_id;

/* 3. List product returns and the reason for return */

SELECT r.return_reason, return_date, s.sale_id, c.customer_name, p.product_name
FROM Returns r
JOIN Sales s ON r.sale_id = s.sale_id
JOIN Customers c ON s.customer_id = c.customer_id
JOIN Products p ON s.product_id = p.product_id;

/* 4. Show all invoices for customer sales */

SELECT c.customer_name, i.invoice_date, i.total_amount
FROM Invoices i
JOIN Sales s ON i.sale_id = i.sale_id
JOIN Customers c ON s.customer_id = c.customer_id;

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

SELECT p.product_name, warranty_start_date, warranty_end_date
FROM Products p
JOIN Sales s ON p.product_id = s.customer_id
JOIN Warranties w ON p.product_id = w.product_id;

/* 9. Find all returns that happened after a specific date */

SELECT re.return_reason, RE.return_date, s.sale_id, c.customer_name, p.product_name
FROM Returns re
JOIN Sales s ON re.sale_id = s.sale_id
JOIN Customers c ON s.customer_id = c.customer_id
JOIN Products p ON s.product_id = p.product_id
WHERE re.return_date > "2024-09-01";

/* 10. List all customers and the products they purchased */

SELECT p.product_name, c.customer_name
FROM Sales s
JOIN Products p on s.product_id = p.product_id
JOIN Customers c on s.customer_id = c.customer_id;

/* 11. Find all shipments made between '2024-09-09' and '2024-09-11' */

SELECT * FROM Shipments WHERE shipment_date BETWEEN '2024-09-09' AND'2024-09-11';

/* 12. Find the tracking numbers for shipments handled by 'Tech Supplies Ltd.' */

SELECT tracking_number, supplier_name
FROM Shipments t
JOIN Suppliers n ON n.supplier_id = t.supplier_id
WHERE n.supplier_name = 'Tech Supplies Ltd.';

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

/* 16. Inserting 4 New Records into the Shipments Table */ 
-- Insert the following 4 new records into the Shipments table with the following details:
/*
sale_id: 1, supplier_id: 2, shipment_date: '2024-09-12', tracking_number: 'TRACK54321'
sale_id: 2, supplier_id: 1, shipment_date: '2024-09-13', tracking_number: NULL
sale_id: 3, supplier_id: 1, shipment_date: '2024-09-14', tracking_number: NULL
sale_id: 1, supplier_id: 1, shipment_date: '2024-09-15', tracking_number: 'TRACK43210'
*/

INSERT INTO Shipments (sale_id, supplier_id, shipment_date, tracking_number) VALUES
(1, 2, '2024-09-12', 'TRACK54321'),
(2, 1, '2024-09-13', NULL),
(3, 1, '2024-09-14', NULL),
(1, 1, '2024-09-15', 'TRACK43210');

/* 17. Retrieve all sales with their corresponding invoices and discounts */
SELECT s.sale_id, p.product_name, i.invoice_date, i.total_amount, d.discount_percentage
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
JOIN Invoices i ON s.sale_id = i.sale_id
LEFT JOIN Discounts d ON p.product_id = d.product_id;

/*  18. Product Returns Rate */
SELECT p.product_name, COUNT(r.return_id) AS total_returns
FROM Returns r
JOIN Products p ON r.product_id = p.product_id
GROUP BY p.product_name;

/*  19. Order Fullfillment Time: Tracks how long it takes for an order to be shipped after it is placed */
SELECT o.order_id, DATEDIFF(s.shipment_date, o.order_date) AS fullfillment_time
FROM Orders o
JOIN Shipments s ON o.order_id = s.order_id;

/* 20. Discount Utilization: Tracks how often discounts are applied to orders */
SELECT d.discount_name, COUNT(o.order_id) AS discount_usage
FROM Orders o
JOIN Discounts d ON o.discount_id= d.discount_id
GROUP BY d.discount_name;
/* 21. Products low on stock: shows which products are low on stock, meaning there is a quantity of less than 10 on hand */
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
