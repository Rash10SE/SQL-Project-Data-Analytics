/*
===============================================================================
Ranking Analysis
===============================================================================
Script Purpose:
    This script identifies the highest- and lowest-performing products
    and customers based on relevant business metrics.

    It applies ranking functions and filtering techniques to evaluate
    performance, identify top performers, and highlight potential outliers.

Main Operations:
    - Identify top-performing products.
    - Find the lowest-performing products.
    - Rank customers based on their sales performance.
    - Identify the most and least active customers.
    - Compare TOP filtering with SQL ranking functions.

Key SQL Concepts:
    - RANK()
    - TOP
    - Window Functions
    - ORDER BY
===============================================================================
*/

-- RANKING: order the values of Dimensions by Measures | RANK [Dimension] BY ∑ [Measure] | Top N Performers / Top BOTTOM Performers.

-- Which 5 Products generate the highest revenue?
SELECT TOP 5 product_key, SUM(sales_amount) total_revenue
FROM gold.gold_fact_sales
GROUP BY product_key
ORDER BY total_revenue DESC;
-- OR
SELECT product_key, total_revenue
FROM (SELECT product_key,
             SUM(sales_amount) total_revenue,
             ROW_NUMBER() OVER (ORDER BY SUM(sales_amount) DESC) ranking
      FROM gold.gold_fact_sales
      GROUP BY product_key)t
WHERE ranking <= 5;

-- The 5 worst-performing products in terms of sales
SELECT TOP 5 product_key, SUM(sales_amount) total_revenue
FROM gold.gold_fact_sales
GROUP BY product_key
ORDER BY total_revenue;
