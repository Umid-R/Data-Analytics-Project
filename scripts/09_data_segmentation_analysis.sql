/*
===============================================================================
Sales Contribution by Category
===============================================================================
Purpose:
    - Identify which product categories contribute the most to total sales.
    - Calculate each category's percentage share of overall revenue.

Techniques Used:
    - Window Functions: SUM() OVER()
    - Aggregate Functions: SUM()
    - Formatting: ROUND(), CONCAT()
===============================================================================
*/

-- Calculate total sales and contribution percentage per category
WITH sales_category AS (
    SELECT 
        category,
        sales,
        SUM(sales) OVER() AS total_sales
    FROM (
        SELECT 
            category,
            SUM(sales_amount) AS sales
        FROM gold.fact_sales s
        LEFT JOIN gold.dim_products p
        ON s.product_key = p.product_key
        GROUP BY category
    ) t
)

SELECT
    category,
    sales,
    CONCAT(ROUND(sales / total_sales * 100, 2), '%') AS contribution
FROM sales_category;
