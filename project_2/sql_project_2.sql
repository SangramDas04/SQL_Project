create database pizzahut;
use pizzahut;

create table orders(
	order_id int not null primary key,
    order_date date not null,
    order_time time not null
);

create table order_details(
	order_details_id int not null primary key,
    order_id int not null,
    pizza_id text not null,
    quantity int not null
);

select * from pizzas;			# pizza_type_id common col
select * from pizza_types;		# pizza_type_id common col
select * from orders;         # order_id common col
select * from order_details;  # order_id common col


-- Q1. Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;

-- Q2. Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(od.quantity * p.price), 2)
FROM
    order_details AS od
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id;

-- Q3. Identify the highest-priced pizza.
SELECT 
    name, price
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
WHERE
    price = (SELECT 
            MAX(price)
        FROM
            pizzas);

-- OR

SELECT 
    pt.name, p.price
FROM
    pizzas AS p
        JOIN
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
ORDER BY price DESC
LIMIT 1;


-- Q4. Identify the most common pizza size ordered.
select p.size as pizza_size,count(od.quantity) as no_of_orders 
from order_details as od
join pizzas as p
on od.pizza_id = p.pizza_id
group by pizza_size
order by no_of_orders desc
limit 1;



-- Q5. List the top 5 most ordered pizza types along with their quantities.
select p.pizza_type_id,sum(od.quantity) as quantity_ordered
from order_details as od
join pizzas as p
on p.pizza_id = od.pizza_id
group by p.pizza_type_id
order by quantity_ordered desc
limit 5;

-- OR

select pt.name,pt.pizza_type_id,sum(od.quantity) as quantity
from order_details as od
join pizzas as p
on od.pizza_id = p.pizza_id
join pizza_types as pt
on pt.pizza_type_id = p.pizza_type_id
group by pt.name,pt.pizza_type_id
order by quantity desc
limit 5;
  

-- Q6. Join the necessary tables to find the total quantity of each pizza category ordered.
select pt.category as category,sum(od.quantity) as quantity from Order_details as od 
join pizzas as p
on od.pizza_id = p.pizza_id
join pizza_types as pt
on p.pizza_type_id = pt.pizza_type_id
group by category
order by quantity desc;

-- Q7. Determine the distribution of orders by hour of the day.
select hour(order_time) as hour,count(order_id) as order_count
from orders
group by hour;

-- Q8. Join relevant tables to find the category-wise distribution of pizzas.
select category,count(name) 
from pizza_types
group by category;



-- category wise total orders
select category,count(o.order_id) 
from pizza_types as pt
join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
join order_details as od
on p.pizza_id = od.pizza_id
join orders as o
on od.order_id = o.order_id
group by category;

-- category wise total quantity sold
select category,sum(od.quantity) 
from pizza_types as pt
join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
join order_details as od
on p.pizza_id = od.pizza_id
join orders as o
on od.order_id = o.order_id
group by category;


-- Q9. Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity_sold),0) 
from (select order_date as date,sum(quantity) as quantity_sold
from orders as o
join order_details as od
on o.order_id = od.order_id
group by date) as order_quantity;


-- Q10. Determine the top 3 most ordered pizza types based on revenue.
select pt.name,p.pizza_type_id,round(sum(od.quantity * p.price),2) as revenue
from order_details as od
join pizzas as p
on od.pizza_id = p.pizza_id
join pizza_types as pt
on p.pizza_type_id = pt.pizza_type_id
group by pt.name,p.pizza_type_id
order by revenue desc
limit 3;

-- Q11. Calculate the percentage contribution of each pizza type to total revenue.
select pt.category,round(sum(od.quantity * p.price) / (select sum(od.quantity * p.price) 
as total_sales 
from order_details as od
join pizzas as p on od.pizza_id = p.pizza_id) * 100,2) as revenue
from order_details as od
join pizzas as p
on od.pizza_id = p.pizza_id
join pizza_types as pt
on p.pizza_type_id = pt.pizza_type_id
group by pt.category
order by revenue desc;

-- Q12. Analyze the cumulative revenue generated over time.
select order_date,sum(revenue) over(order by order_date) as cumulative_revenue
from
(select o.order_date,round(sum(od.quantity * p.price),2) as revenue
from order_details as od
join pizzas as p
on od.pizza_id = p.pizza_id
join orders as o
on o.order_id = od.order_id
group by o.order_date) as sales;

-- Q13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select category,name,revenue 
from
(select category,name,revenue,
rank() over(partition by category order by revenue desc) as "rn"
from
(select pt.category,pt.name,round(sum(od.quantity * p.price),2) as revenue
from order_details as od
join pizzas as p
on od.pizza_id = p.pizza_id
join pizza_types as pt
on p.pizza_type_id = pt.pizza_type_id
group by pt.category,pt.name) as a) as b
where rn <= 3;


