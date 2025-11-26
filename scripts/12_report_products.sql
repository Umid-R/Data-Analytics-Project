/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

-- Create or replace view for products report
CREATE OR REPLACE VIEW gold.report_products AS

-- 1) Base Query: Retrieve essential fields from sales and product tables
WITH base_query AS (
    SELECT 
        s.order_number,
        s.customer_key,
        s.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        s.order_date,
        s.sales_amount,
        s.sales_quantity,
        s.price,        -- fixed price per product
        p.cost,
        p.start_day
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON s.product_key = p.product_key
    WHERE s.order_date IS NOT NULL
)

-- 2) Product Aggregation: Summarize product-level metrics
, product_aggregation AS (
    SELECT 
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        price,
        MAX(order_date) AS last_order_date,      -- last sale date
        COUNT(order_number) AS total_orders,     -- total orders
        SUM(sales_quantity) AS total_quantity,  -- total units sold
        SUM(sales_amount) AS total_sales,       -- total revenue
        COUNT(DISTINCT customer_key) AS total_customers, -- unique buyers
        -- Lifespan in months between first and last order
        EXTRACT(month FROM age(MAX(order_date), MIN(order_date))) +
        EXTRACT(YEAR FROM age(MAX(order_date), MIN(order_date))) * 12 AS lifespan_months
    FROM base_query
    GROUP BY product_key, product_name, category, subcategory, cost, price
)

-- 3) Final Output: Calculate KPIs and segment products
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    price,
    total_orders,
    total_quantity,
    total_sales,
    -- Average revenue per order
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders 
    END AS avg_order_revenue,
    -- Average monthly revenue, handles zero lifespan
    CASE
        WHEN lifespan_months = 0 THEN total_sales
        ELSE ROUND(total_sales / lifespan_months, 2) 
    END AS avg_monthly_revenue,
    -- Revenue-based segmentation
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,
    total_customers,
    lifespan_months,
    last_order_date,
    -- Recency in months since last sale
    EXTRACT(month FROM age(CURRENT_DATE, last_order_date)) + 
    EXTRACT(YEAR FROM age(CURRENT_DATE, last_order_date)) * 12 AS recency_in_months
FROM product_aggregation;
