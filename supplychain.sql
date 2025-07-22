-- Table for canceled_test.csv
CREATE TABLE canceled_test (
  order_no INTEGER,
  date TEXT,          -- Because dates are stored as strings like "Tuesday, January 3, 2017"
  line INTEGER,
  customer_no INTEGER,
  item TEXT,
  nc_order INTEGER,
  nc_ship INTEGER,
  PRIMARY KEY (order_no, line)
);

-- Table for sales_test.csv
CREATE TABLE sales_test (
  order_no INTEGER,
  date TEXT,          -- Same date format as above
  line INTEGER,
  customer_no INTEGER,
  item TEXT,
  ns_order INTEGER,
  ns_ship INTEGER,
  PRIMARY KEY (order_no, line)
);


-- Queries
-- The number of orders placed in January 2017 in the sales_test table
SELECT COUNT(ORDER_NO) as Order_placed_in_January
FROM sales_test 
WHERE DATE LIKE '%January%';

