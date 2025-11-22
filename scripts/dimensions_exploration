/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables in the 'gold' schema.
    - To inspect tables, unique values, and categories for analysis.
    
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- =============================================================================
-- Retrieve all tables in the 'gold' schema
-- =============================================================================
-- This query lists all tables in the 'gold' schema to get an overview of available dimension tables.
SELECT 
    TABLE_CATALOG,       -- Database name
    TABLE_SCHEMA,        -- Schema name ('gold')
    TABLE_NAME,          -- Table name
    TABLE_TYPE           -- Type of object (BASE TABLE or VIEW)
FROM INFORMATION_SCHEMA.TABLES
WHERE table_schema = 'gold';

-- =============================================================================
-- Retrieve a list of unique countries from which customers originate
-- =============================================================================
SELECT DISTINCT 
    country
FROM gold.dim_customers
ORDER BY country;

-- =============================================================================
-- Retrieve a list of unique genders from customers
-- =============================================================================
SELECT DISTINCT 
    gender
FROM gold.dim_customers
ORDER BY gender;

-- =============================================================================
-- Retrieve all data from the 'dim_products' table
-- =============================================================================
SELECT *
FROM gold.dim_products;

-- =============================================================================
-- Retrieve unique combinations of category, subcategory, and product name
-- =============================================================================
-- This helps to explore the product hierarchy and structure.
SELECT DISTINCT
    category,
    subcategory,
    product_name
FROM gold.dim_products
ORDER BY category, subcategory, product_name;
