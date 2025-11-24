/*
===============================================================================
Product & Customer Performance Ranking Analysis
===============================================================================
Purpose:
    - To identify top and bottom performing products based on sales value.
    - To rank products and customers by revenue contribution.
    - To highlight customers with the fewest orders.

SQL Functions Used:
    - SUM()
    - COUNT()
    - ROW_NUMBER()
    - GROUP BY
    - ORDER BY
    - LIMIT
    - JOIN
===============================================================================
*/

-- =============================================================================
-- Top 5 products that generate the highest total sales value
-- =============================================================================
SELECT 
    s.product_key,
    p.product_name,
    SUM(s.sales_amount) AS total_sales
FROM gold.fact_sales s
JOIN gold.dim_products p
    ON s.product_key = p.product_key
GROUP BY s.product_key, p.product_name
ORDER BY SUM(s.sales_amount) DESC
LIMIT 5;


-- =============================================================================
-- Rank all products based on total sales value (highest to lowest)
-- =============================================================================
SELECT 
    s.product_key,
    p.product_name,
    SUM(s.sales_amount) AS total_sales,
    ROW_NUMBER() OVER (ORDER BY SUM(s.sales_amount) DESC) AS rank
FROM gold.fact_sales s
JOIN gold.dim_products p
    ON s.product_key = p.product_key
GROUP BY s.product_key, p.product_name;


-- =============================================================================
-- Bottom 5 worst-performing products based on total sales value
-- =============================================================================
SELECT 
    s.product_key,
    p.product_name,
    SUM(s.sales_amount) AS total_sales
FROM gold.fact_sales s
JOIN gold.dim_products p
    ON s.product_key = p.product_key
GROUP BY s.product_key, p.product_name
ORDER BY SUM(s.sales_amount) ASC
LIMIT 5;


-- =============================================================================
-- Top 10 customers with the highest revenue contribution
-- =============================================================================
SELECT 
    s.customer_key,
    c.first_name,
    c.last_name,
    SUM(s.sales_amount) AS total_revenue,
    ROW_NUMBER() OVER (ORDER BY SUM(s.sales_amount) DESC) AS rank
FROM gold.fact_sales s
JOIN gold.dim_customers c
    ON s.customer_key = c.customer_key
GROUP BY s.customer_key, c.first_name, c.last_name
ORDER BY total_revenue DESC
LIMIT 10;


-- =============================================================================
-- Bottom 3 customers with the fewest orders
-- =============================================================================
SELECT
    s.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT s.order_number) AS total_orders
FROM gold.fact_sales s
JOIN gold.dim_customers c
    ON s.customer_key = c.customer_key
GROUP BY s.customer_key, c.first_name, c.last_name
ORDER BY COUNT(DISTINCT s.order_number) ASC
LIMIT 3;
