/*
1. Identify if there are duplicates in Customer table. Don't use customer id to check the duplicates
2. Number of times letter 'a' is repeated in film descriptions
3. Number of times each vowel is repeated in film descriptions 
4. Display the payments made by each customer
        1. Month wise
        2. Year wise
        3. Week wise
5. Check if any given year is a leap year or not. You need not consider any table from sakila database. Write within the select query with hardcoded date
6. Display number of days remaining in the current year from today.
7. Display quarter number(Q1,Q2,Q3,Q4) for the payment dates from payment table. 
8. Display the age in year, months, days based on your date of birth. 
   For example: 21 years, 4 months, 12 days
*/
-- 1
select * from sakila.customer;

select first_name, last_name , count(*) as Duplicate_count
from sakila.customer
group by first_name, last_name
having count(*) > 1;

-- 2
select * from sakila.film;

select film_id, title, description,
	   char_length(description) - char_length(replace(description,'a','')) as Char_count_of_A
from sakila.film;

-- 3

select film_id, title, description,
		char_length(description) - char_length(replace(description,'a','')) as Char_count_of_A,
        char_length(description) - char_length(replace(description,'e','')) as Char_count_of_E,
        char_length(description) - char_length(replace(description,'i','')) as Char_count_of_I,
        char_length(description) - char_length(replace(description,'o','')) as Char_count_of_O,
        char_length(description) - char_length(replace(description,'u','')) as Char_count_of_U
from sakila.film;

-- 4
select * from sakila.payment;

-- Raw payments for weekwise, monthly, yearly. 
select customer_id, payment_date, week(payment_date) as Payment_weekly ,month(payment_date) as Payment_monthly, year(payment_date) as Payment_yearly 
from sakila.payment;

-- Month wise
select customer_id, payment_date,month(payment_date) as Payment_monthly, year(payment_date) as Payment_yearly, sum(amount) as Total_amount 
from sakila.payment
group by customer_id,payment_date,month(payment_date), year(payment_date)
order by customer_id,payment_date,month(payment_date), year(payment_date);
-- Year wise
select customer_id, payment_date, year(payment_date) as Payment_yearly, sum(amount) as Total_amount
from sakila.payment
group by customer_id,payment_date,year(payment_date)
order by customer_id,payment_date,year(payment_date);
-- week wise
select customer_id, payment_date,week(payment_date) as Payment_weekly, month(payment_date) as Payment_monthly, year(payment_date) as Payment_yearly, sum(amount) as Total_amount
from sakila.payment
group by customer_id,payment_date,week(payment_date), month(payment_date), year(payment_date)
order by customer_id,payment_date,week(payment_date), month(payment_date), year(payment_date);

-- 5
	select 
			case
				when( year % 400 = 0)
					or ( year % 4 = 0 and year % 100 <> 0)
					then 'Leap Year'
				else 'Not a Leap year'
			end as leap_year_result
	from ( select 2400 as year )as yr ;

-- 6 

select dayofyear((curdate()));

select year(curdate());

select datediff( concat(year(curdate()), '-12-31'), curdate())as Days_remaining;

-- 7
select * from sakila.payment;

select *,
		case
			when month(payment_date) < 4 then 'Q1'
			when month(payment_date) between 4 and 6 then 'Q2'
			when month(payment_date) between 7 and 9 then 'Q3'
			when month(payment_date) between 10 and 12 then 'Q4'
		else null
        end as Quater
from sakila.payment;
            
-- 8
/* DATE_ADD(date, INTERVAL value unit)
SELECT DATE_ADD('2017-06-15', INTERVAL 10 DAY);
-- Result: '2017-06-25'
*/

select 	
		timestampdiff(year, dob, curdate()) as years,
        timestampdiff(month,dob, curdate()) - (timestampdiff(year, dob, curdate()) *12) as months,
        datediff( curdate(),
				 date_add( date_add( dob, interval timestampdiff(year, dob, curdate()) year), 
                           interval 
                           (timestampdiff(month,dob, curdate()) - (timestampdiff(year, dob, curdate()) *12))  month)
				) as days
from ( select '2002-09-12' as dob) as date_of_birth ;