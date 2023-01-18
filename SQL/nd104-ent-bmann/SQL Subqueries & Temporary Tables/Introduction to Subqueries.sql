-----------------------------------------------
-- find the number of events that occur for each day for each channel.
-----------------------------------------------
SELECT DATETRUNC(day,occurred_at) day, channel, count(*) no_of_events
FROM web_events
GROUP BY channel, DATETRUNC(day,occurred_at)
ORDER BY no_of_events DESC

-----------------------------------------------
-- Create a subquery that simply provides all of the data from your first query
-----------------------------------------------
SELECT *, COUNT(*) no_of_events
FROM
(
    SELECT DATETRUNC(day,occurred_at) day, channel
    FROM web_events
) sq
GROUP BY day, channel
ORDER BY no_of_events DESC

-----------------------------------------------
-- Find the average number of events for each channel. Avg per day
-----------------------------------------------
SELECT channel, SUM(no_of_events),COUNT(occurred_at_day) av,FORMAT(AVG(no_of_events),'0.00') avg_daily_events
FROM (
    SELECT *, COUNT(*) no_of_events
    FROM
    (
        SELECT DATETRUNC(day,occurred_at) occurred_at_day, channel
        FROM web_events  
    ) sq
    WHERE channel = (SELECT TOP 1 channel FROM web_events)
    GROUP BY occurred_at_day, channel
    -- ORDER BY no_of_events DESC
) sq2
GROUP BY channel
ORDER By avg_daily_events DESC

-- Solutions to Your First Subquery
-- First, we needed to group by the day and channel. Then ordering by the number of events (the third column) gave us a quick way to answer the first question.

SELECT DATE_TRUNC('day',occurred_at) AS day,
       channel, COUNT(*) as events
FROM web_events
GROUP BY 1,2
ORDER BY 3 DESC;
-- Here you can see that to get the entire table in question 1 back, we included an * in our SELECT statement. You will need to be sure to alias your table.

SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
          FROM web_events 
          GROUP BY 1,2
          ORDER BY 3 DESC) sub;
-- Finally, here we are able to get a table that shows the average number of events a day for each channel.

SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
         FROM web_events 
         GROUP BY 1,2) sub
GROUP BY channel
ORDER BY 2 DESC;


SELECT AVG(standard_qty) sq, AVG(gloss_qty) gq, AVG(poster_qty) pq 
FROM orders
WHERE DATETRUNC(month,occurred_at) =
 (SELECT DATETRUNC(month,MIN(occurred_at)) AS min_month
-- WHERE DATE_TRUNC('month',occurred_at) =
--  (SELECT DATE_TRUNC('month',MIN(occurred_at)) AS min_month
  FROM orders)
-- ORDER BY occurred_at

-- Queries Needed to Find the Solutions to the Previous Quiz
-- Here is the necessary quiz to pull the first month/year combo from the orders table.
SELECT DATE_TRUNC('month', MIN(occurred_at)) 
FROM orders;

-- Then to pull the average for each, we could do this all in one query, but for readability, I provided two queries below to perform each separately.
SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);

SELECT SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
      (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);


-- Simple Subquery
WITH dept_average AS 
  (SELECT dept, AVG(salary) AS avg_dept_salary
   FROM employee
   GROUP BY employee.dept
  )
SELECT E.eid, E.ename, D.avg_dept_salary
FROM employee E
JOIN dept.average D
ON E.dept = D.dept
WHERE E.salary > D.avg_dept_salary


-- What is the top channel used by each account to market products?
-- How often was that same channel used?
-- However, we will need to do two aggregations and two subqueries to make this happen.

-- Let's find the number of times each channel is used by each account.

-- So we will need to count the number of rows by Account and Channel. This count will be our first aggregation needed.

SELECT accounts.name, web_events.channel, Count(*) channel_freq
FROM accounts
JOIN web_events ON accounts.id = Web_events.account_id
GROUP BY accounts.name, web_events.channel
ORDER BY accounts.name, channel_freq DESC

-- Ok, now we have how often each channel was used by each account. How do we only return the most used account (or accounts if multiple are tied for the most)?
-- We need to see which usage of the channel in our first query is equal to the maximum usage channel for that account. So, a keyword should jump out to you - maximum. This will be our second aggregation and it utilizes the data from the first table we returned so this will be our subquery. Let's take the maximum count from each account to create a table with the maximum usage channel amount per account.
SELECT T1.name, max(T1.channel_freq)
FROM (
  SELECT accounts.name, web_events.channel, Count(*) channel_freq
  FROM accounts
  JOIN web_events ON accounts.id = Web_events.account_id
  GROUP BY accounts.name, web_events.channel
  -- ORDER BY accounts.name, channel_freq DESC
) T1
GROUP BY T1.name



-- Final
SELECT T3.*
FROM (
  SELECT accounts.name, web_events.channel, Count(*) channel_freq
  FROM accounts
  JOIN web_events ON accounts.id = Web_events.account_id
  GROUP BY accounts.name, web_events.channel
  -- ORDER BY accounts.name, channel_freq DESC
) T3

