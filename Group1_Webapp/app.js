// Code Citation for the following File: app.js
// Date: 05/20/26 - 06/07/26
// AI tools: ChatGPT / Claude
// prompt Summary: AI was used to help generate code and debug issues in the app.js file to ensure proper handling of route parameters and dynamically populate tables.
// All AI generated code was verified and tested by all team members to ensure accuracy and match our database design.
// Code in this file was also based on the teachings of Activity 2 taught by Dr. Curry in CS340 at Oregon State Univiserity.
// Source URL: https://canvas.oregonstate.edu/courses/2042369/assignments/10464646?module_item_id=26640125 

const express = require('express');
const app = express();
const db = require('./db-connector');

const PORT = 53870;

app.set('view engine', 'ejs');  
app.use(express.static(__dirname));

app.use(express.urlencoded({ extended: true }));

// Dynamically populate products page
app.get('/products.html', async function (req, res) {
    const [rows] = await db.query('SELECT productID, productName, category, price, \
        quantityInStock FROM Products');

    res.render('products', {
        Products: rows
    });

});

// Dynamically populate productSuppliers page
app.get('/productsuppliers.html', async function (req, res) {
    const [rows] = await db.query('SELECT ps.productSupplierID, ps.productID, p.productName, \
        ps.supplierID, s.supplierName, ps.cost FROM Products p JOIN ProductSuppliers ps \
        ON p.productID = ps.productID JOIN Suppliers s ON ps.supplierID = s.supplierID \
        ORDER BY ps.productSupplierID;');
    
    res.render('productSuppliers', {
        ProductSuppliers: rows
    });

});

// Dynamically populate orders page
app.get('/orders.html', async function (req, res) {
    const [rows] = await db.query(
        'SELECT orderID, o.customerID, orderDate, c.firstName, c.lastName FROM Orders o JOIN \
        Customers c on o.customerID = c.customerID'
    );

    res.render('orders', {
        Orders: rows
    });
});

// Dynamically populate customers page
app.get('/customers.html', async function (req, res) {
    const [rows] = await db.query('SELECT customerID, firstName, lastName, email, phoneNumber, \
         address FROM Customers');

    res.render('customers', {
        Customers: rows
    });

});

// Dynamically populate orderDetails page
app.get('/orderdetails.html', async function (req, res) {
    const [rows] = await db.query('SELECT orderDetailID, orderID, od.productID, quantity, \
        lineTotal, p.productName \
        FROM OrderDetails od JOIN Products p ON od.productID = p.productID');
    res.render('orderDetails', { OrderDetails: rows });
});

// Dynamically populate suppliers page
app.get('/suppliers.html', async function (req, res) {
    const [rows] = await db.query('SELECT supplierID, supplierName, contactEmail, phoneNumber, \
        supplierAddress FROM Suppliers');

    res.render('suppliers', {
        Suppliers: rows
    });
});

