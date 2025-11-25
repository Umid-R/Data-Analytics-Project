/*
===============================================================================
Monthly Change Over Time Analysis
===============================================================================
Purpose:
    - To track monthly sales performance trends.
    - To analyze customer activity and sales volume over time.

SQL Functions Used:
    - DATE_TRUNC()
    - SUM(), COUNT()
===============================================================================
*/

-- Monthly sales performance using DATE_TRUNC()
SELECT 
    DATE_TRUNC('month', order_date)::date AS month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY DATE_TRUNC('month', order_date);
