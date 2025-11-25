/*
===============================================================================
Product & Customer Segmentation Analysis
===============================================================================
Purpose:
    - Segment products into cost ranges and count how many products fall into each range.
    - Group customers based on spending behavior and activity period.
    - Identify key customer segments: VIP, Regular, New.

SQL Functions Used:
    - CASE WHEN
    - COUNT(), SUM()
    - Aggregate Functions: MIN(), MAX(), EXTRACT(), AGE()
===============================================================================
*/

-- Segment products into cost ranges
WITH product_segments AS (
    SELECT
        product_name,
        cost,
        CASE
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)

-- Count products in each cost segment
SELECT 
    COUNT(product_name) AS products,
    cost_range
FROM product_segments
GROUP BY cost_range;


-- Calculate customer orders info including lifespan in months
WITH customer_orders_info AS (
    SELECT 
        s.customer_key,
        SUM(sales_amount) AS total_sales,
        MIN(s.order_date) AS first_order_date,
        MAX(s.order_date) AS last_order_date,

        -- Customer lifespan in total months (using AGE function)
        EXTRACT(YEAR FROM AGE(MAX(s.order_date), MIN(s.order_date))) * 12 +
        EXTRACT(MONTH FROM AGE(MAX(s.order_date), MIN(s.order_date))) AS lifespan_months

    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON s.product_key = p.product_key
    GROUP BY s.customer_key
),

-- Segment customers based on spending and lifespan
customer_segment AS (
    SELECT
        customer_key,
        total_sales,
        lifespan_months,
        CASE
            WHEN total_sales > 5000 AND lifespan_months >= 12 THEN 'VIP'
            WHEN total_sales <= 5000 AND lifespan_months >= 12 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_orders_info
)

-- Count total customers in each segment
SELECT 
    COUNT(customer_key) AS total_customers,
    customer_segment
FROM customer_segment
GROUP BY customer_segment;
