/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database.
    - To retrieve a list of all tables and their schemas.
    - To inspect columns and metadata for specific tables.

Tables Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- =============================================================================
-- Retrieve a list of all tables in the database
-- =============================================================================
-- This query selects all tables in the database, including their catalog, schema, name, and type.
-- It helps to get an overview of all available tables for further exploration.
SELECT 
    *
FROM INFORMATION_SCHEMA.TABLES;

-- =============================================================================
-- Retrieve a list of all columns in the database
-- =============================================================================
-- This query selects all columns across all tables, showing their data type, nullability, and length.
-- Useful for inspecting table structures and planning queries.
SELECT 
    *
FROM INFORMATION_SCHEMA.COLUMNS;

-- =============================================================================
-- Retrieve columns for a specific table (example: dim_customers)
-- =============================================================================
-- Filters columns to only show those in the 'dim_customers' table.
-- Helps to quickly inspect the structure of a particular table.
SELECT 
    *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
