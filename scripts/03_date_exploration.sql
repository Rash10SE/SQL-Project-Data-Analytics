/*
===============================================================================
Date Range Exploration
===============================================================================
Script Purpose:
    This script analyzes the temporal boundaries and historical coverage
    of the dataset.

    It calculates minimum and maximum dates to understand the available
    order history and explores customer demographic boundaries, including
    the oldest and youngest customer ages.

Main Operations:
    - Identify the earliest and latest order dates.
    - Calculate the overall order duration in months.
    - Determine the oldest and youngest customer ages.
    - Understand the historical coverage of the dataset.

Key SQL Concepts:
    - MIN()
    - MAX()
    - DATEDIFF()
===============================================================================
*/

-- DATE EXPLORATION
-- first & last order
SELECT MIN(order_date) first_order,
       MAX(order_date) last_order
FROM gold.gold_fact_sales;

-- How many years of sales are available?
SELECT DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) years_of_sales
FROM gold.gold_fact_sales;

-- Youngest & oldest customer
SELECT MIN(birthdate) oldest_customer,
       DATEDIFF(YEAR, MIN(birthdate), GETDATE()) max_age,
       MAX(birthdate) youngest_customer,
       DATEDIFF(YEAR, MAX(birthdate), GETDATE()) min_age
FROM gold.gold_dim_customers;
