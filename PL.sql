-- RoboRetail PL/SQL for group 1:
-- Hosain Nahid, Kevin Sun, Jacob Wahl
--
-- Code Citations: ChatpGPT
-- Date: 5/27/26 - 06/01/26
-- Prompt summary to generate all CUD SP's in the file.
-- Write a stored procedure called sp_[CUD]_[TABLE_NAME] using the attached schema. This SP should handle [CUD OPERATION] in the table and ensure the table is properly updated.
-- Write a test query I can use to ensure the SP is working as intended. Make no mistakes.
-- All AI interaction and usage was verified and iterated by at least one or all team members to ensure the SP is working as intended.

-- Customer Table:
-- Add
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_add_customer$$
CREATE PROCEDURE sp_add_customer(
    IN p_firstName VARCHAR(50),
    IN p_lastName VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_phoneNumber VARCHAR(20),
    IN p_address VARCHAR(200),
    IN p_isActive BOOLEAN
)
BEGIN
    -- Insert customer into Customers
    INSERT INTO Customers (
        firstName, lastName, email, phoneNumber, address, isActive
    )
    VALUES (
        p_firstName, p_lastName, p_email, p_phoneNumber, p_address, p_isActive
        );
END$$
DELIMITER ;

-- Update:
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_update_customer$$
CREATE PROCEDURE sp_update_customer(
    IN p_customerID INT,
    IN p_firstName VARCHAR(50),
    IN p_lastName VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_phoneNumber VARCHAR(20),
    IN p_address VARCHAR(200),
    IN p_isActive BOOLEAN
)
BEGIN
    IF EXISTS ( -- Only allows existing customers to be updated.
        SELECT 1
        FROM Customers
        WHERE customerID = p_customerID
    ) THEN

        UPDATE Customers
        SET
            firstName = p_firstName,
            lastName = p_lastName,
            email = p_email,
            phoneNumber = p_phoneNumber,
            address = p_address,
            isActive = p_isActive
        WHERE customerID = p_customerID;

    END IF;
END$$
DELIMITER ;

-- Delete
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_delete_customer$$
CREATE PROCEDURE sp_delete_customer(
    IN p_customerID INT
)
BEGIN
    -- Delete customer from Customers
    DELETE FROM Customers
    WHERE customerID = p_customerID;
    COMMIT;
END$$
DELIMITER ;

-- Products Table:
-- Add:
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_add_product$$
CREATE PROCEDURE sp_add_product(
    IN p_productName VARCHAR(100),
    IN p_category VARCHAR(50),
    IN p_price DECIMAL(10,2),
    IN p_quantityInStock INT
)
BEGIN
    -- Insert product into Products
    INSERT INTO Products (
        productName,
        category,
        price,
        quantityInStock
    )
    VALUES (
        p_productName,
        p_category,
        p_price,
        p_quantityInStock
    );
END$$
DELIMITER ;

-- Update:
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_update_product$$
CREATE PROCEDURE sp_update_product(
    IN p_productID INT,
    IN p_productName VARCHAR(100),
    IN p_category VARCHAR(50),
    IN p_price DECIMAL(10,2),
    IN p_quantityInStock INT
)
BEGIN
    -- Update product information
    UPDATE Products
    SET
        productName = p_productName,
        category = p_category,
        price = p_price,
        quantityInStock = p_quantityInStock
    WHERE productID = p_productID;
END$$
DELIMITER ;


-- Delete Product
DROP PROCEDURE IF EXISTS sp_delete_product;
DELIMITER $$
CREATE PROCEDURE sp_delete_product(
    IN p_productID INT
)
BEGIN
    -- Delete product from Products table
    DELETE FROM Products
    WHERE productID = p_productID;
    COMMIT;
END$$

DELIMITER ;

-- Orders Table:
-- Insert Order
DROP PROCEDURE IF EXISTS sp_add_order;
DELIMITER $$
CREATE PROCEDURE sp_add_order(
    IN p_customerID INT,
    IN p_orderDate DATETIME
)
BEGIN
    -- Insert order into Orders
    INSERT INTO Orders (customerID, orderDate)
    VALUES (p_customerID, p_orderDate);
END$$
DELIMITER ;

