create database if not exists walmart;
use walmart;
create table if not exists sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

select * from sales;
select time from sales;

-- time_of_day -----------------------------
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);


-- day_name ------------------------------
select date,dayname(date) as day_name from sales;

alter table sales 
add column day_name varchar(20);

update sales
set day_name = dayname(date);
 
-- month_name ---------------------
select date, monthname(date) from sales;

alter table sales
add column month_name varchar(50);

update sales
set month_name = monthname(date);

---------------------------- Product -----------------------------------------
------------------------------------------------------------------------------

-- Q1. How many unique cities does the data have? ----------------------------
select distinct(city) from sales;

-- Q2. In which city is each branch? -----------------------------------------
select distinct(branch),city from sales;
#OR
select distinct(city),branch from sales;

-- Q3. How many unique product lines does the data have? ---------------------
select count(distinct(product_line)) as unique_product_lines from sales;

-- Q4. What is the most common payment method? -------------------------------
select payment,count(total)
from sales
group by payment
order by count(total) desc
limit 1;

-- Q5. What is the most selling product line? --------------------------------
select product_line,sum(quantity) as quantity_sold 
from sales
group by product_line
order by quantity_sold desc
limit 1;

-- Q6. What is the total revenue by month? -----------------------------------
select monthname(date) as month,sum(total) as revenue
from sales
group by month
order by revenue desc;

-- Q7. What month had the largest COGS? --------------------------------------
select monthname(date) as month, sum(cogs) as cogs
from sales
group by month
order by cogs desc
limit 1;

-- Q8. What product line had the largest revenue? ----------------------------
select * from sales;
select product_line, sum(total) as revenue
from sales
group by product_line
order by revenue desc
limit 1;

-- Q9. What is the city with the largest revenue? ----------------------------
select city,branch,sum(total) as revenue
from sales
group by city,branch
order by revenue desc
limit 1;

-- Q10. What product line had the largest VAT(value added tax)? -------------------------------
select product_line,avg(tax_pct) as avg_vat 
from sales
group by product_line
order by avg_vat desc
limit 1;

-- Q11. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales -------------------
SELECT 
	round(AVG(quantity),2) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN round(AVG(quantity),2) > (SELECT round(AVG(quantity),2) AS avg_qnty FROM sales) THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

-- Q12. Which branch sold more products than average product sold? --------------------------------------------------
select branch,sum(quantity) as qty_sold
from sales
group by branch
having qty_sold > (select avg(quantity) from sales);

-- Q13. What is the most common product line by gender? -------------------------------------------------------------
select gender,product_line,count(gender) as tot_count
from sales
group by gender,product_line
order by tot_count desc; 

-- Q14. What is the average rating of each product line? ------------------------------------------------------------ 
select product_line,round(avg(rating),2) as avg_rating
from sales
group by product_line
order by avg_rating desc;

-------------------------------------------- Sales -----------------------------------------
--------------------------------------------------------------------------------------------

-- Q1. Number of sales made in each time of the day per weekday ----------------------------
select time_of_day,count(*) as total_sales
from sales
where day_name = "Monday"
group by time_of_day
order by total_sales desc;

-- Q2. Which of the customer types brings the most revenue? --------------------------------
select customer_type,round(sum(total),2) as revenue 
from sales
group by customer_type
order by revenue desc;

-- Q3. Which city has the largest tax percent/ VAT (Value Added Tax)? ----------------------
select city,avg(tax_pct) as vat
from sales
group by city
order by vat desc
limit 1;

-- Q4. Which customer type pays the most in VAT?
select customer_type,avg(tax_pct) as vat
from sales
group by customer_type
order by vat desc
limit 1;


------------------------------------------ Customers ----------------------------------------
---------------------------------------------------------------------------------------------
-- Q1. How many unique customer types does the data have? -----------------------------------
select customer_type, count(*) as count
from sales
group by customer_type;

-- OR

SELECT DISTINCT(CUSTOMER_TYPE) FROM SALES;

-- Q2. How many unique payment methods does the data have? ----------------------------------
select payment, count(*) as count
from sales
group by payment;

-- OR

SELECT DISTINCT(payment) FROM SALES;
  
-- Q3. What is the most common customer type? -----------------------------------------------
select customer_type, count(*) as count
from sales
group by customer_type
order by count desc;

-- Q4. Which customer type buys the most? ---------------------------------------------------
select customer_type,count(*) as count
from sales
group by customer_type
order by  count desc;

-- Q5. What is the gender of most of the customers? -----------------------------------------
select gender, count(*) as count
from sales
group by gender
order by count desc;

-- Q6. What is the gender distribution per branch? ------------------------------------------
select gender,count(*) as gender_count
from sales
where branch = "A"
group by gender;

-- Q7. Which time of the day do customers give most ratings? -------------------------------- 
select time_of_day,avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating desc;

-- Q8. Which time of the day do customers give most ratings per branch? ---------------------
select time_of_day,avg(rating) as avg_rating
from sales
where branch = "A"
group by time_of_day
order by avg_rating desc;

-- Q9. Which day of the week has the best avg ratings? --------------------------------------
select * from sales;
select day_name,avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc
limit 1; 

-- Q10. Which day of the week has the best average ratings per branch? ----------------------
select * from sales;
select day_name,avg(rating) as avg_rating
from sales
where branch = "C"
group by day_name
order by avg_rating desc
limit 1; 


 


 










