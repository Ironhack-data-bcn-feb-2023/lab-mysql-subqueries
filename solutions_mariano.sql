-- Answer 1: 6 copies
USE sakila;
SELECT COUNT(inventory_id)
FROM inventory
WHERE film_id = (
	SELECT film_id
	FROM film
	WHERE title = 'Hunchback Impossible');

-- Answer 2:
USE sakila;
SELECT title, length
FROM film
WHERE length > (
	SELECT avg(length)
	FROM film
	WHERE title IS NOT NULL)
ORDER BY 2 DESC;

-- Answer 3:
USE sakila;
SELECT *
FROM actor
WHERE actor_id in (
	SELECT actor_id
	FROM film_actor
	WHERE film_id = (
		SELECT film_id
		FROM film
		WHERE title = 'Alone Trip'));
        
-- Answer 4:
USE sakila;
SELECT title
FROM film
WHERE film_id IN (
	SELECT film_id
	FROM film_category
	WHERE category_id = 
		(SELECT category_id
		FROM category
		WHERE name = 'Family'));
        
-- Answer 5:
-- A) USING SUBQUERY:
USE sakila;
SELECT first_name, email
FROM customer
WHERE address_id IN (
	SELECT address_id
	FROM address
	WHERE city_id IN (
		SELECT city_id
		FROM city
		WHERE country_id = 
			(SELECT country_id
			FROM country
			WHERE country = 'Canada')));
            
-- B) USING JOINS:
USE sakila;
SELECT 
	c.first_name,
    c.email
FROM country co
	LEFT JOIN city ci
	ON co.country_id = ci.country_id
	LEFT JOIN address a
	ON a.city_id = ci.city_id
    LEFT JOIN customer c
	ON c.address_id = a.address_id
WHERE co.country = 'Canada'
AND c.first_name IS NOT NULL;

-- Answer 6:
USE sakila;
SELECT title
FROM film
WHERE film_id IN
	(SELECT film_id
	FROM film_actor
	WHERE actor_id = 
		(SELECT actor_id
		FROM (
			SELECT actor_id, max(num_films)
			FROM (
				SELECT actor_id, count(film_id) AS num_films
				FROM film_actor
				GROUP BY 1
				ORDER BY 2 DESC) as films_acted) AS max_actor));
                
-- Answer 7:
USE sakila;
SELECT title
FROM film
WHERE film_id IN (
	SELECT film_id
		FROM inventory
		WHERE inventory_id IN (
		SELECT inventory_id
			FROM rental
			WHERE customer_id = (
			SELECT customer_id
				FROM (
					SELECT customer_id, max(sum_amount)
					FROM (
						SELECT customer_id, sum(amount) AS sum_amount
						FROM payment
						GROUP BY 1
						ORDER BY 2 DESC) as payment_sum) AS max_customer)));
                        
-- Answer 8:
USE sakila;
SELECT 
	customer_id, 
    sum(amount) AS total_amount_spent
FROM payment
GROUP BY 1
HAVING total_amount_spent > (
	SELECT avg(total_amount) as total_average
	FROM (
		SELECT customer_id, sum(amount) AS total_amount
		FROM payment
		GROUP BY 1
		ORDER BY 2 DESC) AS sum_amount)
ORDER BY 2 DESC;