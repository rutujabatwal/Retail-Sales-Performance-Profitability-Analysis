-- Creating database --

create database retail_sales;

select * from retail_sales_cleaned_for_sql;

alter table retail_sales_cleaned_for_sql rename to sales_data;
select * from sales_data 
limit 5;

describe sales_data;

alter table sales_data
modify region varchar(50);

alter table sales_data
modify state varchar(50);

alter table sales_data
modify category varchar(50);

alter table sales_data
modify product varchar(50);

SET SQL_SAFE_UPDATES = 0;
UPDATE sales_data
set Order_Date = STR_TO_DATE(Order_Date, '%d-%m-%Y');

alter table sales_data
modify order_date date;

alter table sales_data
modify cost_price float;

alter table sales_data
modify selling_price float;

alter table sales_data
modify final_price float;

alter table sales_data
modify profit float;

alter table sales_data
modify revenue float;

alter table sales_data
modify profit_margin float;

-- -----------------------------------------------------------------------
-- Monthly Sales Trend
-- Q.1) How are sales performing month-over-month?

SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    round(SUM(revenue), 2) AS total_revenue
FROM sales_data
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;

-- Top Revenue-Generating Categories
-- Q.2) Which product categories generate the most revenue?

select category, round(sum(revenue), 2) as Total_revenue 
from sales_data
group by category 
order by Total_revenue desc;


-- Most Profitable Categories
-- Q.3) Which categories are actually profitable, not just selling more?

select category, sum(profit) as total_profit,
ROUND(SUM(profit) / SUM(revenue) * 100, 2) AS profit_margin
from sales_data
group by category
order by profit_margin desc;

-- Region-Wise Performance
-- Q.4) Which regions perform best and which underperform?

SELECT
    region,
    SUM(revenue) AS total_revenue,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY region
ORDER BY total_profit DESC;


-- State-Level Sales Analysis
-- Q.5) Which states contribute most to revenue within each region?

SELECT
    region,
    state,
    SUM(revenue) AS total_revenue
FROM sales_data
GROUP BY region, state
ORDER BY region, total_revenue DESC;

-- Discount Impact on Profit
-- Q.6) Are higher discounts hurting profitability?

SELECT
    discount_percentage,
    COUNT(*) AS total_orders,
    ROUND(AVG(profit), 2) AS avg_profit
FROM sales_data
GROUP BY discount_percentage
ORDER BY discount_percentage desc;


-- High-Discount, Low-Profit Products
-- Q.7) Which products should we stop discounting heavily?

select discount_percentage, product, 
category, round(sum(profit), 2) as total_profit
from sales_data 
group by product, Discount_Percentage, category
having total_profit < 0 
order by total_profit;

-- Underperforming Products
-- Q.8) Which products generate low revenue and low profit?

select product, round(sum(revenue), 2) as total_revenue,
round(sum(profit), 2) as total_profit
from sales_data 
group by product
order by total_profit asc;

-- Average Order Value (AOV)
-- Q.9) What is the average value of a customer order?

SELECT
    ROUND(AVG(revenue), 2) AS avg_order_value
FROM sales_data;

-- ---------------------------------------------------------

-- Year-Over-Year Growth
-- Q.10) Is the business growing year over year?

select  year(order_date) as years, round(sum(profit), 2)
from sales_data
group by years
order by years asc;

-- Category Performance by Region
-- Q.11) Which categories work best in which regions?

select region, category, round(sum(revenue), 2) as total_revenue
from sales_data
group by region, category
ORDER BY region, total_revenue DESC;


select sum(revenue) from sales_data
