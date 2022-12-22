-- CASE - Expert Tip
-- The CASE statement always goes in the SELECT clause.
-- CASE must include the following components: WHEN, THEN, and END. ELSE is an optional component to catch cases that didn’t meet any of the other previous CASE conditions.
-- You can make any conditional statement using any conditional operator (like WHERE) between WHEN and THEN. This includes stringing together multiple conditional statements using AND and OR.
-- You can include multiple WHEN statements, as well as an ELSE statement again, to deal with any unaddressed conditions.
-- Example
-- In a quiz question in the previous Basic SQL lesson, you saw this question:

-- Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order. Limit the results to the first 10 orders, and include the id and account_id fields. NOTE - you will be thrown an error with the correct solution to this question. This is for a division by zero. You will learn how to get a solution without an error to this query when you learn about CASE statements in a later section.
-- Let's see how we can use the CASE statement to get around this error.

SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price
FROM orders
LIMIT 10;

-- Now, let's use a CASE statement. This way any time the standard_qty is zero, we will return 0, and otherwise, we will return the unit_price.

SELECT account_id, CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
                        ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders
LIMIT 10;

-- Now the first part of the statement will catch any of those divisions by zero values that were causing the error, and the other components will compute the division as necessary. You will notice, we essentially charge all of our accounts 4.99 for standard paper. It makes sense this doesn't fluctuate, and it is more accurate than adding 1 in the denominator like our quick fix might have been in the earlier lesson.

-- You can try it yourself using the environment below.

-- Code from the Video
-- Query 1:

SELECT id,
       account_id,
       occurred_at,
       channel,
       CASE WHEN channel = 'facebook' THEN 'yes' END AS is_facebook
FROM web_events
ORDER BY occurred_at

-- Query 2:
SELECT id,
       account_id,
       occurred_at,
       channel,
       CASE WHEN channel = 'facebook' THEN 'yes' ELSE 'no' END AS is_facebook
FROM web_events
ORDER BY occurred_at

-- Query 3:
SELECT id,
       account_id,
       occurred_at,
       channel,
       CASE WHEN channel = 'facebook' OR channel = 'direct' THEN 'yes' 
       ELSE 'no' END AS is_facebook
FROM web_events
ORDER BY occurred_at

-- Query 4:
SELECT account_id,
       occurred_at,
       total,
       CASE WHEN total > 500 THEN 'Over 500'
            WHEN total > 300 THEN '301 - 500'
            WHEN total > 100 THEN '101 - 300'
            ELSE '100 or under' END AS total_group
FROM orders

-- Query 5
SELECT account_id,
       occurred_at,
       total,
       CASE WHEN total > 500 THEN 'Over 500'
            WHEN total > 300 AND total <= 500 THEN '301 - 500'
            WHEN total > 100 AND total <=300 THEN '101 - 300'
            ELSE '100 or under' END AS total_group
FROM orders

-- This one is pretty tricky. Try running the query yourself to make sure you understand what is happening. The next concept will give you some practice writing CASE statements on your own. In this video, we showed that getting the same information using a WHERE clause means only being able to get one set of data from the CASE at a time.

-- There are some advantages to separating data into separate columns like this depending on what you want to do, but often this level of separation might be easier to do in another programming language - rather than with SQL.

-- Code from the Video

-- Query1

SELECT CASE WHEN total > 500 THEN 'OVer 500'
            ELSE '500 or under' END AS total_group,
            COUNT(*) AS order_count
FROM orders
GROUP BY 1

-- Query2
SELECT COUNT(1) AS orders_over_500_units
FROM orders
WHERE total > 500

------------------------------------------
-- Questions: CASE
------------------------------------------
-- Use the SQL environment below to assist with answering the following questions. Whether you get stuck or you just want to double-check your solutions, my answers can be found at the top of the next concept.

-- Write a query to display for each order, the account ID, the total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.

-- Write a query to display the number of orders in each of three categories, based on the total number of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.

-- We would like to understand 3 different levels of customers based on the amount associated with their purchases. The top-level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.

-- We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the top spending customers listed first.
-- We would like to identify top-performing sales reps, which are sales reps associated with more than 200 orders. Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders. Place the top salespeople first in your final table.
-- The previous didn't account for the middle, nor the dollar amount associated with the sales. Management decides they want to see these characteristics represented as well. We would like to identify top-performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on these criteria. Place the top salespeople based on the dollar amount of sales first in your final table. You might see a few upset salespeople by this criteria!

------------------------------------------
-- Solutions: CASE
------------------------------------------

-- Write a query to display for each order, the account ID, the total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or less than $3000.

-- Write a query to display the number of orders in each of three categories, based on the total number of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.

SELECT CASE WHEN total >= 2000 THEN 'At Least 2000'
WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
ELSE 'Less than 1000' END AS order_category,
COUNT(*) AS order_count
FROM orders
GROUP BY 1;

-- We would like to understand 3 different branches of customers based on the amount associated with their purchases. The top branch includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second branch is between 200,000 and 100,000 usd. The lowest branch is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.
SELECT a.name, SUM(total_amt_usd) total_spent, 
  CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
  WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
  ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
GROUP BY a.name
ORDER BY 2 DESC;

-- We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the top spending customers listed first.
SELECT a.name, SUM(total_amt_usd) total_spent, 
  CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
  WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
  ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE occurred_at > '2015-12-31' 
GROUP BY 1
ORDER BY 2 DESC;

-- We would like to identify top-performing sales reps, which are sales reps associated with more than 200 orders. Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders. Place the top salespeople first in your final table. It is worth mentioning that this assumes each name is unique - which has been done a few times. We otherwise would want to break by the name and the id of the table.
-- The previous didn't account for the middle, nor the dollar amount associated with the sales. Management decides they want to see these characteristics represented as well. We would like to identify top-performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on these criteria. Place the top salespeople based on the dollar amount of sales first in your final table. You might see a few upset salespeople by this criteria!