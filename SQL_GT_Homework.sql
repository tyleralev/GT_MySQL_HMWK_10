#use the sakila database
use sakila;

#1a display the first and last names of all the actors from actors table
select actor.first_name, actor.last_name
From actor;

#1b Display the first and last name of actor in one column and name the 
#and the last name as upper case and rename the table Actor name

select concat(a.first_name, ' ', a.last_name) AS 'Actor Name'
from actor a;

#2a. You need to find the ID number, first name, and last name of an actor, 
#of whom you know only the first name, 
#"Joe." What is one query would you use to obtain this information?
select * from actor;
select a.actor_id, a.first_name, a.last_name
from actor a
where a.first_name = 'Joe';

#2b. Find all actors whose last name contain the letters GEN
select a.actor_id, a.first_name, a.last_name
from actor a
where a.last_name like '%GEN%';

#2c. Find all actors whose last names contain the letters LI. 
#This time, order the rows by last name and first name, in that order:

select a.last_name, a.first_name
from actor a
where a.last_name like '%LI%'; 
#confused on what its asking could also be:
#where a.last_name like '%L%' OR a.last_name like '%I%'

#2d. Using IN, display the country_id and country columns of 
#the following countries: Afghanistan, Bangladesh, and China:

select c.country_id, c.country
from country c
where c.country IN 
(
	select c.country
    from country
    where c.country = 'Afghanistan' OR c.country =  'Bangladesh'
		or c.country = 'China'
);

#3a. You want to keep a description of each actor. 
#You don't think you will be performing queries on a description, 
#so create a column in the table actor named description and use
#the data type BLOB (Make sure to research the type BLOB, as 
#the difference between it and VARCHAR are significant).

alter table actor add description blob;
select * from actor;

#3b. Very quickly you realize that entering descriptions for 
#each actor is too much effort. Delete the description column.

alter table actor drop description;
select * from actor;

#4a. List the last names of actors, as well as how many 
#actors have that last name.

select last_name, count(1) as count
from actor
group by last_name
order by count desc;

#4b. List last names of actors and the number of actors 
#who have that last name, but only for names that are shared
#by at least two actors

select last_name, count(1) as count
from actor
group by last_name
having count >= 2
order by count desc;

#4c. The actor HARPO WILLIAMS was accidentally entered in the
#actor table as GROUCHO WILLIAMS. Write a query to fix the record.
update actor set first_name = 'HARPO'
where first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
#It turns out that GROUCHO was the correct name after all! 
#In a single query, if the first name of the actor is currently HARPO,
#change it to GROUCHO.
update actor
set first_name = if(first_name = 'HARPO', 'GROUCHO', 'GROUCHO')
where first_name = 'HARPO' AND last_name = 'WILLIAMS';

select  * from actor
where first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

#5a. You cannot locate the schema of the address table. 
#Which query would you use to re-create it?
Show create table address;

#6a. Use JOIN to display the first and last names, 
#as well as the address, of each staff member. 
#Use the tables staff and address:
select * from address;
select * from staff;

select s.first_name, s.last_name, a.address
from staff s
join address a 
on s.address_id = a.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member 
#in August of 2005. Use tables staff and payment.

select * from staff;
select * from payment;

select s.first_name, s.last_name, sum(p.amount)
from staff s
join payment p
on s.staff_id = p.staff_id
group by p.staff_id;

#6c. List each film and the number of actors who are listed for that film.
#Use tables film_actor and film. Use inner join.
select * from film;
select * from film_actor;

select f.title, count(fa.actor_id) as number_of_actors
from film f
inner join film_actor fa
on f.film_id = fa.film_id
group by f.title;

# 6d. How many copies of the film Hunchback Impossible exist in the
#inventory system?
select * from film;
select * from inventory; 

select f.title, count(i.inventory_id) as number_in_inventory
from film f 
inner join inventory i 
on f.film_id = i.film_id
where title = 'Hunchback Impossible';

#6e. Using the tables payment and customer and the JOIN command, 
#list the total paid by each customer. List the customers alphabetically 
#by last name:

select * from payment;
select * from customer;

