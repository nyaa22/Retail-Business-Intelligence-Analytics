-- ============================================================
-- E-Commerce Analytics | Database Schema and Analysis Queries
-- ============================================================

CREATE DATABASE ecommerce_analytics;
USE ecommerce_analytics;

-- ------------------------------------------------------------
-- Schema
-- ------------------------------------------------------------

CREATE TABLE Orders (
    Order_ID VARCHAR(20) PRIMARY KEY,
    Amount DECIMAL(10,2),
    Profit DECIMAL(10,2),
    Quantity INT,
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    PaymentMode VARCHAR(50)
);

CREATE TABLE Customers (
    Order_ID VARCHAR(20),
    Order_Date DATE,
    CustomerName VARCHAR(100),
    State VARCHAR(100),
    City VARCHAR(100),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID)
);

-- Order_Date was stored inconsistently in the source file, so it is
-- loaded as text first and parsed with STR_TO_DATE in the queries below.
ALTER TABLE Customers
MODIFY COLUMN Order_Date VARCHAR(20);

-- ------------------------------------------------------------
-- Sanity checks
-- ------------------------------------------------------------

SELECT * FROM Orders LIMIT 10;
SELECT * FROM Customers LIMIT 10;
SELECT COUNT(*) FROM Customers;

-- ------------------------------------------------------------
-- Headline metrics
-- ------------------------------------------------------------

-- Total sales, profit, orders, and quantity
SELECT
    SUM(Amount) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Quantity) AS Total_Quantity
FROM Orders;

-- Average Order Value
SELECT
    ROUND(SUM(Amount) / COUNT(DISTINCT Order_ID), 2) AS AOV
FROM Orders;

-- Profit margin
SELECT
    ROUND(SUM(Profit) / SUM(Amount) * 100, 2) AS Profit_Margin
FROM Orders;

-- ------------------------------------------------------------
-- Geography
-- ------------------------------------------------------------

-- Sales and profit by state
SELECT
    c.State,
    SUM(o.Amount) AS Total_Sales,
    SUM(o.Profit) AS Total_Profit
FROM Orders o
JOIN Customers c ON o.Order_ID = c.Order_ID
GROUP BY c.State
ORDER BY Total_Sales DESC;

-- Top 10 cities by sales
SELECT
    c.City,
    SUM(o.Amount) AS Total_Sales
FROM Orders o
JOIN Customers c ON o.Order_ID = c.Order_ID
GROUP BY c.City
ORDER BY Total_Sales DESC
LIMIT 10;

-- ------------------------------------------------------------
-- Product performance
-- ------------------------------------------------------------

-- Sales, profit, and quantity by category
SELECT
    Category,
    SUM(Amount) AS Sales,
    SUM(Profit) AS Profit,
    SUM(Quantity) AS Quantity_Sold
FROM Orders
GROUP BY Category
ORDER BY Sales DESC;

-- ------------------------------------------------------------
-- Customers
-- ------------------------------------------------------------

-- Top 10 customers by sales
SELECT
    c.CustomerName,
    SUM(o.Amount) AS Total_Sales
FROM Orders o
JOIN Customers c ON o.Order_ID = c.Order_ID
GROUP BY c.CustomerName
ORDER BY Total_Sales DESC
LIMIT 10;

-- ------------------------------------------------------------
-- Payments
-- ------------------------------------------------------------

-- Order volume and share by payment mode
SELECT
    PaymentMode,
    COUNT(*) AS Orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Orders), 2) AS Percentage
FROM Orders
GROUP BY PaymentMode
ORDER BY Orders DESC;

-- ------------------------------------------------------------
-- Seasonality
-- ------------------------------------------------------------

-- Monthly sales trend
SELECT
    MONTH(STR_TO_DATE(c.Order_Date, '%d-%m-%Y')) AS Month_No,
    MONTHNAME(STR_TO_DATE(c.Order_Date, '%d-%m-%Y')) AS Month_Name,
    SUM(o.Amount) AS Total_Sales
FROM Orders o
JOIN Customers c ON o.Order_ID = c.Order_ID
GROUP BY Month_No, Month_Name
ORDER BY Month_No;
