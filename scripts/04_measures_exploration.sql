/*
===============================================================================
Measures Exploration
===============================================================================
Script Purpose:
    This script calculates essential business metrics and high-level
    performance indicators using aggregate functions.

    It provides an overview of sales performance, order volumes,
    product quantities, and customer activity.

Main Operations:
    - Calculate total sales and average sales values.
    - Count total orders and unique customers.
    - Calculate the total number of products.
    - Generate a consolidated summary of business metrics.

Key SQL Concepts:
    - SUM()
    - AVG()
    - COUNT()
    - COUNT(DISTINCT)
    - UNION ALL
===============================================================================
*/

-- MEASURES EXPLORATION:
-- Total sales
SELECT SUM(sales_amount) total_sales FROM gold.gold_fact_sales;

-- How many items are sold?
SELECT SUM(quantity) items_sold FROM gold.gold_fact_sales;

-- Average selling price
SELECT AVG(price) avg_selling_price FROM gold.gold_fact_sales;

-- Total number of orders
SELECT COUNT(DISTINCT order_number) total_orders FROM gold.gold_fact_sales;

-- Total number of products
SELECT COUNT(product_id) total_products FROM gold.gold_dim_products;

-- Total number of customers
SELECT COUNT(DISTINCT customer_id) total_customers FROM gold.gold_dim_customers;

-- Total number of customers that has placed an order
SELECT * from gold.gold_fact_sales;
SELECT COUNT(DISTINCT customer_key) total_customers_placed_order FROM gold.gold_fact_sales;

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.gold_fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.gold_fact_sales
UNION ALL
SELECT 'Average Selling Price', AVG(price) FROM gold.gold_fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.gold_fact_sales
UNION ALL
SELECT 'Total Products', COUNT(product_id) FROM gold.gold_dim_products
UNION ALL
SELECT 'Total Customers', COUNT(DISTINCT customer_key) FROM gold.gold_fact_sales;
