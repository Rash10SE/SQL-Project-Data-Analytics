/*
===============================================================================
Change Over Time Analysis
===============================================================================
Script Purpose:
    This script performs time-series analysis to identify historical trends
    and changes in business performance.

    It aggregates sales-related metrics across different time periods
    to evaluate revenue development, customer activity, and product
    quantities sold.

Main Operations:
    - Analyze sales trends over time.
    - Calculate monthly and yearly revenue.
    - Examine customer activity over time.
    - Track changes in product quantities sold.
    - Compare business performance across different periods.

Key SQL Concepts:
    - YEAR()
    - MONTH()
    - DATETRUNC()
    - FORMAT()
    - GROUP BY
===============================================================================
*/

-- Change Over Time Analysis (Trends): ∑ [Measure] By [Dimension Date] -> Ex: Total Sales by Year, AVG Cost By Month...

-- Analyse sales performance over time
-- Quick Date Functions
SELECT
    YEAR(order_date)             AS order_year,
    MONTH(order_date)            AS order_month,
    SUM(sales_amount)            AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity)                AS total_quantity
FROM gold.gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

-- DATETRUNC()
SELECT
    DATETRUNC(month, order_date) AS order_date,
    SUM(sales_amount)            AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity)                AS total_quantity
FROM gold.gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);