JOIN (
  SELECT T1.name, max(T1.channel_freq) freq
  FROM (
    SELECT accounts.name, web_events.channel, Count(*) channel_freq
    FROM accounts
    JOIN web_events ON accounts.id = Web_events.account_id
    GROUP BY accounts.name, web_events.channel
    -- ORDER BY accounts.name, channel_freq DESC
  ) T1
  GROUP BY T1.name
) T2
ON T3.name = T2.name
AND T3.channel_freq = T2.freq
ORDER BY T3.name, T3.channel_freq DESC

-- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
-- Step 1
-- First, I wanted to find the total_amt_usd totals associated with each sales rep, and I also wanted the region in which they were located. The query below provided this information.
SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY s.name,r.name
ORDER BY total_amt DESC;

-- Next, I pulled the max for each region, and then we can use this to pull those rows in our final result.
SELECT region_name, MAX(total_amt) total_amt
     FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY s.name, r.name) t1
     GROUP BY region_name;

-- Essentially, this is a JOIN of these two tables, where the region and amount match.
SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM(SELECT region_name, MAX(total_amt) total_amt
     FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY s.name,r.name) t1
     GROUP BY region_name) t2
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
     FROM sales_reps s
     JOIN accounts a
     ON a.sales_rep_id = s.id
     JOIN orders o
     ON o.account_id = a.id
     JOIN region r
     ON r.id = s.region_id
     GROUP BY s.name,r.name
    --  ORDER BY total_amt DESC) t3
    ) t3
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;


--  For the region with the largest sales total_amt_usd, how many total orders were placed?

-- The first query I wrote was to pull the total_amt_usd for each region.
SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name;

-- Then we just want the region with the max amount from this table. There are two ways I considered getting this amount. One was to pull the max using a subquery. Another way is to order descending and just pull the top value.
SELECT MAX(total_amt)
FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY r.name) sub;

-- Finally, we want to pull the total orders for the region with this amount:
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
      SELECT MAX(total_amt)
      FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
              FROM sales_reps s
              JOIN accounts a
              ON a.sales_rep_id = s.id
              JOIN orders o
              ON o.account_id = a.id
              JOIN region r
              ON r.id = s.region_id
              GROUP BY r.name) sub);

-- How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?

-- First, we want to find the account that had the most standard_qty paper. The query here pulls that account, as well as the total amount:
SELECT TOP 1 a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name
ORDER BY total_std DESC
-- LIMIT 1;

-- Now, I want to use this to pull all the accounts with more total sales:
SELECT a.name
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
HAVING SUM(o.total) > (SELECT total 
                   FROM (SELECT TOP 1 a.name act_name, SUM(o.standard_qty) total_std, SUM(o.total) total
                         FROM accounts a
                         JOIN orders o
                         ON o.account_id = a.id
                         GROUP BY a.name
                         ORDER BY total_std DESC
                         ) sub);

-- This is now a list of all the accounts with more total orders. We can get the count with just another simple subquery.
SELECT COUNT(*)
FROM (SELECT a.name
       FROM orders o
       JOIN accounts a
       ON a.id = o.account_id
       GROUP BY a.name
       HAVING SUM(o.total) > (SELECT total 
                   FROM (SELECT TOP 1 a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
                         FROM accounts a
                         JOIN orders o
                         ON o.account_id = a.id
                         GROUP BY a.name
                         ORDER BY tot_std DESC
                         ) inner_tab)
             ) counter_tab;

-- For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?

-- Here, we first want to pull the customer with the most spent in lifetime value.
SELECT TOP 1 a.id, a.name, SUM(o.total_amt_usd) tot_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY tot_spent DESC
-- LIMIT 1;

-- Now, we want to look at the number of events on each channel this company had, which we can match with just the id.
SELECT a.name, w.channel, COUNT(*) total_events
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (SELECT id
                     FROM (SELECT TOP 1 a.id, a.name, SUM(o.total_amt_usd) tot_spent
                           FROM orders o
                           JOIN accounts a
                           ON a.id = o.account_id
                           GROUP BY a.id, a.name
                           ORDER BY tot_spent DESC
                           ) inner_table)
GROUP BY a.name, w.channel
ORDER BY total_events DESC;

-- I added an ORDER BY for no real reason, and the account name to assure I was only pulling from one account.

--  What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

-- First, we just want to find the top 10 accounts in terms of highest total_amt_usd.
SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY 3 DESC
LIMIT 10;

-- Now, we just want the average of these 10 amounts.

SELECT AVG(tot_spent)
FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY a.id, a.name
      ORDER BY 3 DESC
       LIMIT 10) temp;

-- 6 What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.

-- First, we want to pull the average of all accounts in terms of total_amt_usd:

SELECT AVG(o.total_amt_usd) avg_all
FROM orders o

-- Then, we want to only pull the accounts with more than this average amount.

SELECT o.account_id, AVG(o.total_amt_usd)
FROM orders o
GROUP BY 1
HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_all
                               FROM orders o);