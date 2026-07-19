-- Set Up the Database; this includes setting foreign key checks and creating the database
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;

Drop Database if exists inventory_management_db;
CREATE DATABASE inventory_management_db;
USE inventory_management_db;

/* Create the Entities in the database, add columns, determine primary keys/foreign keys and database design */

DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(100),
    price DECIMAL(10, 2),
    stock_quantity INT
);

DROP TABLE IF EXISTS Suppliers;
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    phone_number VARCHAR(15)
);

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


DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
	customer_name VARCHAR(100) NOT NULL,
	customer_email VARCHAR(100),
	phone_number VARCHAR(15)
);

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

DROP TABLE IF EXISTS Shipments;
CREATE TABLE Shipments(
	shipment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
	shipment_date DATE,
	tracking_number VARCHAR(100),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS Warranties;
CREATE TABLE Warranties (
	warranty_id INT PRIMARY KEY AUTO_INCREMENT,
	sale_id INT,
    product_id INT,
	warranty_start_date DATE,
    warranty_end_date DATE,
    FOREIGN KEY (sale_id) REFERENCES Sales(sale_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
    );

DROP TABLE IF EXISTS Payment_Methods;
CREATE TABLE Payment_Methods(
	payment_method_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_id INT,
	payment_type VARCHAR(100) NOT NULL,
    payment_date DATE,
    card_last_four_digits INT,
    FOREIGN KEY (sale_id) REFERENCES Sales(sale_id) ON DELETE CASCADE
    );

DROP TABLE IF EXISTS Returns;
CREATE TABLE Returns (
	return_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_id INT,
    product_id INT,
	return_date DATE,
    return_reason VARCHAR(100),
    FOREIGN KEY (sale_id) REFERENCES Sales(sale_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
    );

DROP TABLE IF EXISTS Invoices;
CREATE TABLE Invoices (
	invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_id INT NOT NULL,
	invoice_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (sale_id) REFERENCES Sales(sale_id) ON DELETE CASCADE
    );

DROP TABLE IF EXISTS Discounts;
CREATE TABLE Discounts(
	discount_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
	discount_percentage DECIMAL(5,2),
    discount_start_date DATE,
    discount_end_date DATE, 
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
    );



SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;
