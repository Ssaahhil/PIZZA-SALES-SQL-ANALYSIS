-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price)
            / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                0) AS total_sales
                FROM
                    order_details
                        JOIN
                    pizzas ON order_details.pizza_id = pizzas.pizza_id
                ) * 100,
            2) AS Revenue
            
FROM
    pizzas
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
    JOIN 
    order_details
    ON
    order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category;

-- Analyze the cumulative revenue generated over time.
SELECT order_date,SUM(Revenue) over(ORDER BY order_date) as cum_Revenue FROM
(SELECT orders.order_date,ROUND(SUM(order_details.quantity * pizzas.price),0) AS Revenue
FROM order_details
JOIN orders
ON order_details.order_id = orders.order_id
JOIN pizzas
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY order_date) AS Sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT name, category, revenue FROM
(SELECT name, category, Revenue, 
rank() over(PARTITION BY category ORDER BY Revenue DESC) AS R
FROM
(SELECT pizza_types.name, pizza_types.category, sum(order_details.quantity * pizzas.price) AS Revenue
FROM pizzas
JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
JOIN pizza_types
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY name , category
ORDER BY category ,Revenue DESC) AS Q) AS P
WHERE R <= 3;