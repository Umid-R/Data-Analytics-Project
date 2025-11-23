/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (totals, averages, counts) for quick insights.
    - To understand overall business performance and trends.

SQL Functions Used:
    - COUNT()
    - SUM()
    - AVG()
    - DISTINCT
===============================================================================
*/

-- =============================================================================
-- View all sales records in the fact_sales table
-- =============================================================================
SELECT *
FROM gold.fact_sales;

-- =============================================================================
-- Total number of products in the product dimension table
-- =============================================================================
SELECT
    COUNT(product_key) AS total_products
FROM gold.dim_products;

-- =============================================================================
-- Total number of products that have been sold (based on sales records)
-- =============================================================================
SELECT 
    COUNT(DISTINCT product_key) AS num_of_products_sold
FROM gold.fact_sales;

-- =============================================================================
-- Total number of customers in the customer dimension table
-- =============================================================================
SELECT 
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers;

-- =============================================================================
-- Total number of customers who have placed an order
-- =============================================================================
SELECT 
    COUNT(DISTINCT customer_key) AS num_of_customers_with_orders
FROM gold.fact_sales;

-- =============================================================================
-- Total number of orders
-- =============================================================================
SELECT
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;

-- =============================================================================
-- Total sales amount
-- =============================================================================
SELECT 
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales;

-- =============================================================================
-- Total quantity of items sold
-- =============================================================================
SELECT
    SUM(sales_quantity) AS total_sales_quantity
FROM gold.fact_sales;

-- =============================================================================
-- Average price per order
-- =============================================================================
-- First, sum the sales_amount for each order, then calculate the average
SELECT
    AVG(order_total) AS average_price_per_order
FROM
(
    SELECT 
        order_number,
        SUM(sales_amount) AS order_total
    FROM gold.fact_sales
    GROUP BY order_number
) t;




-- Generate a Report that shows all key metrics of the business

SELECT  'total_products' as measure_name , COUNT(product_key) as measure_value  FROM gold.dim_products
UNION ALL
SELECT 'num_of_products_sold', COUNT(DISTINCT product_key) FROM gold.fact_sales
UNION ALL
SELECT 'total_customers', COUNT(customer_key)  FROM gold.dim_customers
UNION ALL
SELECT 'total_order', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'total_sales', SUM(sales_amount)   FROM gold.fact_sales
UNION ALL
SELECT 'total_sales_quantity',SUM(sales_quantity) FROM gold.fact_sales
UNION ALL
SELECT 'average_price_per_order', AVG(order_total) 
FROM
(
    SELECT 
        order_number,
        SUM(sales_amount) AS order_total
    FROM gold.fact_sales
    GROUP BY order_number
) t;