-- Update Order:
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_update_order$$
CREATE PROCEDURE sp_update_order(
    IN p_orderID INT,
    IN p_customerID INT,
    IN p_orderDate DATETIME
)
BEGIN
    -- Update order information in Orders
    UPDATE Orders
    SET
        customerID = p_customerID,
        orderDate = p_orderDate
    WHERE orderID = p_orderID;
END$$
DELIMITER ;

-- Delete Order:
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_delete_order$$
CREATE PROCEDURE sp_delete_order(IN p_order_id INT)
BEGIN
    -- Delete the order using the provided parameter
    DELETE FROM Orders 
    WHERE orderID = p_order_id;
 
    -- Commit the change to make it permanent
    COMMIT;
END$$
DELIMITER ;

-- Suppliers
-- Add
DROP PROCEDURE IF EXISTS sp_add_supplier;
DELIMITER $$
CREATE PROCEDURE sp_add_supplier(
    IN p_supplierName VARCHAR(100),
    IN p_contactEmail VARCHAR(100),
    IN p_phoneNumber VARCHAR(20),
    IN p_supplierAddress VARCHAR(200)
)
BEGIN
    INSERT INTO Suppliers (
        supplierName,
        contactEmail,
        phoneNumber,
        supplierAddress
    )
    VALUES (
        p_supplierName,
        p_contactEmail,
        p_phoneNumber,
        p_supplierAddress
    );
    COMMIT;
END$$
DELIMITER ;

-- Update
DROP PROCEDURE IF EXISTS sp_update_supplier;
DELIMITER $$
CREATE PROCEDURE sp_update_supplier(
    IN p_supplierID INT,
    IN p_supplierName VARCHAR(100),
    IN p_contactEmail VARCHAR(100),
    IN p_phoneNumber VARCHAR(20),
    IN p_supplierAddress VARCHAR(200),
    IN p_isActive BOOLEAN
)
BEGIN
    UPDATE Suppliers
    SET
        supplierName = p_supplierName,
        contactEmail = p_contactEmail,
        phoneNumber = p_phoneNumber,
        supplierAddress = p_supplierAddress,
        isActive = p_isActive
    WHERE supplierID = p_supplierID;
    COMMIT;
END$$
DELIMITER ;

-- Delete
DROP PROCEDURE IF EXISTS sp_delete_supplier;
DELIMITER $$
CREATE PROCEDURE sp_delete_supplier(
    IN p_supplierID INT
)
BEGIN
    -- Delete supplier from Suppliers table
    DELETE FROM Suppliers
    WHERE supplierID = p_supplierID;
    COMMIT;
END$$
DELIMITER ;

-- ProductSupliers
-- Add
DROP PROCEDURE IF EXISTS sp_add_product_supplier;
DELIMITER $$
CREATE PROCEDURE sp_add_product_supplier(
    IN p_productID INT,
    IN p_supplierID INT,
    IN p_cost DECIMAL(10,2)
)
BEGIN
    INSERT INTO ProductSuppliers (
        productID,
        supplierID,
        cost
    )
    VALUES (
        p_productID,
        p_supplierID,
        p_cost
    );
    COMMIT;
END$$
DELIMITER ;

-- Update
DROP PROCEDURE IF EXISTS sp_update_product_supplier;
DELIMITER $$
CREATE PROCEDURE sp_update_product_supplier(
    IN p_productSupplierID INT,
    IN p_productID INT,
    IN p_supplierID INT,
    IN p_cost DECIMAL(10,2)
)
BEGIN
    UPDATE ProductSuppliers
    SET
        productID = p_productID,
        supplierID = p_supplierID,
        cost = p_cost
    WHERE productSupplierID = p_productSupplierID;
    COMMIT;
END$$

DELIMITER ;

-- Delete
DROP PROCEDURE IF EXISTS sp_delete_product_supplier;
DELIMITER $$
CREATE PROCEDURE sp_delete_product_supplier(
    IN p_productSupplierID INT
)
BEGIN
    -- Deletes the product supplier given the ID
    DELETE FROM ProductSuppliers
    WHERE productSupplierID = p_productSupplierID;

    COMMIT;
END$$
DELIMITER ;