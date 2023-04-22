-- SQL Subqueries
USE sakila;
-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT film.title  AS `TITLE`, COUNT(inventory.film_id) AS `AMOUNT` FROM film, inventory
WHERE film.title = "Hunchback Impossible"
AND film.film_id = inventory.film_id;

-- 2. List all films whose length is longer than the average of all the films.
SELECT film.title AS `TITLE`, film.length AS `LENGTH` FROM film
WHERE film.length > (SELECT AVG(length) FROM film)
ORDER BY `LENGTH` DESC;

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT actor.first_name AS `FIRST NAME`, actor.last_name `LAST NAME`, film.title AS `TITLE` FROM actor, film, film_actor
WHERE actor.actor_id = film_actor.actor_id
AND film_actor.film_id = film.film_id
AND film.title = "Alone Trip";

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.
SELECT film.film_id AS `ID`, film.title AS `TITLE`, category.name AS `CATEGORY` FROM category, film, film_category
WHERE category.category_id = film_category.category_id
AND film_category.film_id = film.film_id
AND category.name = "Family";

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins.
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys,
-- that will help you get the relevant information.
SELECT customer.first_name AS `FIRST NAME`, customer.last_name AS `LAST NAME`, customer.email AS `EMAIL` FROM address, city, country, customer
WHERE customer.address_id = address.address_id
AND address.city_id = city.city_id
AND city.country_id = country.country_id
AND country.country = "Canada";

-- 6. Which are films starred by the most prolific actor?
-- Most prolific actor is defined as the actor that has acted in the most number of films.
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT film.title AS `TITLE`, CONCAT(actor.first_name, ' ',actor.last_name) AS `NAME` FROM film, film_actor, actor
WHERE film.film_id = film_actor.film_id
AND film_actor.actor_id = actor.actor_id
AND actor.actor_id = (
    SELECT actor_id FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(*) DESC LIMIT 1
);

-- 7. Films rented by most profitable customer.
-- You can use the customer table and payment table to find the most profitable
-- customer is the customer that has made the largest sum of payments.
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS `NAME`, film.title AS `FILM` FROM customer, payment, rental, inventory, film
WHERE customer.customer_id = payment.customer_id
AND payment.rental_id = rental.rental_id
AND rental.inventory_id = inventory.inventory_id
AND inventory.film_id = film.film_id
AND customer.customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
);

-- 8. Get the client_id and the total_amount_spent of those clients who spent
-- more than the average of the total_amount spent by each client.
SELECT customer_id AS `CLIENT`, SUM(amount) AS `SPENT` FROM payment
GROUP BY `CLIENT`
HAVING SUM(amount) > (
	SELECT AVG(total_amount_spent) FROM (SELECT SUM(amount) AS total_amount_spent FROM payment GROUP BY customer_id) AS t)
ORDER BY `SPENT` DESC;