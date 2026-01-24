/*
SQL Practice Questions
---------------------------------

1. Get all customers whose first name starts with 'J' and who are active.

2. Find all films where the title contains the word 'ACTION' or the description contains 'WAR'.

3. List all customers whose last name is not 'SMITH' and whose first name ends with 'a'.

4. Get all films where the rental rate is greater than 3.0 and the replacement cost is not null.

5. Count how many customers exist in each store who have active status = 1.

6. Show distinct film ratings available in the film table.

7. Find the number of films for each rental duration where the average length is more than 100 minutes.

8. List payment dates and total amount paid per date, but only include days where more than 100 payments were made.

9. Find customers whose email address is null or ends with '.org'.

10. List all films with rating 'PG' or 'G', and order them by rental rate in descending order.

11. Count how many films exist for each length where the film title starts with 'T' and the count is more than 5.

12. List all actors who have appeared in more than 10 films.

13. Find the top 5 films with the highest rental rates and longest lengths combined, ordering by rental rate first and length second.

14. Show all customers along with the total number of rentals they have made, ordered from most to least rentals.

15. List the film titles that have never been rented.
*/

-- 1
select * from sakila.customer
where first_name like 'J%' and active = 1;

-- 2
select * from sakila.film
where title like '%ACTION%' or description like '%WAR%';

-- 3
select * from sakila.customer
where last_name <> 'SMITH' and first_name like '%a';

-- 4
select * from sakila.film 
where rental_rate > 3.0 and replacement_cost is not null;

-- 5
select store_id, count(*) 
from sakila.customer
where active = 1
group by store_id ;

-- 6
select distinct rating from sakila.film;

-- 7
select rental_duration, avg(length) as Avg_length , count(*) as No_of_films
from sakila.film
group by rental_duration
having avg(length) > 100;

-- 8
select date(payment_date), sum(amount) as Total_amount, count(amount) as No_of_payments
from sakila.payment
group by date(payment_date)
having count(amount) > 100;

-- 9
select * from sakila.customer
where email is null or email like '%.org';

-- 10
select * from sakila.film 
where rating = 'PG'or rating = 'G'
order by rental_rate desc;

-- 11
select length, count(*) as No_of_films
from sakila.film
where title like 'T%'
group by length
having count(*) > 5;

-- 12
select actor_id, count(*) as Film_count
from sakila.film_actor
group by actor_id
having count(*) > 10;

-- 13
select *
from sakila.film
order by rental_rate desc, length desc
limit 5 ;

-- 14
select customer_id, count(*) as No_of_Rentals
from sakila.rental
group by customer_id
order by No_of_Rentals desc;

-- 15
select * 
from sakila.film
where rental_duration <1 ;
-- My assumption if there is no duration that means its not rented.



