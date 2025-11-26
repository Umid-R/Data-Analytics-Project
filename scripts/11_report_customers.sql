/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
       - total orders
       - total sales
       - total quantity purchased
       - total products
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last order)
       - average order value
       - average monthly spend
===============================================================================
*/

CREATE OR REPLACE VIEW gold.report_customers AS

/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
   - Pulls transactional + customer info
   - Filters out rows with NULL order_date to avoid AGE / date errors
---------------------------------------------------------------------------*/
WITH base_query AS (
SELECT 
    s.order_number,               
    s.product_key,       
    s.customer_key,             
    CONCAT(c.first_name,' ',c.last_name) AS full_name, 
    EXTRACT(YEAR FROM AGE(c.birthdate)) AS age,      
    s.order_date,                 
    s.sales_amount,                  
    s.sales_quantity,                 
    s.price                   
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
    ON s.customer_key = c.customer_key
WHERE order_date IS NOT NULL           
)

/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at customer level
   - Groups all orders by customer
   - Calculates lifespan based on first vs last purchase
---------------------------------------------------------------------------*/
, customer_aggregation AS (
SELECT 
    customer_key,
    full_name,
    age,

    COUNT(order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(sales_quantity) AS total_quantity,
    COUNT(DISTINCT product_key) AS total_products,
    MAX(order_date) AS last_order,
    EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
    EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS lifespan_months

FROM base_query
GROUP BY customer_key, full_name, age
)

/*---------------------------------------------------------------------------
3) Final Select: Adds segmentation + KPIs
---------------------------------------------------------------------------*/
SELECT
    customer_key,
    full_name,
    age,
    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE 'Above 50'
    END AS age_group,
    CASE
        WHEN total_sales > 5000 AND lifespan_months >= 12 THEN 'VIP'
        WHEN total_sales <= 5000 AND lifespan_months >= 12 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,
    total_orders,
    total_sales,
	total_sales / total_orders AS avg_order_value,
	CASE
        WHEN lifespan_months = 0 THEN total_sales
        ELSE ROUND(total_sales / lifespan_months, 2)
    END AS avg_monthly_spend,
    total_quantity,
    total_products,
    last_order,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, last_order)) * 12 +
    EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_order)) AS recency_months,
    lifespan_months

FROM customer_aggregation;