// app.post route for deleting an Order - uses a stored procedure and the DML queries \ 
// written in Step 3 to implement the CRUD function.
app.post('/delete-order', async (req, res) => {
    const deleteOrderID = req.body.orderToDeleteID.split(" ")[0]; // Extracting the ID from the POST request

    if (!deleteOrderID) {
        return res.status(400).json({ error: 'Order ID is required' });
    }

    try {
        // Call the MySQL Stored Procedure
        const [result] = await db.query('CALL sp_delete_order(?)', [deleteOrderID]);

        if (result.affectedRows === 0) {
            return res.redirect('/orders.html'); //order not deleted successfully 
        }

        res.redirect('/orders.html'); //order deleted successfully 
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// app.post route for deleting a Customer
app.post('/delete-customer', async (req, res) => {
    const deleteCustomerID = req.body.customerID.split(" ")[0]; // Extracting the ID from the POST request

    if (!deleteCustomerID) {
        return res.status(400).json({ error: 'Customer ID is required' });
    }

    try {
        // Call the MySQL Stored Procedure
        const [result] = await db.query('CALL sp_delete_customer(?)', [deleteCustomerID]);

        if (result.affectedRows === 0) {
            return res.redirect('/customers.html'); //customer not deleted successfully 
        }

        res.redirect('/customers.html'); //customer deleted successfully 
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// app.post route for deleting a Product
app.post('/delete-product', async (req, res) => {
    const deleteProductID = req.body.productToDeleteID.split(" ")[0]; // Extracting the ID from the POST request

    if (!deleteProductID) {
        return res.status(400).json({ error: 'need to select a product to delete' });
    }

    try {
        // Call the MySQL Stored Procedure
        const [result] = await db.query('CALL sp_delete_product(?)', [deleteProductID]);

        if (result.affectedRows === 0) {
            return res.redirect('/products.html'); //product not deleted successfully 
        }

        res.redirect('/products.html'); //product deleted successfully 
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// app.post route for deleting a Supplier
app.post('/delete-supplier', async (req, res) => {
    const deleteSupplierID = req.body.supplierToDeleteID; // Extracting the ID from the POST request

    if (!deleteSupplierID) {
        return res.status(400).json({ error: 'need to select a supplier to delete' });
    }

    try {
        // Call the MySQL Stored Procedure
        const [result] = await db.query('CALL sp_delete_supplier(?)', [deleteSupplierID]);

        if (result.affectedRows === 0) {
            return res.redirect('/suppliers.html'); //supplier not deleted successfully 
        }

        res.redirect('/suppliers.html'); //supplier deleted successfully 
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// app.post route for deleting a product Supplier.
app.post('/delete-product-supplier', async (req, res) => {
    const productSupplierID = req.body.deleteProductSupplierID.split(" ")[0]; // Extracting the ID from the POST request

    const productSupplierIDOnlyDigits = productSupplierID.split(" ")[0]; 

    if (!productSupplierIDOnlyDigits) {
        return res.status(400).json({ error: 'Product Supplier ID is required' });
    }

    try {
        // Call the MySQL Stored Procedure
        const [result] = await db.query('CALL sp_delete_product_supplier(?)',
             [productSupplierIDOnlyDigits]);

        if (result.affectedRows === 0) {
            return res.redirect('/productsuppliers.html'); //product-supplier not deleted successfully 
        }

        res.redirect('/productsuppliers.html'); //product-supplier deleted successfully 
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// app.post route for adding a customer.
app.post('/add-customer', async (req, res) => {
    const customerFirstName = req.body.customerFirstName; 
    const customerLastName = req.body.customerLastName;
    const customerEmail = req.body.customerEmail;
    const customerPhone = req.body.customerPhone;
    const customerAddress = req.body.customerAddress;

    if (!customerFirstName || !customerLastName || !customerEmail || !customerPhone || !customerAddress) {
        return res.status(400).json({ error: 'One or missing pcs of info for Add Customer' });
    }

    try {
        // Call the MySQL Stored Procedure
        const [result] = await db.query('CALL sp_add_customer(?, ?, ?, ?, ?, ?)',
            [customerFirstName, customerLastName, customerEmail, customerPhone, customerAddress, 1]);

        if (result.affectedRows === 0) {
            res.redirect('/customers.html'); //customer not added successfully 
        }

        res.redirect('/customers.html'); //customer added successfully 
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// app.post route for adding an order.
app.post('/add-order', async (req, res) => {
    const customerIDFromOrders = req.body.customerIDFromOrders.split(" ")[0];
    const orderDate = req.body.orderDate; 
    
    if (!customerIDFromOrders || !orderDate) {
        return res.status(400).json({ error: 'One or missing pcs of info for Add Order' });
    }

    try {
        // Call the MySQL Stored Procedure
        const [result] = await db.query('CALL sp_add_order(?, ?)',
            [customerIDFromOrders, orderDate]);

        if (result.affectedRows === 0) {
            return res.redirect('/orders.html'); //order not added successfully 
        }

        res.redirect('/orders.html'); //order added successfully 
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// app.post route for adding a product.
app.post('/add-product', async (req, res) => {
    const productName = req.body.productName;
    const productCategory = req.body.productCategory;
    const productPrice = req.body.productPrice;
    const quantityInStock = req.body.quantityInStock;
    
    if (!productName || !productCategory || !productPrice || !quantityInStock) {
        return res.status(400).json({ error: 'One or missing pcs of info for Add Product' });
    }

    try {
        // Call the MySQL Stored Procedure
        const [result] = await db.query('CALL sp_add_product(?, ?, ?, ?)',
            [productName, productCategory, productPrice, quantityInStock]);

        if (result.affectedRows === 0) {
            return res.redirect('/products.html'); //product not added successfully 
        }

        res.redirect('/products.html'); //product added successfully 
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// app.post route for adding a productSupplier.
app.post('/add-product-supplier', async (req, res) => {
    const productID = req.body.productID.split(" ")[0];
    const supplierID = req.body.supplierID.split(" ")[0];
    const cost = req.body.cost;

    if (!productID || !supplierID || !cost) {
        return res.status(400).json({ error: 'One or missing pcs of info for Add Product Supplier' });
    }

    try {
        // Call the MySQL Stored Procedure
        console.log(productID, supplierID, cost);
        const [result] = await db.query('CALL sp_add_product_supplier(?, ?, ?)',
            [productID, supplierID, cost]);

        if (result.affectedRows === 0) {
            return res.redirect('/productsuppliers.html'); //product-supplier not added successfully 
        }

        res.redirect('/productsuppliers.html'); //product-supplier added successfully 
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// app.post route for adding a supplier.
app.post('/add-supplier', async (req, res) => {
    const supplierName = req.body.supplierName;
    const supplierEmail = req.body.supplierEmail;
    const supplierPhone = req.body.supplierPhone;
    const supplierAddress = req.body.supplierAddress;
    
    if (!supplierName || !supplierEmail || !supplierPhone || !supplierAddress) {
        return res.status(400).json({ error: 'One or missing pcs of info for Add Supplier' });
    }

    try {
        // Call the MySQL Stored Procedure
        const [result] = await db.query('CALL sp_add_supplier(?, ?, ?, ?)',
            [supplierName, supplierEmail, supplierPhone, supplierAddress]);

        if (result.affectedRows === 0) {
            return res.redirect('/suppliers.html'); //supplier not added successfully 
        }

        res.redirect('/suppliers.html'); //supplier added successfully 
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// app.post route for updating a customer.
app.post('/update-customer', async (req, res) => {
    const updatedEmail = req.body.customerUpdatedEmail;
    const updatedPhone = req.body.customerUpdatedPhone;
    const updatedAddress = req.body.customerUpdatedAddress;
    const customerToUpdateID = req.body.customerToUpdateID.split(" ")[0];

    const [customerRows] = await db.query('SELECT firstName, lastName FROM Customers WHERE customerID = ?',
        [customerToUpdateID]
    );

    if (customerRows.length === 0) {
        return res.status(404).json({ error: 'Customer not found' });
    }
    else if (!updatedEmail || !updatedPhone || !updatedAddress || !customerToUpdateID) {
        return res.status(400).json({ error: 'One or more missing pcs of info for Update Customer' });
    }

    const { firstName, lastName } = customerRows[0];

    try {
        // Call the MySQL Stored Procedure
        const [result] = await db.query(
          'CALL sp_update_customer(?, ?, ?, ?, ?, ?, ?)',
                [customerToUpdateID, firstName, lastName, updatedEmail, updatedPhone, updatedAddress, 1]
        );

        if (result.affectedRows === 0) {
            return res.redirect('/customers.html'); //customer not updated successfully 
        }

        res.redirect('/customers.html'); //customer updated successfully 
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// app.post route for updating an order.
app.post('/update-order', async (req, res) => {
    const orderToUpdateID = req.body.orderToUpdateID.split(" ")[0];
    const orderDate = req.body.orderUpdatedDate; 

    if (!orderToUpdateID || !orderDate) {
        return res.status(400).json({ error: 'One or more missing pcs of info for Update Order' });
    }

    try {
        // Call the MySQL Stored Procedure
        const [result] = await db.query(
          'CALL sp_update_order(?, ?)',
                [orderToUpdateID, orderDate]
        );

        if (result.affectedRows === 0) {
            return res.redirect('/orders.html'); //order not updated successfully 
        }

        res.redirect('/orders.html'); //order updated successfully 
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// app.post route for updating a product.
app.post('/update-product', async (req, res) => {
    const productToUpdateID = req.body.productToUpdateID.split(" ")[0];//extract just the ID
    const updatedProductName = req.body.updatedProductName; 
    const updatedProductCategory = req.body.updatedProductCategory;
    const updatedProductPrice = req.body.updatedProductPrice;
    const updatedProductQty = req.body.updatedProductQty;

    if (!productToUpdateID) {
        return res.status(400).json({ error: 'One or more missing pcs of info for Update Order' });
    }

    if (!updatedProductName || !updatedProductCategory || !updatedProductPrice || !updatedProductQty) {
        return res.status(400).json({ error: 'One or more missing pcs of info for Update Order' });
    }

    try {
        // Call the MySQL Stored Procedure
        const [result] = await db.query(
          'CALL sp_update_product(?, ?, ?, ?, ?)',
                [productToUpdateID, updatedProductName, updatedProductCategory, updatedProductPrice,
                    updatedProductQty
                ]
        );

        if (result.affectedRows === 0) {
            return res.redirect('/products.html'); //product not updated successfully 
        }

        res.redirect('/products.html'); //product updated successfully 
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// app.post route for updating a supplier.
app.post('/update-supplier', async (req, res) => {
    const supplierToUpdateID = req.body.supplierToUpdateID;
    const updatedSupplierName = req.body.updatedSupplierName; 
    const updatedSupplierEmail = req.body.updatedSupplierEmail; 
    const updatedSupplierPhone = req.body.updatedSupplierPhone;
    const updatedSupplierAddress = req.body.updatedSupplierAddress;
    
    if (!supplierToUpdateID) {
        return res.status(400).json({ error: 'One or more missing pcs of info for Update Order' });
    }

    if (!updatedSupplierName || !updatedSupplierEmail || !updatedSupplierPhone || !updatedSupplierAddress) {
        return res.status(400).json({ error: 'One or more missing pcs of info for Update Supplier' });
    }

    try {
        // Call the MySQL Stored Procedure
        const [result] = await db.query(
          'CALL sp_update_supplier(?, ?, ?, ?, ?, ?)',
                [supplierToUpdateID, updatedSupplierName, updatedSupplierEmail, updatedSupplierPhone,
                    updatedSupplierAddress, 1
                ]
        );

        if (result.affectedRows === 0) {
            return res.redirect('/suppliers.html'); //supplier not updated successfully 
        }

        res.redirect('/suppliers.html'); //supplier updated successfully 
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// app.post route for updating a product supplier.
app.post('/update-product-supplier', async (req, res) => {
    const updateProductSupplierID = req.body.updateProductSupplierID;
    const updateProductSupplier_productID = req.body.updateProductSupplier_productID; //extract just the ID; 
    const updateProductSupplier_supplierID = req.body.updateProductSupplier_supplierID; //extract just the ID; 
    const updatedCost_productSupplier = req.body.updatedCost_productSupplier;

    const productID_digitsOnly = updateProductSupplier_productID.split(" ")[0]; //extract just the ID
    const supplierID_digitsOnly = updateProductSupplier_supplierID.split(" ")[0]; //extract just the ID

    if (!updateProductSupplierID || !updateProductSupplier_productID || !updateProductSupplier_supplierID ||
         !updatedCost_productSupplier)
    {
        return res.status(400).json({ error: 'One or more missing pcs of info for Update Product Supplier' });
    }

    try {
        // Call the MySQL Stored Procedure
        const [result] = await db.query(
          'CALL sp_update_product_supplier(?, ?, ?, ?)',
                [updateProductSupplierID, productID_digitsOnly,
                    supplierID_digitsOnly, updatedCost_productSupplier
                ]
        );

        if (result.affectedRows === 0) {
            return res.redirect('/productsuppliers.html'); //product-supplier not updated successfully 
        }

        res.redirect('/productsuppliers.html'); //product-supplier updated successfully 
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// app.post route for Resetting/Restoring the DB - uses a stored procedure and the DML queries \ 
// written in Step 3 to implement the CRUD function.
app.post('/restore-database', async (req, res) => {
  try {
    // Call the MySQL Stored Procedure
    const [result] = await db.query('CALL sp_reset_robo_retail()');

    if (result.affectedRows === 0) {
      res.redirect('/index.html'); //RoboRetail DB not restored successfully 
    }

    res.redirect('/index.html'); //Restore worked  
  } catch (error) {
    console.error('Database error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.listen(PORT, function () {
    console.log('Express started on http://localhost:' + PORT);
});