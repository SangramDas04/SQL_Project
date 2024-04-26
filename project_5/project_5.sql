use [Pizza DB]

select * from pizza_sales

--A.KPI's
--Total Revenue:
select sum(total_price) as Total_Revenue from pizza_sales;

--Average Order Value:
select sum(total_price)/count(distinct order_id) as avg_order_value
from pizza_sales;

--Total Pizzas Sold
select sum(quantity) as Total_Pizza_Sold from pizza_sales;

--Total Orders
select count(distinct order_id) as Total_orders from pizza_sales;

--Average Pizzas Per Order
select cast(cast(sum(quantity) as decimal(10,2))/
cast(count(distinct order_id) as decimal(10,2)) as decimal(10,2)) as avg_pizzas_per_order
from pizza_sales; 

--B.Charts Requirement
--Daily Trend for Total Orders
select DATENAME(DW,order_date) as order_day,count(DISTINCT order_id) as Total_orders
from pizza_sales
group by DATENAME(DW,order_date);

--Hourly Trend for Total Orders
select Datepart(Hour,order_time) as order_hours,count(distinct order_id) as Total_orders
from pizza_sales
group by Datepart(Hour,order_time)
order by Datepart(Hour,order_time); 

--Percentage of sales by Pizza Category
select pizza_category,sum(total_price) as total_sales ,(SUM(total_price) * 100/(select sum(total_price) from pizza_sales)) as sales_pct
from pizza_sales
group by pizza_category
order by pizza_category;

--applying filters i.e. for January month we're trying to extract the data 
select pizza_category,sum(total_price) as total_sales,
(SUM(total_price) * 100/(select sum(total_price) from pizza_sales where MONTH(order_date) = 1)) as sales_pct
from pizza_sales
where MONTH(order_date) = 1
group by pizza_category
order by pizza_category;

--Percentage of sales by Pizza Size
select pizza_size, sum(total_price) as total_sales, round((sum(total_price) * 100)/(select sum(total_price) from pizza_sales),2) as PCT
from pizza_sales
group by pizza_size
ORDER BY pizza_size;
--OR
SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size;

--Total Pizzas Sold by Pizza Category
select pizza_category,sum(quantity)
from pizza_sales
group by pizza_category;

--Top 5 Best Sellers by Total Pizzas Sold
select TOP 5 pizza_name,sum(quantity) as qty_sold
from pizza_sales
group by pizza_name
order by qty_sold desc;

--Bottom 5 Best Sellers by Total Pizzas Sold
select TOP 5 pizza_name,sum(quantity) as qty_sold
from pizza_sales
group by pizza_name
order by qty_sold;

