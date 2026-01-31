-- Joins

select * from sakila.film;
select * from sakila.language;
-- Inner Join
select f.title, L.name as Language
from sakila.film f
inner join sakila.language L on L.language_id = f.language_id;

select * from sakila.customer;
select * from rental;
-- Inner Join
select c.first_name, c.email, r.rental_id
from sakila.customer c
inner join rental r 
on c.customer_id = r.customer_id;

-- left join
select c.customer_id, c.first_name, r.rental_id
from sakila.customer c
left join sakila.rental r 
on c.customer_id = r.customer_id;

select * from film f;
select * from category;
select * from film_category;

select f.title, c.name
from sakila.film f
left join film_category fc on f.film_id = fc.film_id -- It is the bridge table for film and category.
left join category c on fc.category_id = c.category_id;

-- Fullouter join
-- MySQL doesnot support Fullouter Join, so you must combine left join and right join using UINON.
-- List all actors and the films they’ve acted in (even if unmatched on either side
 select * from actor;
 select * from film;
  select * from film_actor;
  
select a.actor_id, a.first_name, a.last_name, f.title, f.film_id
from sakila.actor a
left join film_actor fc on a.actor_id = fc.actor_id
left join film f on f.film_id = fc.film_id
union
select a.actor_id, a.first_name, a.last_name, f.title, f.film_id
from sakila.actor a
right join film_actor fc on a.actor_id = fc.actor_id
right join film f on f.film_id = fc.film_id;

-- List all customers and all rentals, including those without each other
select * from sakila.customer;
select * from sakila.rental;

select c.customer_id, c.first_name, r.rental_id, r.rental_date
from sakila.customer c
left join rental r on c.customer_id = r.customer_id
union
select c.customer_id, c.first_name, r.rental_id, r.rental_date
from sakila.customer c
right join rental r on c.customer_id = r.customer_id;

-- self join

select * from sakila.staff;

select s.staff_id, s.first_name
from sakila.staff s
join sakila.staff s1 on s.store_id = s1.store_id
where s.staff_id <> s1.staff_id;

-- create the staff_demo table
create table sakila.staff_demo (
	staff_id int primary key,
    first_name varchar(50),
    store_id int
);
-- insert data 
insert into sakila.staff_demo(staff_id, first_name, store_id) values
	(1,'Alice',2),
    (2,'Bob',1),
    (3,'Charlie',2),
    (4,'Demon',2),
    (5,'Elizah',1);

select * from sakila.staff_demo;

-- Run a self join: find staff pairs working in the same store
select s.staff_id, s.first_name, s.store_id
from sakila.staff_demo s
join sakila.staff_demo s1 on s.store_id = s1.store_id;


SELECT 
    s1.staff_id AS staff_1_id,
    s1.first_name AS staff_1_name,
    s2.staff_id AS staff_2_id,
    s2.first_name AS staff_2_name,
    s1.store_id
FROM sakila.staff_demo s1
JOIN sakila.staff_demo s2
  ON s1.store_id = s2.store_id
  AND s1.staff_id <> s2.staff_id
ORDER BY s1.store_id, s1.staff_id;


-- where exists / inner join
select distinct p.customer_id, p.rental_id
from sakila.payment p
where exists(
	  select 1
      from sakila.rental r
      where r.customer_id = p.customer_id
      );

-- 1 = 0 (means false)
SELECT s.email FROM sakila.customer c
LEFT JOIN sakila.staff s ON 1 = 0 -- ( this will give null values)
UNION
SELECT s.email FROM sakila.staff s
LEFT JOIN sakila.customer c ON 1 = 0;-- ( this will give emails )