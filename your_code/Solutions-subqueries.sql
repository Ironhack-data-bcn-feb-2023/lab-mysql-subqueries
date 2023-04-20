
-- How many copies of the film Hunchback Impossible exist in the inventory system?
USE sakila;
SELECT film.title, COUNT(inventory_id) AS 'nr. of copies'
	FROM film
	LEFT JOIN inventory
		ON inventory.film_id = film.film_id
	WHERE title = 'Hunchback Impossible';
    
-- List all films whose length is longer than the average of all the films.
SELECT AVG(length) FROM film;

SELECT title, length
	FROM film
    WHERE length > 
		(SELECT AVG(length) FROM film)
    ORDER BY length ASC;
    
-- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT actor.first_name, actor.last_name
	FROM actor
	JOIN film_actor
		ON film_actor.actor_id = actor.actor_id
	JOIN film
		ON film.film_id = film_actor.film_id
			WHERE title =
			(SELECT title FROM film
				WHERE title = 'Alone Trip');
                
-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT title, category.name FROM film
	JOIN film_category
		ON film_category.film_id = film.film_id
	JOIN category
		ON category.category_id = film_category.category_id
			WHERE category.name =
				(SELECT name FROM category
				WHERE name = 'family');
                
-- Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
-- that will help you get the relevant information.
SELECT first_name, last_name, email, country
	FROM customer
    JOIN address
		ON address.address_id = customer.address_id
	JOIN city
		ON city.city_id = address.city_id
	JOIN country
		ON country.country_id = city.country_id
	WHERE country = 'Canada';
    

-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT film.title, film_actor.actor_id
	FROM film
    JOIN film_actor
		ON film_actor.film_id = film.film_id
			WHERE film_actor.actor_id =
				(SELECT actor.actor_id
					FROM actor
					JOIN film_actor
						ON film_actor.actor_id = actor.actor_id
					JOIN film
						ON film.film_id = film_actor.film_id
					GROUP BY actor.actor_id
					ORDER BY COUNT(film.film_id) DESC
					LIMIT 1);
               
               
-- Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT DISTINCT film.title, customer.customer_id
	FROM film
    JOIN inventory
		ON inventory.film_id = film.film_id
	JOIN staff
		ON staff.store_id = inventory.store_id
	JOIN payment
		ON payment.staff_id = staff.staff_id
	JOIN customer
		ON customer.customer_id = payment.customer_id
	WHERE payment.customer_id = (SELECT customer.customer_id
									FROM customer
									JOIN payment
										ON payment.customer_id = customer.customer_id
									GROUP BY customer_id
									ORDER BY SUM(amount) DESC
									LIMIT 1);
                                    
                                    
-- Get the client_id and the total_amount_spent of 
-- those clients who spent more than the average of the total_amount spent by each client. > missing this part ??
SELECT customer.customer_id, SUM(amount) AS 'total_spent'
	FROM customer
	JOIN payment
		ON payment.customer_id = customer.customer_id
	GROUP BY customer_id
	HAVING total_spent > AVG(total_spent)
    ORDER BY total_spent ASC;
