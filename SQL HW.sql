--  Displaying all coulmns in the actor table  
SELECT * FROM sakila.actor;

-- 1. a. Displaying the first and last names of all actors from the table `actor`. 

SELECT first_name, last_name
  FROM actor;
  
  
-- 1b. Displaing the first and last name of each actor in a single column in upper case letters. 
-- Name the column `Actor Name`.   

SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS `Actor Name`
  FROM actor;
  
-- 2a. DIspaying the ID number, first name, 
-- and last name of an actor, of whom you know only the first name, "Joe." 

SELECT first_name, last_name, actor_id
  FROM actor
  WHERE first_name = "Joe";
  
-- 2b. Find all actors whose last name contain the letters `GEN`:

SELECT first_name, last_name, actor_id
  FROM actor
  WHERE last_name LIKE '%GEN%';
  
  
-- 2.c. Find all actors whose last names contain the letters `LI`. 
-- ordering the rows by last name and first name, in that order  

SELECT first_name, last_name, actor_id
  FROM actor
  WHERE last_name LIKE '%LI%'
  ORDER BY last_name, first_name; 
  
  
-- 2.d.Displaying the `country_id` and `country` columns of the following countries: 
-- Afghanistan, Bangladesh, and China

  SELECT country_id, country
  FROM country
  WHERE country ='Afghanistan' OR country= 'Bangladesh' OR country='China';
  
  
-- 3a. Adding a `middle_name` column to the table `actor` and
-- Positioning it between `first_name` and `last_name`. 

ALTER TABLE actor
  ADD COLUMN middle_name varchar(40) AFTER first_name;

