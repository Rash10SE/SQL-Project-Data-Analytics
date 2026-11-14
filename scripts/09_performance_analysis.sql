/*
===============================================================================
Performance Analysis
===============================================================================
Script Purpose:
    This script evaluates business performance by comparing current results
    with historical performance.

    It performs Year-over-Year (YoY) comparisons to identify changes in
    product sales and measure performance against historical benchmarks.

Main Operations:
    - Calculate yearly product sales.
    - Compare current sales with previous-year performance.
    - Calculate Year-over-Year changes.
    - Compare product performance against historical averages.
    - Classify performance changes using conditional logic.

Key SQL Concepts:
    - Common Table Expressions (CTEs)
    - LAG()
    - CASE
    - Window Functions
    - Year-over-Year (YoY) Analysis
===============================================================================
*/

-- PERFORMANCE ANALYSIS (YoY, MoM...)

-- Analyze the yearly performance of products by comparing their sales to both the avg sales performance of the product and the previous year's sales.
-- 1. yearly performance of products
SELECT YEAR(s.order_date) order_year,
       p.product_name,
       SUM(s.sales_amount) current_sales
FROM gold.gold_fact_sales s
LEFT JOIN gold.gold_dim_products p
ON s.product_key = p.product_key
WHERE s.order_date IS NOT NULL
GROUP BY YEAR(s.order_date), p.product_name;

-- 2. comparing to the avg sales performance and the previous year's sales
WITH yearly_performance AS (SELECT YEAR(s.order_date)  order_year,
                                   p.product_name,
                                   SUM(s.sales_amount) current_sales
                            FROM gold.gold_fact_sales s
                                     LEFT JOIN gold.gold_dim_products p
                                               ON s.product_key = p.product_key
                            WHERE s.order_date IS NOT NULL
                            GROUP BY YEAR(s.order_date), p.product_name
)
SELECT order_year, product_name, current_sales,
       AVG(current_sales) OVER(PARTITION BY product_name) avg_sales,
       current_sales - AVG(current_sales) OVER(PARTITION BY product_name) diff_avg,    -- comparing to the avg sales performance
       CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above the AVG'
            WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below the AVG'
            ELSE 'Exactly the AVG'
       END avg_status,
       LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) prev_year_sales,
       current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) diff2prev_year,
       CASE WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
            WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
            ELSE 'No Change'
       END prev_year_status
FROM yearly_performance;
