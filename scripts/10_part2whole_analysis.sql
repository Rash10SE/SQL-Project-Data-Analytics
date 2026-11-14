/*
===============================================================================
PART-TO-WHOLE ANALYSIS
===============================================================================
Purpose:
    This script performs a part-to-whole analysis to identify how much each
    product category contributes to overall sales.

Analysis:
    1. Calculate total sales for each product category.
    2. Calculate overall sales across all categories using a window function.
    3. Determine each category's percentage contribution to total sales.
    4. Sort the results to identify the categories contributing the most
       to overall sales.

Techniques Used:
    - LEFT JOIN: Combine sales data with product categories.
    - GROUP BY: Aggregate sales by product category.
    - Common Table Expression (CTE): Organize aggregated sales data.
    - SUM() OVER(): Calculate overall sales without losing category-level detail.
    - CAST(): Convert data types for accurate percentage calculations.
    - ROUND(): Round percentages to two decimal places.
    - CONCAT(): Append the percentage symbol.

Business Question:
    Which product categories contribute the most to overall sales?

===============================================================================
*/

-- PART-TO-WHOLE ANALYSIS: ( [MEASURE] / Total [MEASURE] ) * 100 BY [DIMENSION] -> Ex: Sales / Total Sales * 100 BY Category

-- Which categories contribute the most to overall sales?
SELECT p.category,
       SUM(s.sales_amount) total_sales
FROM gold.gold_fact_sales s
LEFT JOIN gold.gold_dim_products p
ON s.product_key = p.product_key
GROUP BY p.category
ORDER BY total_sales DESC;

-- CTE
WITH sales_categories AS (SELECT p.category,
                                 SUM(s.sales_amount) total_sales
                          FROM gold.gold_fact_sales s
                                   LEFT JOIN gold.gold_dim_products p
                                             ON s.product_key = p.product_key
                          GROUP BY p.category
)
SELECT category, total_sales,
       SUM(total_sales) OVER() overall_sales,
       CONCAT(ROUND(CAST(total_sales AS FLOAT) / SUM(total_sales) OVER() * 100, 2), '%') AS percentage_total
FROM sales_categories
ORDER BY overall_sales;
