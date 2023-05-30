use sakila;

-- 1-- 
SELECT COUNT(*) AS numero_de_copias
from inventory
where film_id= '439';
-- 2 --
SELECT * FROM film
where length >(SELECT AVG(length) FROM film);
-- 3 --
SELECT a.first_name
FROM actor as a
JOIN film_actor as b ON a.actor_id = b.actor_id
JOIN film as c ON b.film_id = c.film_id
	WHERE c.title = 'Alone Trip';
 -- 4 --   
SELECT title
FROM film
WHERE film_id IN (
	SELECT film_id
	FROM film_category
	WHERE category_id IN
		(SELECT category_id
		FROM category
		WHERE name = 'Family'));
-- 5 --
SELECT first_name, email
FROM customer
where address_id IN (
	SELECT Address_id 
    FROM address
    WHERE city_id IN (
		SELECT city_id 
        FROM city
        WHERE country_id IN ( 
			SELECT Country_id
            from country
            where country = 'Canada')));
-- 6 -- 
SELECT film.title, CONCAT(actor.first_name, ' ',actor.last_name) AS `NAME` 
FROM film, film_actor, actor
WHERE film.film_id = film_actor.film_id
AND film_actor.actor_id = actor.actor_id
AND actor.actor_id = (
    SELECT actor_id 
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(*) DESC LIMIT 1);
    
-- 7 --
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS `MOST PROFITABLE CUSTOMER`, film.title 
FROM customer, payment, rental, inventory, film
WHERE customer.customer_id = payment.customer_id
AND payment.rental_id = rental.rental_id
AND rental.inventory_id = inventory.inventory_id
AND inventory.film_id = film.film_id
AND customer.customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1);
    
-- 8 --
SELECT customer_id AS `CLIENT ID`, SUM(amount) AS `TOTAL SPENT` 
FROM payment
GROUP BY `CLIENT ID`
HAVING SUM(amount) > (
	SELECT AVG(total_amount_spent) 
    FROM (SELECT SUM(amount) AS total_amount_spent 
    FROM payment 
    GROUP BY customer_id) AS t)
ORDER BY `TOTAL SPENT` DESC;