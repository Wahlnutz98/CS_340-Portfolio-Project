// This file is the work of Dr. Curry and the rest of cs340 Team.
// Adapted / based on the code from the linked exploration (Activity 2) to establish a connection to a database and store user credentials.
// Course is taught by Dr. Curry at Oregon State. 
// Source URL: https://canvas.oregonstate.edu/courses/2042369/assignments/10464646?module_item_id=26640125

// Get an instance of mysql we can use in the app
let mysql = require('mysql2')

// Create a 'connection pool' using the provided credentials
const pool = mysql.createPool({
    waitForConnections: true,
    connectionLimit   : 10,
    host              : 'classmysql.engr.oregonstate.edu',
    user              : 'cs340_xxxxx',
    password          : 'xxxxxxxxxxx',
    database          : 'cs340_xxxxxx'
}).promise(); // This makes it so we can use async / await rather than callbacks

// Export it for use in our application
module.exports = pool;