-- subquery is like a nested query inside another query.
/*
when do we use subquery the most:
you need a value that depends on another query
you want to filter based on aggregated results
you want to avoid complex joins
when we need a temporary table for further processing.
*/
select actor_id, first_name, last_name
from sakila.actor
where actor_id in(
				select actor_id
                from sakila.film_actor
                group by actor_id
                having count(film_id) > 10
                );


select actor_id, first_name, last_name,
		( select count(*) 
		  from sakila.film_actor fa
          where fa.actor_id = actor.actor_id) as Film_count
from sakila.actor;

select a.actor_id, a.first_name, a.last_name, fa.Film_count
from sakila.actor a
JOIN(
	select actor_id, count(film_id) as Film_count
    from sakila.film_actor
    group by actor_id
    having count(film_id) > 10
    )fa on a.actor_id = fa.actor_id;
    
select customer_id, total_spend
from 
	( select customer_id, sum(amount) as Total_spend
	  from sakila.payment
      group by customer_id
      order by Total_spend desc
      )as Top_customers;



select *
from (
		select last_name,
				case 
					when left(last_name,1) between 'A' and 'M' then 'Group A-M'
					when left(last_name,1) between 'N' and 'Z' then 'Group N-Z'
				END as Group_label
		from sakila.customer
        ) as Grouped_customers
where Group_label = 'Group N-Z';
        
select customer_id, amount
from sakila.payment
where amount > 
				( select avg(amount)
                  from sakila.payment
				);
        
select first_name,
				( select address_id, address
                  from sakila.address
                  where address = 'California'
				) as Cali_address
from sakila.customer;

/*
-- correlated Subquery.
Its a subquery that depends on the current row of the outer Query
- A normal subquery runs once.
- A correlated subquery runs once per row of the outer Query.
    When to use it--
    when you need a row-by row comparison
    you want to compute something specific to each row.
    joins or window functions feel too heavy for the task
    
    Example: Find whose salary is greater than the average salary of their own department.
    SELECT e.employee_id, e.name, e.salary, e.department_id
    FROM employees e
    WHERE e.salary >
      (SELECT AVG(salary)
       FROM employees
       WHERE department_id = e.department_id);
*/

select title, 
			 (select count(*)
              from sakila.film_actor fa
              where fa.actor_id = f.film_id
              ) as Actor_count
from sakila.film f;


select payment_id, customer_id, amount, payment_date
from sakila.payment p1
where amount > 
				( select avg(amount)
                 from sakila.payment p2
                 where p2.customer_id = p2.customer_id
                 );
                 
