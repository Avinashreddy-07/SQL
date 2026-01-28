-- STRINGS
select title from sakila.film;

-- LPAD, RPAD
select title, RPAD(title, 20, '*') as Left_Padded
from sakila.film
limit 5;

select title, LPAD(RPAD(title, 20, '*'), 25 , '*') as Middle_padded
from sakila.film
limit 5;

-- Substring
select title, substring(title, 1, 10) as Substring
from sakila.film;

-- concatination
select concat(first_name, '.', last_name) as Full_name
from sakila.customer;

-- Reverse()
select title, reverse(title) as Reverse_Title
from sakila.film;

-- length
select title, length(title) as Length_Title
from sakila.film;

-- substring with locate
select locate('@',email) as Email
from sakila.customer;

select email, substring(email, locate('@',email) +1) as Email_Domain
from sakila.customer;

-- substring_index
select substring_index(email,'@',1)
from sakila.customer;

select email, substring_index( substring(email, locate('@',email) +1), '.', -1) as Domain
from sakila.customer;

select email, substring_index( substring(email, 1, locate('@',email) -1), '.', -1) as Last_name
from sakila.customer;

-- UPPER(), LOWER() 
select title, UPPER(title), lower(title)
from sakila.film
WHERE UPPER(title) LIKE '%one%';

-- LEFT(), RIGH()
select left(title,2) as First_name, right(title,3) as Last_name, count(*) as Film_count
from sakila.film
group by left(title,2), right(title,3)
order by film_count DESC;

-- CASE command is used to create different output based on the conditions.
/* EXAMPLE:
CASE
    WHEN Quantity > 30 THEN 'The quantity is greater than 30'
    WHEN Quantity = 30 THEN 'The quantity is 30'
    ELSE 'The quantity is under 30'
END
*/
select last_name,
		case
			when left(last_name, 1) between 'A' and 'M' then 'Group A-M'
            when left(last_name, 1) between 'N' and 'Z' then 'Group N-Z'
		Else 
			'other'
		END as Group_Label
from sakila.customer;

-- REPLACE
select title, REPLACE(title, 'A', 'X') as cleaned_title
from sakila.film
where title Like 'A%' '%';

-- contains 2 consecutive vowels
select customer_id, last_name, first_name
from sakila.customer
where last_name regexp '[aeiouAEIOU] {3}' 
	or first_name regexp '[aeiouAEIOU]{3}';
    
/*
- ^A → matches any string starting with A
- ^AL → matches any string starting with AL
- ^[AL] → matches any string starting with either A or L
- [^AL] → match any character except A or L
- ^[^BA] → matches any string other than starting with A and B  ( not BA , not b and  not A)

Difference between [^AL] and ^[^AL] is
[^AL] - Match any single character except A or L (anywhere) ( A can come and other character, or L can come and other character) 
^[^AL] - Match strings whose first character is NOT A or L (Both).

*/
-- ends with Vowel
select lower(title) as Title
from sakila.film
where lower(title) regexp '[aeiou]$';

-- right(title,2)
select title, left(title,2)
from sakila.film
where left(title,2) regexp '[^AL]';

-- Both cannot come ^[^xx]
select title, left(title,2)
from sakila.film
where left(title,2) regexp '^[^BA]';

-- starts with both AL at a time
select title, left(title,2)
FROM sakila.film
WHERE left(title,2) REGEXP '^AL' ;

-- count
select left(title, 1), count(*)
from sakila.film
where title regexp '[aeiouAEIOU]$'
group by left(title,1);

-- ^ is XOR (bitwise XOR)
/*
rental_rate is 0.99 -> 1
               4.99 -> 5
 1 XOR 3 is 2
 5 XOR 3 is 6
*/
SELECT title, rental_rate, rental_rate ^ 3 AS double_rate 
FROM sakila.film;

-- POW
SELECT title, rental_rate, POW(rental_rate, 3) AS Triple_rate 
FROM sakila.film;

-- Avg 
select customer_id, count(payment_id) as payments, sum(amount) as total_paid, sum(amount)/count(payment_id) as Average_payments
from sakila.payment
group by customer_id
order by Average_payments desc;

select customer_id, count(payment_id) as payments, sum(amount) as total_paid, sum(amount)/count(payment_id) as Average_payments
from sakila.payment
group by customer_id
order by Average_payments desc;

-- UPDATE, ALTER, SET
select * from sakila.film;

ALTER table sakila.film
ADD column Cost_efficiency_01 decimal(6,2);

SET sql_safe_updates =0;

UPDATE sakila.film
set cost_efficiency_01 = rental_duration * 2
where length is not null;

select * from sakila.film;

-- DROP column
ALter table sakila.film
drop column Cost_efficienct_1,
drop column Cost_efficiency_1;

select * from sakila.film;

-- Random 
select customer_id, (RAND() * 100) as Random_score , Floor(RAND() * 100) as FLOOR_Random_Score
from sakila.customer
limit 5;

-- MODulous(%)
select film_id, length, MOD(length,60) as Minutes_over_hour
from sakila.film;

-- ceil
select rental_rate, ceil(rental_rate) as ceil_value, Floor(rental_rate) as Floor_value
from sakila.film;

select rental_rate, ROUND(2.79, 0), Round(2.79, 1)
from sakila.film;

-- DATE DIFF
select rental_id, rental_date, return_date, datediff(return_date, rental_date) as Days_rented 
from sakila.rental
where return_date is not null 
and rental_date is not null;

select payment_date, date(payment_date) as Date_payed, amount
from sakila.payment
order by Date_payed desc;

select payment_date, date(payment_date) as Date_payed, sum(amount) as Total_amount
from sakila.payment
group by payment_date, date(payment_date)
order by Date_payed desc;

-- customers who paid in the last 24 hrs
select * from sakila.payment;

select payment_id, customer_id, amount, date(payment_date)
from sakila.payment
where date(payment_date) >= curdate() - interval 1 day;

-- -  finds the latest (most recent) payment_date
select max(payment_date) FROM sakila.payment;


-- find 10 day payment record dates from the last payment --  doubt
select payment_id, customer_id, amount, payment_date
from sakila.payment
where payment_date >= (
					select max(payment_date) - interval 50 day
					from sakila.payment
	);

select now()  - INTERVAL 1 DAY as yesterday;

-- concatination with date
select concat('Today is:', curdate()) as Message;
select concat('Today is:', now()) as Message;
select curdate(), current_time(), now();

-- casting 

select concat(cast(amount as char),' is decimal')
from sakila.payment;

-- 

alter table sakila.payment
add column amount_string varchar(20);

set sql_safe_updates = 0;

update sakila.payment 
set amount_string = cast( amount as char);

select * from sakila.payment;

select concat(amount_string, ' is the amount as string')
from sakila.payment; 

select amount, amount_string, amount+10 , amount_string+10
from sakila.payment
limit 5;

select cast('2026-01-24' as datetime);