USE sakila;
SHOW TABLES;
-- Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT COUNT(*)
FROM inventory
WHERE film_id = (
    -- Esta es la subconsulta que se ejecuta primero
    SELECT film_id
    FROM film
    WHERE title = 'Hunchback Impossible'
);
-- List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT title, length
FROM film
WHERE length > ( SELECT AVG(length) FROM film
);

-- Use a subquery to display all actors who appear in the film "Alone Trip"
SELECT first_name, last_name 
FROM actor
WHERE actor_id IN ( 
    -- Consulta Media: Obtiene los IDs de los actores
    SELECT actor_id 
    FROM film_actor
    WHERE film_id = (
        -- Consulta Interior: Obtiene el ID de la película 'Alone Trip'
        SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
    )
);

-- Sales have been lagging among young families, and you want to target family movies for a promotion.
--  Identify all movies categorized as family films.

SELECT title
FROM film
WHERE film_id IN ( 
    -- Paso 2 (Subconsulta Media): Lista de IDs de películas familiares
    SELECT film_id
    FROM film_category
    WHERE category_id = (
        -- Paso 1 (Subconsulta Interna): ID de la categoría 'Family'
        SELECT category_id
        FROM category
        WHERE name = 'Family'
    )
);

-- Retrieve the name and email of customers from Canada using both subqueries and joins. 
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT first_name, last_name, email 
FROM customer
WHERE address_id IN ( 
    -- Nivel 3: IDs de direcciones en ciudades canadienses
    SELECT address_id
    FROM address
    WHERE city_id IN (
        -- Nivel 2: IDs de las ciudades canadienses
        SELECT city_id
        FROM city
        WHERE country_id = (
            -- Nivel 1: ID del país 'Canada'
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);

-- Determine which films were starred by the most prolific actor in the Sakila database...

SELECT title 
FROM film
WHERE film_id IN ( 
    -- Nivel 2: Lista todos los IDs de las películas del actor más prolífico
    SELECT film_id
    FROM film_actor
    WHERE actor_id = (
        -- Nivel 1: Encuentra el ID del actor más prolífico (solo 1 ID)
        SELECT actor_id
        FROM film_actor
        GROUP BY actor_id
        ORDER BY COUNT(*) DESC
        LIMIT 1
    )
);

-- Find the films rented by the most profitable customer in the Sakila database.
SELECT title 
FROM film
WHERE film_id IN (
    -- Nivel 3: Lista de IDs de películas (film_id)
    SELECT film_id
    FROM inventory
    WHERE inventory_id IN (
        -- Nivel 2: Lista de IDs de copias rentadas (inventory_id)
        SELECT inventory_id
        FROM rental
        WHERE customer_id = (
            -- Nivel 1: ID del cliente más rentable
            SELECT customer_id
            FROM payment
            GROUP BY customer_id
            ORDER BY SUM(amount) DESC
            LIMIT 1
        )
    )
);

-- Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. 
-- You can use subqueries to accomplish this.
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
-- La condición se aplica al grupo (a la suma), por eso usamos HAVING
HAVING SUM(amount) > ( 
    -- Subconsulta Anidada: Calcula el promedio de la suma de gastos de CADA cliente
    SELECT AVG(total_spent)
    FROM (
        SELECT SUM(amount) AS total_spent
        FROM payment
        GROUP BY customer_id
    ) AS customer_totals
);