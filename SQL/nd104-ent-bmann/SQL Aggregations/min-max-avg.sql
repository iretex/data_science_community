-- winget install --id Git.Git -e --source winget : powershell
USE nd104_ent_bmann

-- Questions: MIN, MAX, & AVERAGE
-- Use the SQL environment below to assist with answering the following questions. Whether you get stuck or you just want to double-check your solutions, my answers can be found at the top of the next concept.

-- When was the earliest order ever placed? You only need to return the date.
SELECT MIN(occurred_at) earliest_order_date 
FROM orders;

-- Try performing the same query as in question 1 without using an aggregation function.
SELECT TOP 1 occurred_at [earliest order date]
FROM orders
ORDER BY occurred_at
--LIMIT 1;

-- When did the most recent (latest) web_event occur?
SELECT max(occurred_at) [most recent web event]
FROM web_events

-- Try to perform the result of the previous query without using an aggregation function.
SELECT TOP 1 occurred_at
FROM web_events
ORDER BY occurred_at DESC

-- Find the mean (AVERAGE) amount spent per order on each paper type, 
-- as well as the mean amount of each paper type purchased per order. 
-- Your final answer should have 6 values - one for each paper type for the average number of sales, 
-- as well as the average amount.
SELECT 
    AVG(total_amt_usd) [avg amount], 
    AVG(standard_amt_usd) [avg standard],
    AVG(gloss_amt_usd) [avg gloss],
    AVG(poster_amt_usd) [avg poster]
FROM orders

-- Via the video, you might be interested in how to calculate the MEDIAN. 
-- Though this is more advanced than what we have covered so far try finding - what is the MEDIAN 
-- total_usd spent on all orders?
SELECT AVG(total_amt_usd) median_amount FROM (
SELECT TOP 2 *
FROM (SELECT TOP 3457 total_amt_usd
   FROM orders
   ORDER BY total_amt_usd
   ) AS Table1
ORDER BY total_amt_usd DESC
) q;

-- Since there are 6912 orders - we want the average of the 3457 and 3456 order amounts when ordered. This is the average of 2483.16 and 2482.55. This gives the median of 2482.855. This obviously isn't an ideal way to compute. If we obtain new orders, we would have to change the limit. SQL didn't even calculate the median for us. The above used a SUBQUERY, but you could use any method to find the two necessary values, and then you just need the average of them.

-- CREATE DATABASE nd104_ent_bmann;

-- Exec sp_defaultdb @loginame='login', @defdb='nd104_ent_bmann'

