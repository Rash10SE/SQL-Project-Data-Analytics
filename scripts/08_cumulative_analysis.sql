/*
===============================================================================
Cumulative Analysis
===============================================================================
Script Purpose:
    This script analyzes cumulative business performance and moving averages
    over time using SQL window functions.

    It calculates running totals and average values to provide insights
    into long-term business trends and performance development.

Main Operations:
    - Calculate cumulative revenue over time.
    - Analyze yearly running sales totals.
    - Calculate moving average product prices.
    - Evaluate long-term business performance trends.

Key SQL Concepts:
    - SUM() OVER()
    - AVG() OVER()
    - Window Functions
    - Running Totals
    - Moving Averages
===============================================================================
*/

-- CUMULATIVE ANALYSIS

-- Total Sales per Month & the running total of sales over time
-- Total Sales per Month
SELECT DATETRUNC(MONTH, order_date) order_month,
       SUM(sales_amount) total_sales
FROM gold.gold_fact_sales
WHERE DATETRUNC(MONTH, order_date) IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY DATETRUNC(MONTH, order_date);

-- The running total of sales over time (by month)
SELECT order_month, total_sales,
       SUM(total_sales) OVER(ORDER BY order_month) running_total_sales
FROM (SELECT DATETRUNC(MONTH, order_date) order_month,
       SUM(sales_amount) total_sales
FROM gold.gold_fact_sales
WHERE DATETRUNC(MONTH, order_date) IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date))t;

-- The running total of sales over time (by year)
SELECT order_year, total_sales,
       SUM(total_sales) OVER(ORDER BY order_year) running_total_sales
FROM (SELECT DATETRUNC(YEAR, order_date) order_year,
       SUM(sales_amount) total_sales
FROM gold.gold_fact_sales
WHERE DATETRUNC(YEAR, order_date) IS NOT NULL
GROUP BY DATETRUNC(YEAR, order_date))t;

-- The running total of sales over time (by month BUT for each year 'PARTITION BY YEAR(order_date)')
SELECT order_date, total_sales,
       SUM(total_sales) OVER(PARTITION BY YEAR(order_date) ORDER BY order_date) running_total_sales
FROM (SELECT DATETRUNC(MONTH, order_date) order_date,
       SUM(sales_amount) total_sales
FROM gold.gold_fact_sales
WHERE DATETRUNC(MONTH, order_date) IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date))t;
