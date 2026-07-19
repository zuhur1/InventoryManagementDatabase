# Inventory Management Database

## Overview

This Inventory Management Database is a relational SQL database designed to simulate a real-world inventory management system. It tracks inventory operations from supplier orders to customer sales while providing meaningful business insights through analytical SQL queries.

The database includes entities for products, suppliers, customers, orders, shipments, sales, warranties, returns, invoices, payment methods, and discounts. It demonstrates database design, normalization, foreign key relationships, SQL queries, views, and triggers.

---

## Database Structure

The database consists of **10 interconnected tables**:

- Products
- Suppliers
- Customers
- Orders
- Shipments
- Sales
- Warranties
- Payment_Methods
- Returns
- Invoices
- Discounts

See the included **Entity Relationship Diagram (ERD)** for the complete database structure.

---

## Repository Contents


ERDIMB: Entity Relationship Diagram (ERD) illustrating table relationships
TablesIMD.sql: Creates the database schema, including tables, primary keys, foreign keys, and relationships. 
TableDataIMD.sql: Populates the database with sample data. 
Queries_Triggers.sql: Contains analytical SQL queries, a view, and a trigger. 

---

## Features

- Relational database design
- Primary and foreign key constraints
- Normalized table structure
- Business-focused SQL queries
- SQL View for inventory monitoring
- SQL Trigger for automatic stock updates
- Inventory and sales analytics

---

## Key Business Insights (KPIs)

### Sales Performance
- Total sales by customer
- Quantity sold by product
- Products sold with warranties
- Sales linked to invoices and discounts

### Inventory Health
- Low-stock product monitoring
- Automatic inventory updates after each sale using a trigger

### Customer Insights
- Payment method preferences
- Customer purchase history
- Customers purchasing multiple items

### Supplier & Shipment Management
- Order fulfillment time
- Shipments within a specified date range
- Shipments without tracking numbers
- Supplier shipment tracking

### Returns & Warranty Analysis
- Product return counts
- Return reasons
- Warranty information associated with sales

---

## Technologies Used

- MySQL
- SQL
- Relational Database Design
- Views
- Triggers
- Joins
- Aggregate Functions
- Foreign Key Constraints

---

## Learning Objectives

This project demonstrates:

- Database schema design
- Entity relationship modeling
- SQL data manipulation
- Complex JOIN operations
- Aggregate reporting
- Business intelligence queries
- Data integrity using constraints
- Database automation with triggers

