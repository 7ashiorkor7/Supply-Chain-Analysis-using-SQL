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

-- The total number of units ordered in February 2017 in the sales_test table
SELECT SUM(NS_ORDER) as Total_units_ordered_in_February
FROM sales_test
WHERE DATE LIKE '%February%';

-- The number of canceled orders for each customer in the canceled_test table
SELECT CUSTOMER_NO, COUNT(ORDER_NO) as Canceled_orders
FROM canceled_test
GROUP BY CUSTOMER_NO;

--The number of unique customers in the sales_test table
SELECT COUNT(DISTINCT CUSTOMER_NO) as Unique_customers
FROM sales_test;    

-- The average number of items ordered per order in the sales_test table
SELECT AVG(NS_ORDER) as Average_items_ordered_per_order
FROM sales_test;    

-- The top 5 items that have been ordered the most in the sales_test table
SELECT ITEM, SUM(NS_ORDER) as Total_ordered
FROM sales_test
GROUP BY ITEM
ORDER BY Total_ordered DESC
LIMIT 5;

-- The total number of successful orders where the CUSTOMER_NO is EITHER 1857566 OR 1358538 AND the date is in January 2017
SELECT COUNT(ORDER_NO) as Successful_orders
FROM sales_test
WHERE (CUSTOMER_NO = 1857566 OR CUSTOMER_NO = 1358538)
AND DATE LIKE '%January%';  

-- The total number of units ordered and canceled for each item that appears in both sales_test.csv and canceled_test.csv
SELECT s.ITEM,
       SUM(s.NS_ORDER) as Total_ordered,
       SUM(c.NC_ORDER) as Total_canceled
FROM sales_test s
JOIN canceled_test c ON s.ITEM = c.ITEM
GROUP BY s.ITEM
ORDER BY Total_ordered DESC;

-- Comparing the number of canceled orders and successful orders for the same items
SELECT s.ITEM,
       SUM(s.NS_ORDER) as Total_successful_orders,
       SUM(c.NC_ORDER) as Total_canceled_orders
FROM sales_test s
JOIN canceled_test c ON s.ITEM = c.ITEM
GROUP BY s.ITEM
ORDER BY Total_successful_orders DESC;

/* Classifying each order in the sales_test.csv dataset as 'High', 'Medium', or 'Low' based on the number of units ordered (NS_ORDER):
- 'High' if NS_ORDER is greater than 50.
- 'Medium' if NS_ORDER is between 20 and 50.
- 'Low' if NS_ORDER is less than 20.*/
SELECT ORDER_NO,
       DATE,
       LINE,
       CUSTOMER_NO,
       ITEM,
       NS_ORDER,
       NS_SHIP,
       CASE 
           WHEN NS_ORDER > 50 THEN 'High'
           WHEN NS_ORDER BETWEEN 20 AND 50 THEN 'Medium'
           ELSE 'Low'
       END AS Order_Class
FROM sales_test;    

-- The percentage of shipped items out of the total ordered items for eah customer in the sales_test table
SELECT CUSTOMER_NO,
       SUM(NS_ORDER) as Total_ordered,
       SUM(NS_SHIP) as Total_shipped,
       (SUM(NS_SHIP) * 100.0 / SUM(NS_ORDER)) as Percentage_shipped
FROM sales_test
GROUP BY CUSTOMER_NO
HAVING SUM(NS_ORDER) > 0;  -- To avoid division by zero 

-- The top 3 customers with the most canceled orders in the canceled_test table
SELECT CUSTOMER_NO,
       COUNT(ORDER_NO) as Canceled_orders
FROM canceled_test
GROUP BY CUSTOMER_NO
ORDER BY Canceled_orders DESC
LIMIT 3;    

-- All the items that have been canceled more than shipped in the canceled_test 
SELECT c.ITEM,
       SUM(c.NC_ORDER) as Total_canceled,
       SUM(s.NS_SHIP) as Total_shipped
FROM canceled_test c
JOIN sales_test s ON c.ITEM = s.ITEM
GROUP BY c.ITEM
HAVING SUM(c.NC_ORDER) > SUM(s.NS_SHIP)
ORDER BY Total_canceled DESC;   

-- The customer who placed the largest number of orders in January 2017 in the sales_test table
SELECT CUSTOMER_NO,
       COUNT(ORDER_NO) as Total_orders
FROM sales_test
WHERE DATE LIKE '%January%'
GROUP BY CUSTOMER_NO
ORDER BY Total_orders DESC
LIMIT 1;

/* For each customer, calculate the cumulative total of ordered units (NS_ORDER) over time and rank the orders by date. 
Show the ORDER_NO, CUSTOMER_NO, NS_ORDER, DATE, and the cumulative total of ordered units. */   
SELECT ORDER_NO,
       CUSTOMER_NO,
       NS_ORDER,
       DATE,
       SUM(NS_ORDER) OVER (PARTITION BY CUSTOMER_NO ORDER BY DATE) as Cumulative_ordered_units
FROM sales_test
ORDER BY CUSTOMER_NO, DATE;

/* Find the top 3 customers who have the highest total number of canceled orders (NC_ORDER) from canceled_test.csv and their 
corresponding total sales (NS_ORDER) from sales_test.csv. */
SELECT c.CUSTOMER_NO,
       COUNT(c.ORDER_NO) as Total_canceled_orders,
       SUM(s.NS_ORDER) as Total_sales
FROM canceled_test c
JOIN sales_test s ON c.CUSTOMER_NO = s.CUSTOMER_NO
GROUP BY c.CUSTOMER_NO
ORDER BY Total_canceled_orders DESC
LIMIT 3;

-- The contribution of the top 5 customers by total NS_ORDER to the overall sales
SELECT CUSTOMER_NO,
       SUM(NS_ORDER) as Total_ordered,
       (SUM(NS_ORDER) * 100.0 / (SELECT SUM(NS_ORDER) FROM sales_test)) as Contribution_percentage
FROM sales_test
GROUP BY CUSTOMER_NO
ORDER BY Total_ordered DESC
LIMIT 5;

/* Perform an ABC classification of items in sales_test.csv, where:

- Class A: Top 20% of items contributing to 80% of total sales.
- Class B: Next 30% of items contributing to 15% of total sales.
- Class C: Remaining 50% of items. */
WITH Ranked_Items AS (
    SELECT ITEM,
           SUM(NS_ORDER) as Total_ordered,
           SUM(NS_ORDER) * 100.0 / SUM(SUM(NS_ORDER)) OVER () as Contribution_percentage,
           ROW_NUMBER() OVER (ORDER BY SUM(NS_ORDER) DESC) as Rank
    FROM sales_test
    GROUP BY ITEM
),
Total_Items AS (
    SELECT COUNT(*) as Total_count
    FROM Ranked_Items
),
Classified_Items AS (
    SELECT ITEM,
           Total_ordered,
           Contribution_percentage,
           CASE 
               WHEN Rank <= (SELECT Total_count FROM Total_Items) * 0.2 THEN 'A'
               WHEN Rank <= (SELECT Total_count FROM Total_Items) * 0.5 THEN 'B'
               ELSE 'C'
           END AS Class
    FROM Ranked_Items
)
SELECT ITEM,
       Total_ordered,
       Contribution_percentage,
       Class
FROM Classified_Items
ORDER BY Class, Total_ordered DESC;     


