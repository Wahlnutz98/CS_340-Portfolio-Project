-- DML.SQL: Data Manipulation Queries for RoboRetail (Group1)
-- Kevin Sun, Hossain Nahid, Jacob Wahl
-- Data manipultation queries that include SELECT queries used by the web app plus sample CUD operations.
-- 

-- SELECTs for all entities (use these in server-side code to populate pages)
-- Customers
SELECT customerID, firstName, lastName, email, phoneNumber, address, isActive
FROM Customers
ORDER BY lastName, firstName;

-- Products
SELECT productID, productName, category, price, quantityInStock
FROM Products
ORDER BY productName;

-- Suppliers
SELECT supplierID, supplierName, contactEmail, phoneNumber, supplierAddress, isActive
FROM Suppliers
ORDER BY supplierName;

-- ProductSuppliers (with joins)
SELECT ps.productSupplierID, p.productName, s.supplierName, ps.cost
FROM ProductSuppliers ps
JOIN Products p ON ps.productID = p.productID
JOIN Suppliers s ON ps.supplierID = s.supplierID
ORDER BY p.productName, s.supplierName;

-- Orders (with customer info)
SELECT o.orderID, o.orderDate, o.customerID, c.firstName, c.lastName, c.email
FROM Orders o
JOIN Customers c ON o.customerID = c.customerID
ORDER BY o.orderDate DESC;

-- OrderDetails (with product and order info)
SELECT od.orderDetailID, od.orderID, od.productID, p.productName, od.quantity, od.lineTotal
FROM OrderDetails od
JOIN Products p ON od.productID = p.productID
ORDER BY od.orderID, p.productName;

-- Sample DML operations (for reference / additional server actions)
-- INSERT example
INSERT INTO Customers (firstName, lastName, email, phoneNumber, address)
VALUES ('Sam', 'Tester', 'sam.tester@example.com', '999-888-7777', '100 Test Blvd');

-- UPDATE example
UPDATE Products SET quantityInStock = quantityInStock - 1 WHERE productID = 1;

-- DELETE example (this is the demo CUD used to verify RESET works)
-- This is a simple hard-coded delete; we also provide a stored procedure in PL.SQL
DELETE FROM Customers WHERE firstName = 'John' AND lastName = 'Doe';

-- End of DML.SQL
