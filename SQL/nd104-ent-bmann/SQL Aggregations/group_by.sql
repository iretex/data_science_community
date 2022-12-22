SELECT account_id,
       SUM(standard_qty) AS standard,
       SUM(gloss_qty) AS gloss,
       SUM(poster_qty) AS poster
FROM orders
GROUP BY account_id
ORDER BY account_id

------------------------------------------
-- GROUP BY Note
------------------------------------------
-- Now that you have been introduced to JOINs, GROUP BY, and aggregate functions, the real power of SQL 
-- starts to come to life. Try some of the below to put your skills to the test!

------------------------------------------
-- Questions: GROUP BY
------------------------------------------
-- Use the SQL environment below to assist with answering the following questions. Whether you get stuck 
-- or you just want to double-check your solutions, my answers can be found at the top of the next concept.

-- One part that can be difficult to recognize is when it might be easiest to use an aggregate or one of 
-- the other SQL functionalities. Try some of the below to see if you can differentiate to find the 
-- easiest solution.

-- Which account (by name) placed the earliest order? Your solution should have the account name and the 
-- date of the order.
SELECT a.id, a.name, o.occurred_at
FROM orders o
LEFT JOIN accounts a
ON o.account_id = a.id
WHERE o.occurred_at = (SELECT MIN(occurred_at) FROM orders)

-- Find the total sales in usd for each account. You should include two columns - the total sales for 
-- each company's orders in usd and the company name.
SELECT a.name, SUM(o.total_amt_usd) total_sales
FROM orders o
LEFT JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY SUM(o.total_amt_usd) DESC

-- Via what channel did the most recent (latest) web_event occur, 
-- which account was associated with this web_event? Your query should return only three values - the 
-- date, channel, and account name.
SELECT w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
WHERE w.occurred_at = (SELECT MAX(occurred_at) FROM web_events)

-- Find the total number of times each type of channel from the web_events was used. Your final table 
-- should have two columns - the channel and the number of times the channel was used.
SELECT w.channel, count(*) no_times_used
FROM web_events w
GROUP BY w.channel

-- Who was the primary contact associated with the earliest web_event?
SELECT a.primary_poc
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE w.occurred_at = (SELECT MIN(occurred_at) FROM web_events)

-- What was the smallest order placed by each account in terms of total usd. Provide only two columns - 
-- the account name and the total usd. Order from smallest dollar amounts to largest.
SELECT a.name, MIN(o.total_amt_usd) smallest_order
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order

-- Find the number of sales reps in each region. Your final table should have two columns - the region 
-- and the number of sales_reps. Order from the fewest reps to most reps.

SELECT r.name, COUNT(s.id) no_sales_reps
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
GROUP BY r.name
ORDER By no_sales_reps

------------------------------------------
--Grouping By multiple Columns
------------------------------------------

SELECT account_id,
       channel,
       COUNT(id) as events
FROM web_events
GROUP BY account_id, channel
ORDER BY account_id, channel DESC

------------------------------------------
-- Questions: GROUP BY Part II
------------------------------------------
-- Use the SQL environment below to assist with answering the following questions. Whether you get stuck or you just want to double-check your solutions, my answers can be found at the top of the next concept.

-- For each account, determine the average amount of each type of paper they purchased across their orders. 
-- Your result should have four columns - one for the account name and one for the average quantity 
-- purchased for each of the paper types for each account.
SELECT 
    a.name, 
    AVG(standard_qty) standard_avg,
    AVG(gloss_qty) gloss_avg,
    AVG(poster_qty) poster_avg
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name

-- For each account, determine the average amount spent per order on each paper type. Your result should 
-- have four columns - one for the account name and one for the average amount spent on each paper type.
SELECT 
    a.name, 
    AVG(standard_amt_usd) standard_avg,
    AVG(gloss_amt_usd) gloss_avg,
    AVG(poster_amt_usd) poster_avg
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name

-- Determine the number of times a particular channel was used in the web_events table for each sales rep. 
-- Your final table should have three columns - the name of the sales rep, the channel, and the number of 
-- occurrences. Order your table with the highest number of occurrences first.
SELECT s.name, w.channel, COUNT(*) no_of_occurence
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name, w.channel
ORDER BY no_of_occurence DESC

-- Determine the number of times a particular channel was used in the web_events table for each region. 
-- Your final table should have three columns - the region name, the channel, and the number of occurrences. 
-- Order your table with the highest number of occurrences first.
SELECT r.name, w.channel, COUNT(*) no_of_occurence
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name, w.channel
ORDER BY no_of_occurence DESC
