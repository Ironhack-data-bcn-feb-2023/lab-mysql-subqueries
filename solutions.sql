USE sakila;
.
-- 1. How many copies of hunchback impossible do we have:
SELECT COUNT(inventory_id)
FROM inventory
WHERE film_id = (
	SELECT film_id
	FROM film
	WHERE title = 'HUNCHBACK IMPOSSIBLE');
    
-- 2. List all films whose length is longer than the average of all the films.

SELECT title
FROM film
WHERE length > (
	SELECT AVG(length)
	FROM film);
    
-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name
	,last_name
FROM actor
WHERE 
	actor_id IN (SELECT actor_id
				 FROM film_actor
				 WHERE film_id = (
					SELECT film_id
					FROM film
					WHERE title = 'ALONE TRIP'));
                    
-- 4.  Identify all movies categorized as family films.
SELECT title
FROM film
WHERE film_id IN (
	SELECT film_id
	FROM film_category
	WHERE category_id = (
		SELECT category_id
		FROM category
		WHERE name = 'Family'));
        
-- 5.Get name and email from customers from Canada using subqueries.
SELECT first_name
	,last_name
	,email
FROM customer
WHERE address_id IN (
	SELECT address_id
	FROM address
	WHERE city_id IN (
		SELECT city_id
		FROM city	
		WHERE country_id = (    
			SELECT country_id
			FROM country
			WHERE country = 'Canada')));

-- 6.Which are films starred by the most prolific actor (actor that has acted in the most number of films)?
SELECT title
FROM film
RIGHT JOIN (
	SELECT film_id
	FROM film_actor
	WHERE actor_id = 
		(SELECT actor_id
		FROM (
			SELECT count(film_id)
				,actor_id
			FROM film_actor
			GROUP BY 2
			ORDER BY 1 DESC
			LIMIT 1) AS most_prolific_actor)) AS t_final ON film.film_id = t_final.film_id;

-- 7. Films rented by most profitable customer (customer that has made the largest sum of payments)
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
				SELECT customer_id
					,SUM(amount)
				FROM payment
				GROUP BY 1
				ORDER BY 2 DESC
				LIMIT 1) AS most_prof_cus)));
                
-- 8.Get the client_id and the total_amount_spent of those clients 
-- who spent more than the average of the total_amount spent by each client.

SELECT customer_id
	,SUM(amount) AS total_spent_2
FROM payment
GROUP BY 1
HAVING total_spent_2 > (
	SELECT AVG(total_spent_1) AS avg_total_spent
	FROM (
		SELECT customer_id
			,SUM(amount) AS total_spent_1
		FROM payment
		GROUP BY 1
		ORDER BY 2 DESC) AS cust_tot_spent)