-- 3.b. Changing the data type of the `middle_name` column to `blobs

ALTER TABLE actor
  MODIFY COLUMN middle_name blob;
  
-- 3.c. Deleting the `middle_name` column.

ALTER TABLE actor
  DROP COLUMN middle_name;
  
  
-- 4.a Listing the last names of actors and that last name frequency 

  SELECT last_name, count(last_name) AS 'last_name_frequency'
  FROM actor
  GROUP BY last_name
  HAVING `last_name_frequency` >= 1;
  
 -- 4.b.  Dispaying last names of actors and last name frequency in which 
 -- last name is shared by at least two actors
  
  SELECT last_name, count(last_name) AS 'last_name_frequency'
  FROM actor
  GROUP BY last_name
  Having `last_name_frequency` >= 2;


-- 4c. Writing a query to fix the record for the actor
-- HARPO WILLIAMS which was accidentally entered in the actor table as GROUCHO WILLIAMS

-- FIRST WRITING A QUERY TO FIND THE ACTOR ID 

SELECT first_name, last_name, actor_id
  FROM actor
  WHERE first_name = "GROUCHO"
  and last_name='WILLIAMS';
-- THEN UPDATING THE FIRST NAME TO HARPO
  
UPDATE actor
  SET first_name = 'HARPO'
  WHERE first_name = 'GROUCHO'
  and last_name = 'WILLIAMS';
  
 -- Verifiying the update
 
 SELECT first_name, last_name, actor_id
  FROM actor
  WHERE first_name = "HARPO"; 
  
-- 4.d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
-- It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

UPDATE actor
  SET first_name ='GROUCHO'
  WHERE first_name='HARPO'
  AND actor_id = '172';

-- Verifying the change FOR ACTOR ID 172 
 SELECT first_name, last_name, actor_id
  FROM actor
  WHERE first_name = "GROUCHO";
  
-- 5. You cannot locate the schema of the address table. Which query would you use to re-create it? 
-- from the hint provided I have used the following query:

SHOW CREATE TABLE address;
  
-- 6.a Using the tables staff and address and alter
-- to display the first and last names, as well as the address, of each staff member by Using JOIN 

-- First seeing what are in the staff and address tables

SELECT * FROM staff;
SELECT * FROM address;

-- since both tables have an address_id we can join them by address_id 
-- for the two staff memebers and show their addresses

SELECT staff.first_name, staff.last_name, address.address
  FROM staff 
  INNER JOIN address 
  ON (staff.address_id = address.address_id);
  
-- 6.b. Use JOIN to display the total amount rung up by each staff member in August of 2005
--  Use tables staff and payment.  


-- Displaying the payment table 
SELECT * FROM payment;

-- Using JOIN to display the total payment amount rung up by each staff member in August of 2005
-- from tables staff and payment.

SELECT staff.first_name, staff.last_name, SUM(payment.amount)
  FROM staff
  INNER JOIN payment
  ON payment.staff_id = staff.staff_id
  WHERE MONTH(payment.payment_date) = 08 AND YEAR(payment.payment_date) = 2005
  GROUP BY staff.staff_id;

-- Listing each film and the number of actors who are listed for that film. 
-- Using tables film_actor and film. Use inner join to display the title 
-- and actor counts in descending order

SELECT * FROM film;
SELECT * FROM film_actor;

SELECT film.title, COUNT(film_actor.actor_id) AS 'Actors'
  FROM film_actor 
  INNER JOIN film
  ON film.film_id = film_actor.film_id
  GROUP BY film.title
  ORDER BY Actors desc;
  
--  6d. How many copies of the film Hunchback Impossible exist in the inventory system?
-- Inner join film and inventory by film id to count the number of copies 
  
 SELECT title, COUNT(inventory_id) AS '# of copies'
  FROM film
  INNER JOIN inventory
  USING (film_id)
  WHERE title = 'Hunchback Impossible'
  GROUP BY title;


-- 6.e Using the tables payment and customer and the JOIN command, 
-- listing the total paid by each customer and displaying the customers alphabetically by last name:
-- Using tables customer for last name, sum function for the amount in the payment table
-- and joining them by customer_id

SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS 'Total Amount Paid By Customer'
  FROM payment 
  JOIN customer
  ON payment.customer_id = customer.customer_id
  GROUP BY customer.customer_id
  ORDER BY customer.last_name;
  
--  7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity.
-- Use subqueries to display the titles of movies starting 
-- with the letters K and Q whose language is English. 
-- Solution: Using tables film and lanugage the common varibale is language id. Using subqueries to 
-- Display the titles from the film table
--

SELECT title
  FROM film
  WHERE title LIKE 'K%'
  OR title LIKE 'Q%'
  AND language_id IN
  (
   SELECT language_id
   FROM language
   WHERE name = 'English');


-- 7.b. Use subqueries to display all actors who appear in the film Alone Trip

-- Solution: Use subqueries by the variable actor_id and film_id 
-- from tables film_actor, film and actor, to display the actors in the film 'alone trip'
-- by first and last name

SELECT first_name, last_name
  FROM actor 
  WHERE actor_id IN 
  (
    SELECT actor_id
    FROM film_actor
    WHERE film_id = 
    (
       SELECT film_id
       FROM film
       WHERE title = 'Alone Trip'));
       
--  7c. You want to run an email marketing campaign in Canada, 
-- for which you will need the names and email addresses of all Canadian customers.
-- Use joins to retrieve this information. 

-- Solution: Must display first and last names, email, country(canada)
-- Tables to be used customer table (first and last names, email), address table, 
-- City table, and country table 
-- Starting from the country and city tables the common varibale is country ID 
-- Then the address table is joined with the city table with city ID
-- The customer and address table are joined by the address ID
-- Using subqueries using the above tables, common variables and join and where function:

SELECT first_name, last_name, email, country
  FROM customer 
  JOIN address
  ON (customer.address_id = address.address_id)
  JOIN city
  ON (address.city_id = city.city_id)
  JOIN country 
  ON (city.country_id = country.country_id)
  WHERE country.country = 'canada';
  
  
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.  

SELECT title, category.Name
  FROM film 
  JOIN film_category 
  ON (film.film_id = film_category.film_id)
  JOIN category 
  ON (category.category_id = film_category.category_id)
  WHERE name = 'family';
  
--  7e. Display the most frequently rented movies in descending order. 
-- Solution: Using tables film, inventory and rental and using subqueries to join the tables
-- by inventory id and film id and listing the total_rentals column in descending order

  SELECT title, COUNT(title) as 'Total_Rentals'
  FROM film
  JOIN inventory
  ON (film.film_id = inventory.film_id)
  JOIN rental
  ON (inventory.inventory_id = rental.inventory_id)
  GROUP by title
  ORDER BY Total_Rentals desc;
  
  -- 7f. Write a query to display how much business, in dollars, each store brought in.
  
  -- Solution: Using the store table, payment table, rental table, inventory table to display the store
  -- and how total amount that store brought in
  -- Store and inventory table have store_id as a common variable
  -- Inventory and rental table have inventory_id as a common variable
  -- Rental and payment tables have rental_id as a common variable
  
SELECT store.store_id, SUM(amount) AS 'Total Amount Brought IN'
  FROM payment 
  JOIN rental 
  ON (payment.rental_id = rental.rental_id)
  JOIN inventory 
  ON (inventory.inventory_id = rental.inventory_id)
  JOIN store 
  ON (store.store_id = inventory.store_id)
  GROUP BY store.store_id;
     
     
 -- 7g. Write a query to display for each store its store ID, city, and country.
 
 -- Solution: Co,umns to be displayed are store ID, city and country
 -- Tables to be used are store table, address table, city table, and country table
 -- 4 tables and 3 variables to JOIN
 -- Common variable for city and country is country_id
 -- Common variable for city and address tables is city_id
 -- Common variable for store and address tables is address_id
 
 SELECT store_id, city, country
  FROM store 
  JOIN address 
  ON (store.address_id = address.address_id)
  JOIN city 
  ON (city.city_id = address.city_id)
  JOIN country 
  ON(city.country_id = country.country_id);
  
  -- 7h. List the top five genres in gross revenue in descending order. 
  
  -- Solution: Using the following tables: category, film_category, inventory, payment, and rental
  -- Columns to be dispayed Genres and Gross Revenue
  -- Using 5 tables and 4 common variables
  -- Common variable for film category and category tables is category_id
  -- Common variable for inventory and film category tables is film_id
  -- Common variable for rental and inventory tables is inventory_id
  -- Common variable for payment and rental tables is rental_id

  SELECT SUM(amount) AS 'Total Revenue', category.name AS 'Genre'
  FROM payment 
  JOIN rental 
  ON (payment.rental_id = rental.rental_id)
  JOIN inventory 
  ON (rental.inventory_id = inventory.inventory_id)
  JOIN film_category 
  ON (inventory.film_id = film_category.film_id)
  JOIN category 
  ON (film_category.category_id = category.category_id)
  GROUP BY category.name
  ORDER BY SUM(amount) DESC;

-- 8.a Use the solution from the problem above to create a view.
-- solution: Using Create View 

CREATE VIEW Top_5_Genres AS
SELECT SUM(amount) AS 'Total Revenue', category.name AS 'Genre'
  FROM payment 
  JOIN rental 
  ON (payment.rental_id = rental.rental_id)
  JOIN inventory 
  ON (rental.inventory_id = inventory.inventory_id)
  JOIN film_category 
  ON (inventory.film_id = film_category.film_id)
  JOIN category 
  ON (film_category.category_id = category.category_id)
  GROUP BY category.name
  ORDER BY SUM(amount) DESC;


  
-- 8.b How would you display the view that you created in 8a
-- Solution:

SELECT * FROM Top_5_Genres;

-- 8.c. You find that you no longer need the view top_five_genres. 
-- Write a query to delete it.
-- Solution: Using Drop view

DROP VIEW Top_5_Genres;