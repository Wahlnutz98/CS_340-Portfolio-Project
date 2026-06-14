-- DDL.SQL: RoboRetail schema reset procedure
-- This file defines a stored procedure `sp_reset_robo_retail` that drops and recreates the schema
-- and inserts the sample data. Call it with `CALL sp_reset_robo_retail();` to reset the database.
-- Our database resides in MySQL

-- Code Citation: GitHub Copilot
-- Date: 05/26/26
-- Prompt: Subqueries for Orders, OrderDetails, and ProductSuppliers FK insertions with CASCADE/RESTRICT constraints


DROP PROCEDURE IF EXISTS sp_reset_robo_retail;
DELIMITER $$
CREATE PROCEDURE sp_reset_robo_retail()
BEGIN
    SET FOREIGN_KEY_CHECKS=0;

    DROP TABLE IF EXISTS ProductSuppliers;
    DROP TABLE IF EXISTS OrderDetails;
    DROP TABLE IF EXISTS Orders;
    DROP TABLE IF EXISTS Products;
    DROP TABLE IF EXISTS Suppliers;
    DROP TABLE IF EXISTS Customers;

    -- Customers Table
    CREATE TABLE Customers (
        customerID INT AUTO_INCREMENT PRIMARY KEY,
        firstName VARCHAR(50) NOT NULL,
        lastName VARCHAR(50) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        phoneNumber VARCHAR(20),
        address VARCHAR(200),
        isActive BOOLEAN DEFAULT TRUE
    );

    -- Products Table
    CREATE TABLE Products (
        productID INT AUTO_INCREMENT PRIMARY KEY,
        productName VARCHAR(100) NOT NULL,
        category VARCHAR(50) NOT NULL,
        price DECIMAL(10,2) NOT NULL,
        quantityInStock INT NOT NULL
    );

    -- Orders Table
    CREATE TABLE Orders (
        orderID INT AUTO_INCREMENT PRIMARY KEY,
        customerID INT NOT NULL,
        orderDate DATETIME NOT NULL,
        FOREIGN KEY (customerID)
            REFERENCES Customers(customerID)
            ON DELETE CASCADE
            ON UPDATE CASCADE
    );

    -- OrderDetails Table
    CREATE TABLE OrderDetails (
        orderDetailID INT AUTO_INCREMENT PRIMARY KEY,
        orderID INT NOT NULL,
        productID INT NOT NULL,
        quantity INT NOT NULL,
        lineTotal DECIMAL(10,2) NOT NULL,
        FOREIGN KEY (orderID)
            REFERENCES Orders(orderID)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
        FOREIGN KEY (productID)
            REFERENCES Products(productID)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
        UNIQUE (orderID, productID)
    );

    -- Suppliers Table
    CREATE TABLE Suppliers (
        supplierID INT AUTO_INCREMENT PRIMARY KEY,
        supplierName VARCHAR(100) NOT NULL,
        contactEmail VARCHAR(100),
        phoneNumber VARCHAR(20),
        supplierAddress VARCHAR(200) NOT NULL,
        isActive BOOLEAN DEFAULT TRUE
    );

    -- ProductSuppliers Table
    CREATE TABLE ProductSuppliers (
        productSupplierID INT AUTO_INCREMENT PRIMARY KEY,
        productID INT NOT NULL,
        supplierID INT NOT NULL,
        cost DECIMAL(10,2) NOT NULL,
        FOREIGN KEY (productID)
            REFERENCES Products(productID)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
        FOREIGN KEY (supplierID)
            REFERENCES Suppliers(supplierID)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
        UNIQUE (productID, supplierID)
    );

    -- Sample Data Inserts

    -- Customers
    INSERT INTO Customers (firstName, lastName, email, phoneNumber, address) VALUES
    ('John', 'Doe', 'john@email.com', '123-456-7890', '123 Main St'),
    ('Jane', 'Smith', 'jane@email.com', '234-567-8901', '456 Oak St'),
    ('Alex', 'Lee', 'alex@email.com', NULL, '789 Pine St'),
    ('Cardinal', 'Ericsson', 'cardinal@email.com', '708-739-9294', '2387 Agriculture Lane'),
    ('Curtis', 'Taylor', 'curtis@email.com', '317-223-6447', '3026 Henery Street');

    -- Products
    INSERT INTO Products (productName, category, price, quantityInStock) VALUES
    ('Laptop', 'Electronics', 999.99, 10),
    ('Headphones', 'Electronics', 199.99, 25),
    ('Desk Chair', 'Furniture', 150.00, 8),
    ('Smartphone','Electronics',899.99,15),
    ('Pillow','Bedding',19.66,5);

    -- Orders -- Added subqueries for FK insertion.
    INSERT INTO Orders (customerID, orderDate) VALUES
    ((SELECT customerID FROM Customers WHERE email = 'john@email.com'), '2026-04-01 10:00:00'),
    ((SELECT customerID FROM Customers WHERE email = 'jane@email.com'), '2026-04-02 12:30:00'),
    ((SELECT customerID FROM Customers WHERE email = 'alex@email.com'), '2026-04-03 09:15:00'),
    ((SELECT customerID FROM Customers WHERE email = 'cardinal@email.com'),'2026-04-04 08:30:00'),
    ((SELECT customerID FROM Customers WHERE email = 'curtis@email.com'),'2026-04-12 18:35:00');

    -- OrderDetails
    INSERT INTO OrderDetails (orderID, productID, quantity, lineTotal) VALUES
    ((SELECT orderID FROM Orders WHERE customerID = (SELECT customerID FROM Customers WHERE email = 'john@email.com') LIMIT 1), (SELECT productID FROM Products WHERE productName = 'Laptop'), 1, 999.99),
    ((SELECT orderID FROM Orders WHERE customerID = (SELECT customerID FROM Customers WHERE email = 'john@email.com') LIMIT 1), (SELECT productID FROM Products WHERE productName = 'Headphones'), 2, 399.98),
    ((SELECT orderID FROM Orders WHERE customerID = (SELECT customerID FROM Customers WHERE email = 'jane@email.com') LIMIT 1), (SELECT productID FROM Products WHERE productName = 'Desk Chair'), 1, 150.00),
    ((SELECT orderID FROM Orders WHERE customerID = (SELECT customerID FROM Customers WHERE email = 'alex@email.com') LIMIT 1), (SELECT productID FROM Products WHERE productName = 'Pillow'), 2, 39.32),
    ((SELECT orderID FROM Orders WHERE customerID = (SELECT customerID FROM Customers WHERE email = 'cardinal@email.com') LIMIT 1), (SELECT productID FROM Products WHERE productName = 'Smartphone'), 1, 899.99);

    -- Suppliers
    INSERT INTO Suppliers (supplierName, contactEmail, phoneNumber, supplierAddress) VALUES
    ('TechCorp', 'tech@corp.com', '111-222-3333', '12 Tech Ave'),
    ('FurniCo', 'contact@furni.com', '444-555-6666', '45 Wood St'),
    ('Sleep City','support@sleep-city.com','127-893-5582','750 Gerald Ave');

    -- ProductSuppliers
    INSERT INTO ProductSuppliers (productID, supplierID, cost) VALUES
    ((SELECT productID FROM Products WHERE productName = 'Laptop'), (SELECT supplierID FROM Suppliers WHERE supplierName = 'TechCorp'), 700.00),
    ((SELECT productID FROM Products WHERE productName = 'Headphones'), (SELECT supplierID FROM Suppliers WHERE supplierName = 'TechCorp'), 120.00),
    ((SELECT productID FROM Products WHERE productName = 'Desk Chair'), (SELECT supplierID FROM Suppliers WHERE supplierName = 'FurniCo'), 90.00),
    ((SELECT productID FROM Products WHERE productName = 'Smartphone'), (SELECT supplierID FROM Suppliers WHERE supplierName = 'TechCorp'), 690.00),
    ((SELECT productID FROM Products WHERE productName = 'Pillow'), (SELECT supplierID FROM Suppliers WHERE supplierName = 'Sleep City'), 10.33);

    SET FOREIGN_KEY_CHECKS=1;
END$$
DELIMITER ;

-- Usage:
-- 1) Run this file to create the procedure.
-- 2) Execute `CALL sp_reset_robo_retail();` to drop, recreate, and populate the schema.
-- Note: If your environment (phpMyAdmin) does not allow DDL inside procedures, extract the CREATE TABLE/INSERT blocks and run them directly.
