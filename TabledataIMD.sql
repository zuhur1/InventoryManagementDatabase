-- Set Up the Database; this includes setting foreign key checks and creating the database
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;
USE inventory_management_db;

INSERT INTO Products (product_name, category, price, stock_quantity) VALUES
	('Laptop', 'Electronics', 800.00, 50),
	('Desk Chair', 'Furniture', 120.00, 100),
	('Office Desk', 'Furniture', 250.00, 30);

INSERT INTO Suppliers (supplier_name, contact_name, phone_number) VALUES
	('Tech Supplies Ltd.', 'John Smith', '555-1234'),
	('Furniture Depot', 'Alice Brown', '555-5678');
    
INSERT INTO Orders (product_id, supplier_id, order_date, quantity_ordered) VALUES	
	(1, 1, '2024-09-01', 20),
	(2, 2, '2024-09-02', 50),
	(3, 2, '2024-09-03', 10);
    
INSERT INTO Customers (customer_name, customer_email, phone_number) VALUES
	('Alice Green', 'alice@example.com', '555-1234'),
	('Bob White', 'bob@example.com', '555-5678'),
	('Charlie Black', 'charlie@example.com', '555-9012');

INSERT INTO Sales (customer_id, product_id, sale_date, quantity_sold) VALUES
	(1, 1, '2024-09-05', 2),
	(1, 2, '2024-09-06', 1),
	(2, 1, '2024-09-07', 3),
	(3, 3, '2024-09-08', 5);

INSERT INTO Shipments (order_id, shipment_date, tracking_number) VALUES
	(1, '2024-09-09', 'TRACK12345'),
	(2, '2024-09-10', 'TRACK67890'),
	(3, '2024-09-11', 'TRACK09876');
    
INSERT INTO Warranties (sale_id, product_id, warranty_start_date, warranty_end_date) VALUES
	(1, 1, '2024-09-06', '2025-09-06'),
	(2, 2, '2024-09-07', '2025-09-07'),
	(3, 3, '2024-09-08', '2026-09-08');
    
INSERT INTO Payment_Methods (sale_id, payment_type, payment_date, card_last_four_digits) VALUES
	(1, 'Credit Card', '2024-09-05', '1234'),
	(2, 'PayPal', '2024-09-06', NULL),
	(3, 'Debit Card', '2024-09-07', '5678');

INSERT INTO Returns(sale_id, product_id, return_date, return_reason) VALUES
	(1, 1, '2024-09-10', 'Defective product'),
	(2, 2, '2024-09-11', 'Wrong item delivered'),
	(3, 3, '2024-09-12', 'Changed mind');
    
INSERT INTO Invoices (sale_id, invoice_date, total_amount) VALUES
	(1, '2024-09-05', 999.99),
	(2, '2024-09-06', 499.99),
	(3, '2024-09-07', 799.99);
    
INSERT INTO Discounts (product_id, discount_percentage, discount_start_date, discount_end_date) VALUES
	(1, 10.00, '2024-09-01', '2024-09-10'),
	(2, 15.00, '2024-09-05', '2024-09-15'),
	(3, 5.00, '2024-09-10', '2024-09-20');
    
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;