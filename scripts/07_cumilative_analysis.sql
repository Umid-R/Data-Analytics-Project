/*
===============================================================================
Monthly Sales Analysis with Running Total and Moving Average
===============================================================================
Purpose:
    - To calculate monthly total sales from the fact_sales table.
    - To compute the running total of sales over time.
    - To calculate the running average of the monthly average prices.

SQL Functions Used:
    - DATE_TRUNC()       : Groups data by month
    - SUM() OVER()       : Calculates running total
    - AVG() OVER()       : Calculates running average
    - ROUND()            : Rounds numbers to nearest integer
===============================================================================
*/


SELECT 
    date,                                   
    total_sales,                            
    SUM(total_sales) OVER (ORDER BY date) AS running_total,  
    ROUND(AVG(avg_price) OVER (ORDER BY date), 0) AS running_avg  
FROM
(
    -- Inner query: calculate monthly totals and average price
    SELECT 
        DATE_TRUNC('month', order_date)::DATE AS date,  
        SUM(sales_amount) AS total_sales,             
        ROUND(AVG(price), 0) AS avg_price            
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_TRUNC('month', order_date)
    ORDER BY DATE_TRUNC('month', order_date)
) t;
