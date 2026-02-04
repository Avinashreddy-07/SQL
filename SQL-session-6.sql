-- CTE ( common tables expression) 
/*
It is a temporary set that exists only for the duration of a single query.
Think of it as creating a mini-table that you can reference just like a normal table -
but with-out permanently storing it in database. 

Why cte are useful
-improve readability
-reuse the same result
-enable recursion
-replace complex nested subqueries

*/
-- Example - Find customers who spent more than $100:

WITH customer_totals AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
)
SELECT customer_id, total_spent
FROM customer_totals
WHERE total_spent > 100;

-- Ex: Recusrsive CTE 
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM numbers
    WHERE n < 10
)
SELECT * FROM numbers;

-- Temporary Tables

/* Temporary Table in SQL- is a table that exists only for the duration of your session or 
transaction.
It behaves like a normal table - you can Insert, Update, Delete, Join, create Indexed ect..

why Temporary tables are useful ?
- store intermediate results
- improve performance (avoid recalculating expensive subqueries)
- reuse data multiple times
  ( unlike a CTE, which is read only and query-scoped, a temp table can be modified.)
- breakdown complex logic ( helpful in ETL or multi-step transformations)

- MySQL stores temporary tables in memory if they’re small.
- If they grow too large or contain certain data types, MySQL moves them to disk
 in its temporary directory.

*/
-- Example
CREATE TEMPORARY TABLE customer_rentals AS
SELECT customer_id, COUNT(*) AS rentals
FROM rental
GROUP BY customer_id;

SELECT customer_id
FROM customer_rentals
WHERE rentals > 5;

-- VIEWS
/* View is a saved SQL query that behaves like a Virtual table.
- It does not store data( except in materialized views)
- It stores only the query logic
- when you query the view, SQL reruns the underlying query

Why views are useful:
- Instead of repeating long joins or filters, you wrap them in a view
- improve readability
- provide security ( expose only safe columns to users, hiding sensitive data.)
-- Support BI tools- all like views because they provide stable, reusable data layers.
*/
-- A list of customers with their total payments.

CREATE VIEW customer_totals AS
SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id;

SELECT *
FROM customer_totals
WHERE total_spent > 100;



