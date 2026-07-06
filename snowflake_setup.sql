/* ============================================================
   ENTERPRISE SALES DATA PLATFORM
   Snowflake Star Schema Setup Script
   ============================================================
   Bu skript quyidagilarni yaratadi:
   1. Database va Schema
   2. Star Schema jadvallari (3 dimension + 1 fact)
   3. Namuna ma'lumotlar (25 ta sotuv tranzaksiyasi)

   Ishga tushirish: Snowsight SQL Worksheet'da butun faylni
   belgilab (Ctrl+A), Ctrl+Enter bosing.
   ============================================================ */

-- ============================================================
-- 1. DATABASE VA SCHEMA
-- ============================================================
CREATE DATABASE IF NOT EXISTS SALES_DATA_PLATFORM;
USE DATABASE SALES_DATA_PLATFORM;

CREATE SCHEMA IF NOT EXISTS SALES_ANALYTICS;
USE SCHEMA SALES_ANALYTICS;

-- ============================================================
-- 2. DIMENSION JADVALLARI
-- ============================================================
CREATE OR REPLACE TABLE dim_product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2)
);

CREATE OR REPLACE TABLE dim_customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    region VARCHAR(50),
    country VARCHAR(50)
);

CREATE OR REPLACE TABLE dim_date (
    date_id INT PRIMARY KEY,
    full_date DATE,
    month VARCHAR(20),
    quarter INT,
    year INT
);

-- ============================================================
-- 3. FACT JADVAL
-- ============================================================
CREATE OR REPLACE TABLE fact_sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    date_id INT,
    quantity INT,
    total_amount DECIMAL(12,2)
);

-- ============================================================
-- 4. NAMUNA MA'LUMOTLAR
-- ============================================================

INSERT INTO dim_product (product_id, product_name, category, unit_price) VALUES
(1, 'Laptop Pro', 'Electronics', 1200.00),
(2, 'Wireless Mouse', 'Electronics', 25.00),
(3, 'Office Chair', 'Furniture', 150.00),
(4, 'Standing Desk', 'Furniture', 350.00),
(5, 'Monitor 27"', 'Electronics', 300.00),
(6, 'Keyboard Mechanical', 'Electronics', 80.00),
(7, 'Webcam HD', 'Electronics', 45.00),
(8, 'Bookshelf', 'Furniture', 120.00),
(9, 'Filing Cabinet', 'Furniture', 200.00),
(10, 'Desk Lamp', 'Furniture', 35.00);

INSERT INTO dim_customer (customer_id, customer_name, region, country) VALUES
(1, 'Acme Corp', 'Europe', 'Germany'),
(2, 'Global Tech', 'Asia', 'Japan'),
(3, 'Star Industries', 'North America', 'USA'),
(4, 'Delta Solutions', 'Europe', 'France'),
(5, 'Pacific Traders', 'Asia', 'Singapore'),
(6, 'Nordic Systems', 'Europe', 'Sweden'),
(7, 'Silverline Retail', 'North America', 'Canada'),
(8, 'Sunrise Traders', 'Asia', 'India'),
(9, 'Metro Supplies', 'Europe', 'UK'),
(10, 'Coastal Enterprises', 'North America', 'USA');

INSERT INTO dim_date (date_id, full_date, month, quarter, year) VALUES
(1, '2024-01-15', 'January', 1, 2024),
(2, '2024-02-20', 'February', 1, 2024),
(3, '2024-03-10', 'March', 1, 2024),
(4, '2024-04-05', 'April', 2, 2024),
(5, '2024-05-18', 'May', 2, 2024),
(6, '2024-06-10', 'June', 2, 2024),
(7, '2024-07-22', 'July', 3, 2024),
(8, '2024-08-15', 'August', 3, 2024),
(9, '2024-09-05', 'September', 3, 2024),
(10, '2024-10-18', 'October', 4, 2024);

INSERT INTO fact_sales (sale_id, product_id, customer_id, date_id, quantity, total_amount) VALUES
(1, 1, 1, 1, 2, 2400.00),
(2, 2, 2, 1, 10, 250.00),
(3, 3, 3, 2, 5, 750.00),
(4, 4, 1, 2, 3, 1050.00),
(5, 5, 4, 3, 4, 1200.00),
(6, 1, 5, 3, 1, 1200.00),
(7, 2, 3, 4, 15, 375.00),
(8, 3, 2, 4, 2, 300.00),
(9, 5, 1, 5, 6, 1800.00),
(10, 4, 4, 5, 2, 700.00),
(11, 6, 6, 6, 8, 640.00),
(12, 7, 7, 6, 12, 540.00),
(13, 8, 8, 7, 3, 360.00),
(14, 9, 9, 7, 2, 400.00),
(15, 10, 10, 8, 20, 700.00),
(16, 1, 2, 8, 1, 1200.00),
(17, 2, 6, 9, 25, 625.00),
(18, 3, 7, 9, 4, 600.00),
(19, 6, 8, 10, 6, 480.00),
(20, 9, 10, 10, 3, 600.00),
(21, 1, 3, 6, 3, 3600.00),
(22, 5, 5, 7, 2, 600.00),
(23, 4, 9, 8, 1, 350.00),
(24, 7, 1, 9, 10, 450.00),
(25, 10, 4, 10, 15, 525.00);

-- ============================================================
-- 5. TEKSHIRISH
-- ============================================================
SELECT 'dim_product' AS table_name, COUNT(*) AS row_count FROM dim_product
UNION ALL
SELECT 'dim_customer', COUNT(*) FROM dim_customer
UNION ALL
SELECT 'dim_date', COUNT(*) FROM dim_date
UNION ALL
SELECT 'fact_sales', COUNT(*) FROM fact_sales;
