#Q.1
SELECT 
    COUNT(order_id)
FROM
    orders;


#Q.2
SELECT 
    SUM(o.quantity * p.price) AS revenue
FROM
    order_details o
        JOIN
    pizzas p ON o.pizza_id = p.pizza_id;


#Q.3
SELECT 
    MAX(price)
FROM
    pizzas;


#Q.4
SELECT 
     p.size, SUM(o.quantity) AS total_times_ordered
 FROM
     order_details o
         JOIN
     pizzas p ON o.pizza_id = p.pizza_id;
     

#Q.5
SELECT 
     pizza_types.name, SUM(o.quantity) AS total_ordered
 FROM
     order_details o
         JOIN
     pizzas p ON o.pizza_id = p.pizza_id
         JOIN
     pizza_types ON p.pizza_type_id = pizza_types.pizza_type_id
 GROUP BY pizza_types.name
 ORDER BY total_times_ordered DESC
 LIMIT 5;


#Q.6
SELECT 
     pt.category, SUM(o.quantity) AS total_ordered
 FROM
     order_details o
         JOIN
     pizzas p ON o.pizza_id = p.pizza_id
         JOIN
     pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
 GROUP BY pt.category
 ORDER BY total_ordered DESC;


#Q.7
SELECT 
     HOUR(time) AS hour_of_the_day,
     COUNT(order_id) AS total_orders
 FROM
     orders
 GROUP BY hour_of_the_day
 ORDER BY hour_of_the_day;


#Q.8
SELECT 
     pt.category, AVG(p.price) AS avg_price
 FROM
     pizzas p
         JOIN
     pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
 GROUP BY pt.category;
 

#Q.9
SELECT 
     date, AVG(total_pizzas) AS avg_pizzas_per_day
 FROM
     (SELECT 
         date, SUM(quantity) AS total_pizzas
     FROM
         orders o
     JOIN order_details od ON o.order_id = od.order_id
     GROUP BY date) AS daily_orders
 GROUP BY date;


#Q.10
SELECT 
     pt.name, SUM(o.quantity * p.price) AS revenue
 FROM
     order_details o
         JOIN
     pizzas p ON o.pizza_id = p.pizza_id
         JOIN
     pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
 GROUP BY pt.name
 order by revenue desc 
 limit 3;


#Q.11
SELECT 
     t.name, SUM(p.price * o.quantity) as revenue, round(SUM(p.price * o.quantity)/817860.05*100,2) as per
 FROM
   order_details AS o
          JOIN
      pizzas AS p ON o.pizza_id = p.pizza_id
          JOIN
      pizza_types AS t ON p.pizza_type_id = t.pizza_type_id
  GROUP BY t.name
  ORDER BY per DESC;


#Q.12
select monthname(o.date) as month,
 round(sum(p.price*od.quantity),2) as revenue,
 round(sum(sum(p.price*od.quantity)) over (order by min(o.date)),2) as Cumulative_revenue
 from orders o 
 join order_details od on o.order_id = od.order_id 
 join pizzas p on od.pizza_id = p.pizza_id group by month;


#Q.13
WITH ranked_pizzas AS (
     SELECT *,
            ROW_NUMBER() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS ranking
     FROM (
         SELECT p.pizza_id, pt.name, pt.category, p.price, 
                SUM(od.quantity) AS total_quantity,
                SUM(od.quantity * p.price) AS total_revenue
         FROM pizzas p
         JOIN order_details od ON p.pizza_id = od.pizza_id
         join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
         GROUP BY p.pizza_id, pt.name, pt.category, p.price
     ) AS pizza_revenue
 )
 SELECT category, name, total_quantity, total_revenue
 FROM ranked_pizzas
 WHERE ranking <= 3;