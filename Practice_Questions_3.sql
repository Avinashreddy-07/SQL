/*
1. display all customer details who have made more than 5 payments.
2. Find the names of actors who have acted in more than 10 films.
3. Find the names of customers who never made a payment.
4. List all films whose rental rate is higher than the average rental rate of all films.
5. List the titles of films that were never rented.
6. Display the customers who rented films in the same month as customer with ID 5.
7. Find all staff members who handled a payment greater than the average payment amount.
8. Show the title and rental duration of films whose rental duration is greater than the average.
9. Find all customers who have the same address as customer with ID 1.
10. List all payments that are greater than the average of all payments.
*/

-- 1
select c.*,
	 ( select count(*) from sakila.payment p where c.customer_id = p.customer_id) as Payment_count
from sakila.customer c
where customer_id in ( 
		select customer_id
        from sakila.payment
        group by customer_id
        having count(payment_id) > 5);

-- 2
select * from sakila.actor;
select * from sakila.film_actor;
select * from sakila.film;

select a.actor_id, a.first_name, a.last_name,
		(select count(*) from sakila.film_actor fa where fa.actor_id = a.actor_id)as Film_count
from sakila.actor a
where actor_id in (
				select actor_id
                from sakila.film_actor fa
                group by actor_id
                having count(film_id) > 10
                );

-- 3
select * from sakila.customer;
select * from sakila.payment;

select c.customer_id, c.first_name, c.last_name
from sakila.customer c
where customer_id not in 
		( select p.customer_id
          from sakila.payment p 
          where p.customer_id = c.customer_id
          );

-- 4
select * from sakila.film;

select film_id, title, rental_rate, (select avg(rental_rate)from sakila.film)as Average_RentalRate
from sakila.film
where rental_rate > ( select avg(rental_rate) from sakila.film);

-- 5
select * from sakila.film;
select * from sakila.rental;
select * from sakila.inventory;

select f.film_id, f.title
from sakila.film f 
where f.film_id in
				( select i.film_id
                  from sakila.inventory i
                  where i.inventory_id not in
						( select r.inventory_id
                          from sakila.rental r
						)
				);

select f.film_id, f.title
from sakila.film f
where not exists
		( select 1
		  from sakila.inventory i
          join rental r on i.inventory_id = r.inventory_id
          where i.film_id = f.film_id
          );
      
-- 6
select * from sakila.customer;
select * from sakila.rental;

select *
from sakila.rental
where customer_id=5;

select c.customer_id, c.first_name
from sakila.customer c
where c.customer_id in
		  ( select r.customer_id
			from sakila.rental r 
			where month(r.rental_date) in 
            ( select month(r1.rental_date) 
			 from sakila.rental r1
             where customer_id=5)
		  );
                  
 -- 7
 select * from sakila.staff;
 select * from sakila.payment;

select distinct s.staff_id, s.first_name
from sakila.staff s
join payment p on s.staff_id = p.staff_id
where p.amount >
		( select avg(amount)
          from payment 
          );

-- 8
select * from sakila.film;
 
select f1.title
from sakila.film f1
where f1.rental_duration > 
			( select avg(rental_duration)
              from sakila.film
              );
              
 -- 9
select * from sakila.address;
select * from sakila.customer;

select c.customer_id, c.first_name, c.last_name
from sakila.customer c
where c.address_id = (
        select address_id
        from sakila.customer
        where customer_id = 1
      );

-- 10 
select * from sakila.payment;

select *
from sakila.payment
where amount >
		( select avg(amount)
		  from sakila.payment);

