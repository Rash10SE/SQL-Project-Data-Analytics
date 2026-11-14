/*
===============================================================================
Dimensions Exploration
===============================================================================
Script Purpose:
    This script explores the categorical attributes within the customer
    and product dimension tables.

    It identifies unique values to better understand the characteristics
    and categories represented in the dataset.

Main Operations:
    - Explore unique customer countries and genders.
    - Identify available product categories and subcategories.
    - Examine distinct product lines.
    - Understand categorical data distributions.

Key SQL Concepts:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- DIMENSIONS EXPLORATION
--  All Countries our customers come from.
SELECT DISTINCT country FROM gold.gold_dim_customers;

-- Genders our customers
SELECT DISTINCT gender FROM gold.gold_dim_customers;

-- All Categories our products
SELECT DISTINCT category FROM gold.gold_dim_products;

-- All SubCategories our products
SELECT DISTINCT subcategory FROM gold.gold_dim_products;
