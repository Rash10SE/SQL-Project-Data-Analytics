/*
===============================================================================
DATA SEGMENTATION ANALYSIS
===============================================================================
Purpose:
    This script performs data segmentation to group products and customers
    into meaningful categories based on specific business criteria.

Analysis:
    1. Product Cost Segmentation:
       - Group products into four cost ranges:
           * Below 100
           * Between 100 and 500
           * Between 500 and 1000
           * Above 1000
       - Count the number of products within each cost range.
       - Identify the most common product cost segments.

    2. Customer Spending Segmentation:
       - Calculate total spending for each customer.
       - Identify the first and last purchase dates.
       - Calculate customer lifespan in months.
       - Classify customers into three segments:
           * VIP: At least 12 months of history and spending more than 5000.
           * Regular: At least 12 months of history and spending 5000 or less.
           * New: Customer lifespan of less than 12 months.
       - Count the total number of customers in each segment.

Techniques Used:
    - Common Table Expressions (CTEs): Structure intermediate calculations.
    - CASE WHEN: Define product cost ranges and customer segments.
    - SUM(): Calculate total customer spending.
    - MIN() / MAX(): Identify first and last purchase dates.
    - DATEDIFF(): Calculate customer lifespan in months.
    - COUNT(): Count products and customers within each segment.
    - GROUP BY: Aggregate results by segment.
    - ORDER BY: Rank segments based on their total counts.

Business Questions:
    - How are products distributed across different cost ranges?
    - How many customers belong to each spending segment?
    - How can customers be classified based on their spending behavior
      and relationship duration?

===============================================================================
*/

-- DATA SEGMENTATION: Group the data based on a specific range - help to understand the correlation between two measures | [MEASURE] by [MEASURE]
-- Segment products into cost ranges and count how many products fall into each segment.
WITH cost_ranges AS (SELECT product_key,
                            product_name,
                            cost,
                            CASE
                                WHEN cost < 100 THEN 'Below 100'
                                WHEN cost BETWEEN 100 AND 500 THEN 'Between 100 & 500'
                                WHEN cost BETWEEN 500 AND 1000 THEN 'Between 500 & 1000'
                                ELSE 'Above 1000'
                            END cost_rang
                     FROM gold.gold_dim_products)
SELECT cost_rang,
       COUNT(product_key) as total_products
FROM cost_ranges
GROUP BY cost_rang
ORDER BY total_products DESC;

/* Group customers into three segments based on their spending behavior:
 - VIP: Customers with at least 12 months of history and spending more than €5,000.
 - Regular: Customers with at least 12 months of history but spending €5,000 or less.
 - New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group.
 */
WITH customers_spend AS (SELECT customer_key,
                                SUM(sales_amount)                                 total_spend,
                                MIN(order_date)                                   first_order,
                                MAX(order_date)                                   last_order,
                                DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) lifespan
                         FROM gold.gold_fact_sales
                         GROUP BY customer_key)
/*SELECT customer_key, total_spend, lifespan,
       CASE WHEN lifespan >= 12 AND total_spend <= 5000 THEN 'Regular'
            WHEN lifespan >= 12 AND total_spend > 5000 THEN 'VIP'
            ELSE 'New'
       END customer_status
FROM customers_spend;*/
SELECT customer_status,
       COUNT(customer_key) total_customers
FROM (SELECT customer_key,
             total_spend,
             lifespan,
             CASE
                 WHEN lifespan >= 12 AND total_spend <= 5000 THEN 'Regular'
                 WHEN lifespan >= 12 AND total_spend > 5000 THEN 'VIP'
                 ELSE 'New'
            END customer_status
      FROM customers_spend)t
GROUP BY customer_status
ORDER BY total_customers;
