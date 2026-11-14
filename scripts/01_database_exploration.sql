/*
===============================================================================
Database Exploration
===============================================================================
Script Purpose:
    This script explores the database structure and retrieves metadata about
    the available tables and columns.

    It uses INFORMATION_SCHEMA views to identify table names, column names,
    data types, nullability, and maximum column lengths.

Main Operations:
    - Retrieve all available tables.
    - Explore table structures and column definitions.
    - Identify column data types and properties.
    - Inspect database metadata.

Key SQL Concepts:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- DATABASE EXPLORATION
-- All objects in the Database
SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- Explore all columns in the Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS;

-- Explore only columns from table dim_customers
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'gold_dim_customers';
