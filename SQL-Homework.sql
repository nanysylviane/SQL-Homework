use sakila;
# 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name
FROM actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT UPPER(CONCAT(first_name, ' ', last_name)) Actor_name
FROM actor;
    
# 2a.find the ID number, first name where first name ="Joe." 
SELECT first_name, last_name
FROM actor
WHERE first_name = 'joe';

# 2b. Find all actors whose last name contain the letters GEN
SELECT * FROM actor
WHERE last_name LIKE '%GEN%'; 
    
# 2c. actors whose last names contain the letters LI and order the rows by last name and first name  
SELECT * FROM actor
WHERE last_name LIKE ('%LI%')
ORDER BY last_name;

# 2d Using IN, display the country_id and country columns of Afghanistan, Bangladesh, and China:
SELECT * FROM country
WHERE country IN ('Afghanistan' , 'Bangladesh', 'China');
    
# 3a. create a new column in the table actor named description and use the data type BLOB  
ALTER TABLE actor ADD description BLOB;

# show the table with description
SELECT * FROM ACTOR;

# 3b. Delete the description column.
ALTER TABLE actor DROP description;

# show the table without description
SELECT * FROM ACTOR;

# 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) AS last_name_count
FROM actor
GROUP BY last_name;

# 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT  last_name, COUNT(last_name) AS last_name_count
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >1 ;

# 4c.The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor 
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO'
AND last_name = 'WILLIAMS';

# show the update 
SELECT * FROM actor
WHERE first_name = 'HARPO'
AND last_name = 'WILLIAMS';

# 4d.Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor 
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO'
AND last_name = 'WILLIAMS';

# show the update 
select * from actor where first_name='GROUCHO' and last_name='WILLIAMS';

# 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
CREATE TABLE IF NOT EXISTS address(
    address_id SMALLINT(5) NOT NULL AUTO_INCREMENT,
    address VARCHAR(50) NOT NULL,
    address2 VARCHAR(50),
    district VARCHAR(20) NOT NULL,
    city_id SMALLINT(5) NOT NULL,
    postal_code VARCHAR(10),
    phone VARCHAR(20) NOT NULL,
    location GEOMETRY NOT NULL,
    last_update TIMESTAMP NOT NULL,
    PRIMARY KEY (`address_id`),
    KEY `idx_fk_city_id` (`city_id`),
    SPATIAL KEY `idx_location` ( `location` ),
    CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`)
        REFERENCES `city` (`city_id`)
        ON UPDATE CASCADE
);

# 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address
SELECT s.first_name, s.last_name, a.address
FROM staff s
INNER JOIN address a ON s.address_id = a.address_id
ORDER BY s.address_id;

# 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT s.first_name, s.last_name,
COUNT(p.amount) AS total_amount, p.payment_date
FROM staff s 
INNER JOIN payment p ON s.staff_id = p.staff_id
WHERE payment_date LIKE '2005-08%'
GROUP BY p.staff_id;

# 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f1.film_id, f1.title, 
COUNT(f2.actor_id) AS number_of_actors
FROM film f1
INNER JOIN film_actor f2 ON f1.film_id = f2.film_id
GROUP BY f2.actor_id;

# 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f1.title, 
COUNT(inv.inventory_id) AS inventory_count
FROM film f1
INNER JOIN inventory inv ON f1.film_id = inv.film_id
WHERE f1.title = 'Hunchback Impossible';
    
# 6e.Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.first_name,c.last_name,
SUM(p.amount) AS 'Total amount paid'
FROM payment p
INNER JOIN customer c ON p.customer_id = c.customer_id
GROUP BY first_name , last_name
ORDER BY last_name;

/-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
#films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles 
#of movies starting with the letters K and Q whose language is English

 
SELECT l.name, f1.title
FROM language l
JOIN film f1 ON l.language_id = f1.language_id
WHERE (f1.title LIKE 'K%' OR f1.title LIKE 'Q%')
AND l.name = 'english';
        
        
# 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT a.first_name,a.last_name,f1.title
FROM actor a
INNER JOIN film_actor f3 ON a.actor_id = f3.actor_id
INNER JOIN film f1 ON f1.film_id = f3.film_id
WHERE title = "Alone Trip";

# 7c. email addresses of all Canadian customers.
SELECT c.email, Co.country 
FROM country Co
INNER JOIN city ci ON Co.country_id = ci.country_id
INNER JOIN address ad ON  ci.city_id = ad.city_id
INNER JOIN customer c ON ad.address_id = c.address_id
WHERE country = "Canada";

# 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
#from table category ,we see category_id = 8 if family movies
SELECT f1.title, fc.category_id
FROM film f1 
JOIN film_category fc ON f1.film_id = fc.film_id
WHERE category_id = '8';
    
#7e. Display the most frequently rented movies in descending order. 
SELECT f1.title AS 'film_title',
COUNT(r.rental_date) AS 'count number of time rented'
FROM film AS f1
JOIN inventory AS i ON i.film_id = f1.film_id
JOIN rental AS r ON r.inventory_id = i.inventory_id
GROUP BY f1.title
ORDER BY COUNT(r.rental_date) DESC;
    
#7f. Write a query to display how much business, in dollars, each store brought in  
SELECT i.store_id AS store_id, sum(p.amount) AS total_amount 
FROM payment p
JOIN rental r ON p.rental_id= r.rental_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN store s ON s.store_id = i.store_id
GROUP BY s.store_id;
 
 
 
 # 7g. Write a query to display for each store its store ID, city, and country.
SELECT st.store_id 'store_id',cit.city 'city',cy.country'country'
FROM store st JOIN address ad ON ad.address_id = st.address_id
        JOIN city cit ON cit.city_id = ad.city_id
        JOIN country cy ON cy.country_id = cit.country_id
ORDER BY st.store_id;


#7h. List the top five genres in gross revenue in descending order.
SELECT cat.name AS film, SUM(pay.amount) AS 'gross revenue'
FROM category cat
JOIN film_category flc ON flc.category_id = cat.category_id
JOIN inventory i ON i.film_id = flc.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment pay ON r.rental_id = pay.rental_id
GROUP BY cat.name
ORDER BY SUM(pay.amount) DESC
LIMIT 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. 

CREATE VIEW genre_revenue_top_5 AS
SELECT cat.name AS film, SUM(pay.amount) AS 'gross revenue'
FROM category cat
JOIN film_category flc ON flc.category_id = cat.category_id
JOIN inventory i ON i.film_id = flc.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment pay ON r.rental_id = pay.rental_id
GROUP BY cat.name
ORDER BY SUM(pay.amount) DESC
LIMIT 5;
    
# 8b. How would you display the view that you created in 8a?
SELECT * FROM genre_revenue_top_5;
    
#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW genre_revenue_top_5;
