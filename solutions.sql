SELECT COUNT(*) AS inventory_id
FROM film
JOIN inventory ON film.film_id = inventory_id
WHERE film.title = 'Hunchback Impossible';

SELECT * FROM film
where length >(SELECT AVG(length) FROM film);

SELECT a.first_name, a.last_name
FROM actor as a
JOIN film_actor as b ON a.actor_id = b.actor_id
JOIN film as c ON b.film_id = c.film_id
	WHERE c.title = 'Alone Trip';
    
SELECT film.title
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Family';

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
            
            
SELECT film.title, CONCAT(actor.first_name, ' ',actor.last_name) AS `NAME` 
FROM film, film_actor, actor
WHERE film.film_id = film_actor.film_id
AND film_actor.actor_id = actor.actor_id
AND actor.actor_id = (
    SELECT actor_id 
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(*) DESC LIMIT 1);
    

SELECT customer_id, SUM(amount) AS total_payments
FROM payment
GROUP BY customer_id
ORDER BY total_payments DESC
LIMIT 1;

SELECT customer_id AS `CLIENT ID`, SUM(amount) AS `TOTAL SPENT` 
FROM payment
GROUP BY `CLIENT ID`
HAVING SUM(amount) > (
	SELECT AVG(total_amount_spent) 
    FROM (SELECT SUM(amount) AS total_amount_spent 
    FROM payment 
    GROUP BY customer_id) AS t)
ORDER BY `TOTAL SPENT` DESC;