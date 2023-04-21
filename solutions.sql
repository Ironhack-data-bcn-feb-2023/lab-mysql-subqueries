USE sakila;

-- Query 1:
SELECT COUNT(film_id) FROM inventory WHERE film_id in
(SELECT film_id FROM film WHERE title = "Hunchback Impossible")
ORDER BY film_id;

-- Query 2:
SELECT film_id, title FROM film WHERE length >
(SELECT AVG(length) AS avg_lenght FROM film);

-- Query 3: 
SELECT first_name, last_name FROM actor WHERE actor_id IN 
(SELECT actor_id FROM film_actor WHERE film_id IN (
SELECT film_id FROM film WHERE title = "Alone Trip"));

-- Query 4: 
SELECT film_id, title FROM film WHERE film_id IN 
(SELECT film_id FROM film_category WHERE category_id IN (
SELECT category_id FROM category WHERE name = 'Family'));

-- Query 5: 
-- Subquery format:
SELECT first_name, last_name, email FROM customer WHERE address_id IN(
SELECT address_id FROM address WHERE city_id IN (
SELECT city_id FROM city WHERE country_id IN
(SELECT country_id FROM country WHERE country = 'Canada')));

-- Joins: 
SELECT first_name, last_name, email FROM customer
LEFT JOIN address ON customer.address_id = address.address_id
LEFT JOIN city ON address.city_id = city.city_id
LEFT JOIN country ON city.country_id = country.country_id 
WHERE country.country = 'Canada';

-- 	Query 6:
SELECT first_name, last_name FROM actor 
WHERE actor_id = (SELECT actor_id FROM film_actor 
  GROUP BY actor_id 
  ORDER BY COUNT(*) DESC 
  LIMIT 1
);

-- Query 7: 
SELECT film_id, COUNT(film_id) AS num_rental_film FROM inventory WHERE inventory_id IN (
SELECT inventory_id FROM rental WHERE customer_id = (SELECT customer_id FROM (SELECT SUM(amount) as total_amount_spent, customer_id FROM payment 
GROUP BY customer_id
ORDER BY total_amount_spent DESC
LIMIT 1) AS top_customer))
GROUP BY film_id
ORDER BY num_rental_film DESC
LIMIT 1;

-- Query 8:
SELECT customer_id, SUM(amount) AS total_amount_spent FROM payment 
GROUP BY customer_id
HAVING SUM(amount) > (SELECT AVG(total_amount_spent) FROM 
(SELECT customer_id, SUM(amount) AS total_amount_spent
    FROM payment
    GROUP BY customer_id
  ) AS customer_totals);

