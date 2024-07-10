-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    SUM(order_details.quantity), pizza_types.category
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.category
ORDER BY SUM(order_details.quantity) DESC;

-- Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(orders.order_time), COUNT(order_id)
FROM
    orders
GROUP BY HOUR(orders.order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT pizza_types.category, COUNT(pizza_types.name)
FROM pizza_types
GROUP BY category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT AVG(quantity) FROM
(SELECT orders.order_date, SUM(order_details.quantity) AS quantity 
FROM orders
JOIN order_details
ON order_details.order_id = orders.order_id
GROUP BY order_date) AS order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pizza_types.name,
    ROUND(SUM(order_details.quantity * pizzas.price),
            0) AS revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.name
ORDER BY (SUM(order_details.quantity * pizzas.price)) DESC
LIMIT 3;
