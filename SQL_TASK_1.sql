--task1

SELECT 	c.name,count(fc.film_id)
FROM 	film_category fc
JOIN 	category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY count(fc.film_id) DESC 

--task2

SELECT 	a.first_name,
		a.last_name,
		count(r.rental_id) AS r_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id 
JOIN inventory i ON f.film_id = i.film_id 
JOIN rental r ON i.inventory_id = r.inventory_id 
GROUP BY a.first_name, a.last_name 
ORDER BY r_count  DESC 
LIMIT 10 

--task3

SELECT 	c.name,
		sum(p.amount) AS revenue
FROM category c 
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id 
JOIN inventory i ON f.film_id = i.film_id 
JOIN rental r ON i.inventory_id = r.inventory_id 
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name 
ORDER BY revenue DESC 

--task4

SELECT f.title
FROM film f 
WHERE NOT EXISTS (
	SELECT * 
	FROM inventory i 
	WHERE f.film_id = i.film_id 
)

--task5

SELECT first_name, last_name, appearance_count
FROM (
  SELECT a.first_name, a.last_name, COUNT(*) AS appearance_count,
         RANK() OVER (ORDER BY COUNT(*) DESC) AS num_rank
  FROM actor AS a
  JOIN film_actor fa ON a.actor_id = fa.actor_id
  JOIN film f ON fa.film_id = f.film_id
  JOIN film_category fc ON f.film_id = fc.film_id
  JOIN category c ON fc.category_id = c.category_id
  WHERE c.name = 'Children'
  GROUP BY a.actor_id
) AS t1
WHERE num_rank <= 3

--task6

SELECT c.city, SUM(CASE WHEN cus.active=1 THEN 1 ELSE 0 END) AS active, SUM(CASE WHEN cus.active=0 THEN 1 ELSE 0 END) AS non_active
FROM customer AS cus
JOIN address AS a ON a.address_id=cus.address_id
JOIN city AS c ON c.city_id=a.city_id
GROUP BY c.city
ORDER BY non_active DESC;

--task7

WITH t1 AS (SELECT cat.name, SUM(f.rental_duration) AS total, c.city
FROM category cat
JOIN film_category fc ON cat.category_id=fc.category_id
JOIN film f ON f.film_id=fc.film_id
JOIN inventory i ON i.film_id=f.film_id
JOIN rental r ON r.inventory_id=i.inventory_id
JOIN customer cus ON cus.customer_id=r.customer_id
JOIN address a ON a.address_id=cus.address_id
JOIN city c ON c.city_id=a.city_id
GROUP BY cat.name, c.city
ORDER BY SUM(f.rental_duration) DESC)
(SELECT *
FROM t1 
WHERE city LIKE 'A%')
UNION 
(SELECT *
FROM t1 
WHERE city LIKE '%-%')