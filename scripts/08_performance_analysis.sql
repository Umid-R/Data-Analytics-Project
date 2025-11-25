/*
===============================================================================
Yearly Product Performance Analysis
===============================================================================
Purpose:
    - Compare each product's yearly sales with:
        1. Its average sales performance
        2. The previous year's sales
    - Identify trends: Increase, Decrease, Above/Below Average

Techniques Used:
    - CTEs for clean structure
    - Window Functions: AVG(), LAG()
    - Conditional Logic: CASE
===============================================================================
*/

WITH yearly_product_sales AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS year,
        p.product_name,
        SUM(s.sales_amount) AS total_sales,
        SUM(s.sales_quantity) AS total_quantity
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON s.product_key = p.product_key
    WHERE s.order_date IS NOT NULL
    GROUP BY EXTRACT(YEAR FROM order_date), p.product_name
),

yearly_analysis AS (
    SELECT 
        year,
        product_name,
        total_sales,

        -- Average sales for each product across all years
        AVG(total_sales) OVER (PARTITION BY product_name) AS avg_sales,

        -- Difference from average sales
        total_sales - AVG(total_sales) OVER (PARTITION BY product_name) AS diff_avg,

        -- Performance compared to average
        CASE
            WHEN total_sales - AVG(total_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above avg'
            WHEN total_sales - AVG(total_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below avg'
            ELSE 'Average'
        END AS diff_change,

        -- Previous year's sales
        LAG(total_sales) OVER (PARTITION BY product_name ORDER BY year) AS previous_year,

        -- Difference from previous year
        total_sales - LAG(total_sales) OVER (PARTITION BY product_name ORDER BY year) AS diff_previous_year,

        -- Trend compared to previous year
        CASE
            WHEN total_sales - LAG(total_sales) OVER (PARTITION BY product_name ORDER BY year) > 0 THEN 'Increase'
            WHEN total_sales - LAG(total_sales) OVER (PARTITION BY product_name ORDER BY year) < 0 THEN 'Decrease'
            ELSE 'No change'
        END AS diff_change_s
    FROM yearly_product_sales
)

SELECT 
    year,
    product_name,
    total_sales,
    ROUND(avg_sales, 0) AS avg_sales,
    ROUND(diff_avg, 0) AS diff_avg,
    diff_change,
    previous_year,
    diff_previous_year,
    diff_change_s
FROM yearly_analysis
ORDER BY product_name, year;
