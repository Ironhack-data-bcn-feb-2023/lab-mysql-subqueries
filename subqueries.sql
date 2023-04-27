USE Sakila;

-- Question 1 --
SELECT film.film_id, film.title, COUNT(inventory.film_id) AS Num_Copies
FROM film
JOIN inventory ON film.film_id = inventory.film_id
WHERE film.title LIKE '%Hunchback Impossible%'
GROUP BY film.film_id, film.title;


-- Question 2 --
SELECT AVG(LENGTH(title)) AS Average_title_characters FROM film;

SELECT film_id, title, LENGTH(title) AS title_length
FROM film
WHERE LENGTH(title) > (SELECT AVG(LENGTH(title)) FROM film)
GROUP BY film_id, title
ORDER BY LENGTH(title) DESC;


-- Question 3 --
SELECT film_actor.actor_id, actor.first_name, actor.last_name
FROM actor
	JOIN film_actor ON actor.actor_id = film_actor.actor_id
    JOIN film ON film_actor.film_id= film.film_id
WHERE film_actor.film_id IS NOT NULL
AND film_actor.film_id LIKE (
	SELECT film.film_id
    FROM film
	WHERE film.title LIKE ("Alone Trip")
    AND film.film_id IS NOT NULL
    );
    
    
-- Question 4 --
SELECT film.title, category.name
FROM film_category
	LEFT JOIN film ON film_category.film_id = film.film_id
	LEFT JOIN category ON film_category.category_id = category.category_id
	WHERE film.film_id IN (
		SELECT film_category.film_id
        FROM film_category
        WHERE category.name = "Family"
        );
  
  
  -- Question 5 --
		-- subqueries --
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (SELECT address_id FROM address WHERE city_id IN (SELECT city_id FROM city WHERE country_id IN (SELECT country_id FROM country WHERE country = "Canada")));

		-- JOIN --
SELECT first_name, last_name, email, country.country
FROM customer
	JOIN address ON customer.address_id = address.address_id
    JOIN city ON address.city_id = city.city_id
    JOIN country ON city.country_id = country.country_id
WHERE country.country = "Canada";


-- Question 6 --
SELECT film.title 
FROM film
WHERE film.film_id IN (
	SELECT film.film_id 
    FROM film_actor 
    WHERE film_actor.actor_id = (
		SELECT actor_id
        FROM film_actor 
        GROUP BY actor_id 
        ORDER BY COUNT(film_id) DESC 
        LIMIT 1));


-- Question 7 --
SELECT film.title FROM film
WHERE film.film_id IN (
	SELECT inventory.film_id FROM inventory
	WHERE inventory.inventory_id IN (
		SELECT rental.inventory_id FROM rental
		WHERE rental.customer_id IN (
				SELECT customer_id
				FROM payment
				GROUP BY customer_id
				HAVING SUM(amount) = (
						SELECT SUM(amount)
						FROM payment
						GROUP BY customer_id
						ORDER BY SUM(amount) DESC
				LIMIT 1))));
                

-- Question 8 --
SELECT customer_id, SUM(amount) as total_amount
FROM payment
WHERE customer_id IN (
		SELECT customer_id
		FROM payment
		WHERE amount > (SELECT AVG(amount) FROM payment)
		GROUP BY customer_id
		ORDER BY amount DESC)
GROUP BY customer_id
ORDER BY SUM(amount) DESC;