"1a. Display the first and last names of all actors from the table actor."
Use sakila;
Select * From sakila.actor;
Select first_name, last_name from actor;

"1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name."
SELECT first_name, last_name, 
CONCAT(first_name, " ", last_name) AS Actor_Name
FROM actor
ORDER BY  Actor_name ASC

"2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
What is one query would you use to obtain this information?"
Select * FROM actor where first_name = "Joe";

"2b. Find all actors whose last name contain the letters GEN:"
Select * FROM actor where last_name like "%GEN%";

'2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:'
Select * FROM actor where last_name like "%LI%"
ORDER BY  last_name, first_name;

'2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:'
Select country_id, country from country where country in ("Afghanistan", "Bangladesh", "China");

"3a. You want to keep a description of each actor. You dont think you will be performing queries on a description, 
so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, 
as the difference between it and VARCHAR are significant)."
ALTER TABLE actor
ADD Description BLOB;

"3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column."
Alter Table actor
drop column Description;

"4a. List the last names of actors, as well as how many actors have that last name."
Select count(last_name), last_name
from actor group by last_name
ORDER BY count(last_name) DESC

"4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors"
Select count(last_name), last_name
from actor group by last_name
Having count(last_name) >= 2
ORDER BY  count(last_name) DESC

"4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record."
Update actor 
Set first_name = "HARPO", last_name = "WILLIAMS"
Where (first_name = "GROUCHO" and last_name = "WILLIAMS")

"4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single
 query, if the first name of the actor is currently HARPO, change it to GROUCHO."
Update actor
Set first_name = "GROUCHO"
Where (first_name = "HARPO" and last_name = "WILLIAMS")

"5a. You cannot locate the schema of the address table. Which query would you use to re-create it?"
CREATE TABLE address (
	address varchar(50),
	address2 varchar(50),
	district varchar(20),
	city_id smallint(5),
	postal_code varchar(10),
    phone varchar(20),
	location geometry,
	last_update timestamp);

"6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:"
Select staff.first_name, staff.last_name, address.address
From address
Inner Join staff on
staff.address_id=address.address_id

"6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment."
Select staff.staff_id, payment.amount, payment.payment_date
from payment 
inner join staff on staff.staff_id=payment.staff_id
WHERE MONTH(payment_date) = 08 AND YEAR(payment_date) = 2005;
Select sum(amount) as "Staff Amount Total for August of 2005", staff_id
from payment
group by staff_id

"6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join."
Select film.title, count(film_actor.actor_id) as "Number of Actors" 
from film_actor
inner join film on film.film_id=film_actor.film_id
group by film.title

"6d. How many copies of the film Hunchback Impossible exist in the inventory system?"
SELECT title, (SELECT COUNT(*) FROM inventory WHERE film.film_id = inventory.film_id ) AS 'Number of Copies'
FROM film where title = "Hunchback Impossible";

"6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
List the customers alphabetically by last name:"
Select first_name, last_name, sum(amount) as "Total paid by customer"
from customer 
inner join payment on customer.customer_id = payment.customer_id
group by customer.customer_id
order by last_name;

"7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
films starting with the letters K and Q have also soared in popularity. 
Use subqueries to display the titles of movies starting with the letters K and Q whose language is English."
Select * from film 
where title like "K%" or title like "Q%" and language_id = 1;

"7b. Use subqueries to display all actors who appear in the film Alone Trip."
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(SELECT actor_id
  FROM film_actor
  WHERE film_id IN
  (SELECT film_id
   FROM film
   WHERE title = 'Alone Trip')
);

"7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian 
customers. Use joins to retrieve this information. Link city and coiuntry then address then customer"
SELECT customer.customer_id, customer_list.name, customer.email, customer_list.ID, customer_list.country
from customer_list
inner join customer on customer.customer_id = customer_list.ID
where customer_list.country = "Canada"

"7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
Identify all movies categorized as family films."
Select film.title, film.film_id, film_category.film_id, film_category.category_id
from film
Join film_category on film.film_id = film_category.film_id
where category_id = 8
"Below is the better code, using a View"
SELECT * FROM sakila.film_list where category = "Family";

"7e. Display the most frequently rented movies in descending order."
Select film.title, count(title) as "Popular_Rentals"
from film
inner join inventory on film.film_id=inventory.film_id
inner join rental on inventory.inventory_id = rental.inventory_id
group by title
order by Popular_Rentals DESC;

"7f. Write a query to display how much business, in dollars, each store brought in."
Select staff_id, sum(amount) as "Store Totals"
from payment
group by staff_id

"7g. Write a query to display for each store its store ID, city, and country."
"Run this one at a time..."
Select store_id from store
Select city_id from address where address_id = 1 or address_id = 2
Select city from city where city_id = 300 or city_id = 576
Select country_id from city where city_id = 300 or city_id = 576
Select country from country where country_id = 20 or country_id = 8

"7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, 
film_category, inventory, payment, and rental.)"
SELECT * FROM sales_by_film_category
order by total_sales DESC limit 5

"8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create 
a view."
Create View ExpensiveReplacements As
Select title, replacement_cost
From film
Where replacement_cost > 25;

"8b. How would you display the view that you created in 8a?"
Select * from ExpensiveReplacements;

"8c. You find that you no longer need the view top_five_genres. Write a query to delete it."
Drop View ExpensiveReplacements;

"or Drop view sales_by_film_category"