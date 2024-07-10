CREATE DATABASE IF NOT EXISTS sabaro;

USE sabaro;

SELECT * FROM order_details;
SELECT * FROM orders;
SELECT * FROM pizza_types;
SELECT * FROM pizzas;
-- Retrieve the total number of orders placed.
SELECT Count(order_id) FROM orders;

-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price))
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;
    
-- Identify the highest-priced pizza.
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- Identify the most common pizza size ordered.
SELECT pizzas.size,COUNT(pizzas.size)
FROM
order_details
JOIN 
pizzas
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY COUNT(pizzas.size) DESC LIMIT 1;

-- List the top 5 most ordered pizza types along with their quantities.
SELECT pizza_types.name, SUM(order_details.quantity)
FROM pizza_types 
JOIN 
pizzas
ON 
pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN 
order_details
ON 
order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.namex
ORDER BY SUM(order_details.quantity) DESC LIMIT 5;