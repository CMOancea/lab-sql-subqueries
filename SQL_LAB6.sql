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
SELECT address_id
FROM address
WHERE city_id IN (
    -- Subconsulta Media: IDs de las ciudades canadienses
    SELECT city_id
    FROM city
    WHERE country_id = (
        -- Subconsulta Interna: ID del país 'Canada'
        SELECT country_id
        FROM country
        WHERE country = 'Canada'
    )
);

