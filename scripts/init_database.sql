/*
===============================================================================
Database Initialization
===============================================================================
Script Purpose:
    This script initializes the DataWarehouseAnalytics database.

    It checks whether the database already exists and drops it before creating
    a fresh database environment. It then creates the gold schema and the
    required dimension and fact tables.

    Finally, it loads the source CSV files into the database using BULK INSERT.

Main Operations:
    - Drop and recreate the database.
    - Create the gold schema.
    - Create dimension and fact tables.
    - Import source data using BULK INSERT.

Warning:
    Running this script will delete the existing DataWarehouseAnalytics
    database and all its contents before recreating it.
===============================================================================
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouseAnalytics' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;
GO

-- Create the 'DataWarehouseAnalytics' database
CREATE DATABASE DataWarehouseAnalytics;
GO

USE DataWarehouseAnalytics;
GO

-- Create Schemas

CREATE SCHEMA gold;
GO

CREATE TABLE gold.dim_customers(
    customer_key int,
    customer_id int,
    customer_number nvarchar(50),
    first_name nvarchar(50),
    last_name nvarchar(50),
    country nvarchar(50),
    marital_status nvarchar(50),
    gender nvarchar(50),
    birthdate date,
    create_date date
);
GO

CREATE TABLE gold.dim_products(
    product_key int ,
    product_id int ,
    product_number nvarchar(50) ,
    product_name nvarchar(50) ,
    category_id nvarchar(50) ,
    category nvarchar(50) ,
    subcategory nvarchar(50) ,
    maintenance nvarchar(50) ,
    cost int,
    product_line nvarchar(50),
    start_date date
);
GO

CREATE TABLE gold.fact_sales(
    order_number nvarchar(50),
    product_key int,
    customer_key int,
    order_date date,
    shipping_date date,
    due_date date,
    sales_amount int,
    quantity tinyint,
    price int
);
GO

TRUNCATE TABLE gold.dim_customers;
GO

BULK INSERT gold.dim_customers
FROM '/Users/rachidez-ziani/Downloads/sql-data-analytics-project/01_datasets/dim_customers.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO

TRUNCATE TABLE gold.dim_products;
GO

BULK INSERT gold.dim_products
FROM '/Users/rachidez-ziani/Downloads/sql-data-analytics-project/01_datasets/dim_products.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO

TRUNCATE TABLE gold.fact_sales;
GO

BULK INSERT gold.fact_sales
FROM '/Users/rachidez-ziani/Downloads/sql-data-analytics-project/01_datasets/fact_sales.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO
