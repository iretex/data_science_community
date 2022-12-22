-- HAVING - Expert Tip
-- HAVING is the “clean” way to filter a query that has been aggregated, but this is also commonly done using a subquery. Essentially, any time you want to perform a WHERE on an element of your query that was created by an aggregate, you need to use HAVING instead.

-- Code from the Video
-- Query 1:
SELECT account_id,
       SUM(total_amt_usd) AS sum_total_amt_usd
FROM orders
GROUP BY 1
ORDER BY 2 DESC

-- Query 2: Results in an Error
SELECT account_id,
       SUM(total_amt_usd) AS sum_total_amt_usd
FROM orders
WHERE SUM(total_amt_usd) >= 250000
GROUP BY 1
ORDER BY 2 DESC

-- Query 3:
SELECT account_id,
       SUM(total_amt_usd) AS sum_total_amt_usd
FROM orders
GROUP BY account_id--1
HAVING SUM(total_amt_usd) >= 250000

------------------------------------------
-- Questions: HAVING
------------------------------------------
-- Use the SQL environment below to assist with answering the following questions. Whether you get stuck or you just want to double-check your solutions, my answers can be found at the top of the next concept.

-- How many of the sales reps have more than 5 accounts that they manage?

-- How many accounts have more than 20 orders?

-- Which account has the most orders?

-- Which accounts spent more than 30,000 usd total across all orders?

-- Which accounts spent less than 1,000 usd total across all orders?

-- Which account has spent the most with us?

-- Which account has spent the least with us?

-- Which accounts used facebook as a channel to contact customers more than 6 times?

-- Which account used facebook most as a channel?

-- Which channel was most frequently used by most accounts?

------------------------------------------
-- Solutions: HAVING
------------------------------------------
-- How many of the sales reps have more than 5 accounts that they manage?

SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY num_accounts;
-- and technically, we can get this using a SUBQUERY as shown below. This same logic can be used for the other queries, but this will not be shown.

SELECT COUNT(*) num_reps_above5
FROM(SELECT s.id, s.name, COUNT(*) num_accounts
     FROM accounts a
     JOIN sales_reps s
     ON s.id = a.sales_rep_id
     GROUP BY s.id, s.name
     HAVING COUNT(*) > 5
     ORDER BY num_accounts) AS Table1;
-- How many accounts have more than 20 orders?


SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20
ORDER BY num_orders;
-- Which account has the most orders?

SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY num_orders DESC
LIMIT 1;
-- How many accounts spent more than 30,000 usd total across all orders?

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent;
-- How many accounts spent less than 1,000 usd total across all orders?

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent;
-- Which account has spent the most with us?

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1;
-- Which account has spent the least with us?

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent
LIMIT 1;
-- Which accounts used facebook as a channel to contact customers more than 6 times?

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY use_of_channel;
-- Which account used facebook most as a channel?

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 1;
-- Note: This query above only works if there are no ties for the account that used facebook the most. It is a best practice to use a larger limit number first such as 3 or 5 to see if there are ties before using LIMIT 1.

-- Which channel was most frequently used by most accounts?
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;
-- All of the top 10 are direct.