select c.first_name, c.last_name, sum(p.amount) total_paid
from payment p
inner join customer c
on p.customer_id = c.customer_id
group by c.last_name asc;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely 
#resurgence. As an unintended consequence, films starting with the 
#letters K and Q have also soared in popularity. Use subqueries
#to display the titles of movies starting with the letters K and Q 
#whose language is English.
select *  from film;
select * from language;

select f.title 
from film f
where language_id in
(
	select l.language_id
    from language l
    where l.name = 'English'
)
And f.title like 'K%'
or f.title like 'Q%';

#7b. Use subqueries to display all actors who appear
#in the film Alone Trip.
select * from actor;
select * from film_actor;
select * from film;

select a.first_name, a.last_name
from actor a 
where a.actor_id in(
	select fa.actor_id
    from film_actor fa
    where fa.film_id in(
		select f.film_id
        from film f
        where f.title = 'Alone Trip'
        )
	);
 
 #7c. You want to run an email marketing campaign in Canada, 
 #for which you will need the names and email addresses of all 
 #Canadian customers. Use joins to retrieve this information.
 
 select * from customer;
 select * from address;
 select * from city;
 select * from country;
 
 select c.email
 from customer c
 where c.address_id in(
	select a.address_id
    from address a
    where a.city_id in(
		select ci.city_id
        from city ci
        where ci.country_id in(
			select co.country_id
            from country co
            where co.country = 'Canada'
			)
        )
 );
 
 #7d. Sales have been lagging among young families, and you wish to target all 
 #family movies for a promotion. Identify all movies categorized as family films.
 select * from film;
 select * from category;
 select * from film_category;
 
 select f.title, f.description
 from film f 
 where f.film_id in(
	select fc.film_id
    from film_category fc
    where fc.category_id in(
		select c.category_id
        from category c
        where c.name = 'Family'
        ) 
 );
 
 #7e. Display the most frequently rented movies in descending order.
 select * from rental;
 select * from inventory;
 select * from film;
 
 
select f.title, count(rental_id) AS 'Rental_Frequency'
from rental r
join inventory i
	on (r.inventory_id = i.inventory_id)
join film f
	on (i.film_id = f.film_id)
group by f.title 
order by Rental_Frequency desc;


#7f. Write a query to display how much business, in dollars, each store brought in.
select * from store;
select * from payment;
select * from rental;
select * from inventory;

select s.store_id, sum(amount) as 'Revenue'
from payment p
join rental r 
on (p.rental_id = r.rental_id)
join inventory i
on (r.inventory_id = i.inventory_id)
join store s
on (i.store_id = s.store_id)
group by store_id;



#7g. Write a query to display for each store its store ID, city, and country.
select * from store;
select * from city;
select * from country;
select * from address;

select s.store_id, ci.city, co.country
from store s
join address a 
on (s.address_id = a.address_id)
join city ci
on (a.city_id = ci.city_id)
join country co
on (ci.country_id = co.country_id);

#7h. List the top five genres in gross revenue in descending order. 
#(Hint: you may need to use the following tables: category, film_category, 
#inventory, payment, and rental.)
select * from category;
select * from film_category;
select * from inventory;
select * from payment;
select * from rental;

select c.name, sum(p.amount) as 'Gross_Revenue'
from category c
join film_category fc
on (c.category_id = fc.category_id)
join inventory i 
on (fc.film_id = i.film_id)
join rental r
on (i.inventory_id = r.inventory_id)
join payment p
on (r.rental_id = p.rental_id)
group by c.name
order by Gross_Revenue limit 5;


#8a. In your new role as an executive, you would like to have an easy way of 
#viewing the Top five genres by gross revenue. Use the solution from the problem 
#above to create a view. If you haven't solved 7h, 
#you can substitute another query to create a view.
create view top_5_genres_gross_revenue as
select c.name, sum(p.amount) as 'Gross_Revenue'
from category c
join film_category fc
on (c.category_id = fc.category_id)
join inventory i 
on (fc.film_id = i.film_id)
join rental r
on (i.inventory_id = r.inventory_id)
join payment p
on (r.rental_id = p.rental_id)
group by c.name
order by Gross_Revenue limit 5;

#8b. How would you display the view that you created in 8a?
select * from top_5_genres_gross_revenue;

#8c. You find that you no longer need the view top_five_genres.
#Write a query to delete it.
drop view top_5_genres_gross_revenue;