/*
===============================================================================
Date Range Exploration
===============================================================================
Purpose:
    - To analyze date ranges in the sales data.
    - To understand the age distribution of customers.

SQL Functions Used:
    - MIN()
    - MAX()
    - AVG()
    - AGE()
    - EXTRACT()
    - ROUND()
===============================================================================
*/

-- Retrieve all order dates from the sales fact table
SELECT 
    order_date
FROM gold.fact_sales;


-- Find the earliest and latest order dates in the sales data
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM gold.fact_sales;


-- Analyze customer age distribution (minimum, maximum, and average age)
SELECT 
    MIN(EXTRACT(YEAR FROM AGE(birthdate))) AS min_age,
    MAX(EXTRACT(YEAR FROM AGE(birthdate))) AS max_age,
    ROUND(AVG(EXTRACT(YEAR FROM AGE(birthdate))), 0) AS avg_age
FROM gold.dim_customers;
