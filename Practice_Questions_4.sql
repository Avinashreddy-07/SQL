/*
SQL JOIN QUESTIONS 

1. List all customers along with the films they have rented.

2. List all customers and show their rental count, including those who haven't rented any films.

3. Show all films along with their category. Include films that don't have a category assigned.

4. Show all customers and staff emails from both customer and staff tables using a full outer join (simulate using LEFT + RIGHT + UNION).

5. Find all actors who acted in the film "ACADEMY DINOSAUR".

6. List all stores and the total number of staff members working in each store, even if a store has no staff.

7. List the customers who have rented films more than 5 times. Include their name and total rental count.

*/

-- 1
select * from sakila.customer;
select * from sakila.rental;
select * from sakila.film;
select * from sakila.inventory; 

select distinct c.first_name, c.last_name, f.title
from sakila.customer c 
left join sakila.rental r on c.customer_id = r.customer_id
left join sakila.inventory i on i.inventory_id = r.inventory_id
left join sakila.film f on f.film_id = i.film_id;

-- 2
select * from sakila.customer;
select * from sakila.rental;

select c.first_name, c.last_name, c.customer_id, count(r.rental_id) as Rental_count
from sakila.customer c
left join sakila.rental r on r.customer_id = c.customer_id
group by c.first_name, c.last_name, c.customer_id
order by Rental_count asc;

-- 3
select * from sakila.film;
select * from sakila.film_category;
select * from sakila.category;

select f.film_id, f.title, c.name
from sakila.film f 
left join sakila.film_category fc on fc.film_id = f.film_id
left join sakila.category c on c.category_id = fc.category_id;

-- 4
select * from sakila.customer;
select * from sakila.staff;

select c.email
from sakila.customer c
left join sakila.staff s on s.email = c.email
union
select s.email
from sakila.staff s
right join sakila.customer c on c.email = s.email ;
 -- or
select c.email
from sakila.customer c
union
select s.email
from sakila.staff s;

-- 5
select * from sakila.actor;
select * from sakila.film;
select * from sakila.film_actor;

select a.first_name, a.last_name, f.title
from sakila.actor a
join sakila.film_actor fa on fa.actor_id = a.actor_id
join sakila.film f on f.film_id = fa.film_id
where f.title = 'ACADEMY DINOSAUR';

-- 6
select * from sakila.staff;
select * from sakila.store;

SELECT s.store_id,COUNT(sf.staff_id) AS staff_count
FROM sakila.store AS s
LEFT JOIN sakila.staff AS sf ON s.store_id = sf.store_id
GROUP BY s.store_id;

-- 7

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_rentals
FROM sakila.customer AS c
JOIN sakila.rental AS r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(r.rental_id) > 5
ORDER BY total_rentals DESC;