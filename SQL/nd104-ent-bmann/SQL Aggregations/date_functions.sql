-- GROUPing BY a date column is not usually very useful in SQL, as these columns tend to have transaction data down to a second. Keeping date information at such granular levels is both a blessing and a curse, as it gives really precise information (a blessing), but it makes grouping information together directly difficult (a curse).

-- Lucky for us, there are a number of built-in SQL functions that are aimed at helping us improve our experience in working with dates.

-- Here we saw that dates are stored in the year, month, day, hour, minute, second, which helps us in truncating. In the next concept, you will see a number of functions we can use in SQL to take advantage of this functionality.

-- In this link, you can find the formatting of dates around the world, as referenced in the video.
-- https://en.wikipedia.org/wiki/Date_format_by_country

SELECT 
    occurred_at,
    DATETRUNC(second,occurred_at),
    DATETRUNC(day,occurred_at),
    DATETRUNC(month,occurred_at),
    DATETRUNC(year,occurred_at),
    SUM(standard_qty) AS standard_qty_sum
FROM orders
GROUP BY 
    occurred_at,
    DATETRUNC(day,occurred_at),
    DATETRUNC(day,occurred_at),
    DATETRUNC(month,occurred_at),
    DATETRUNC(year,occurred_at)
ORDER BY occurred_at

-- The first function you are introduced to in working with dates is DATE_TRUNC.

-- DATE_TRUNC allows you to truncate your date to a particular part of your date-time column. Common truncations are day, month, and year. Here is a great blog post by Mode Analytics on the power of this function.

-- DATE_PART can be useful for pulling a specific portion of a date, but notice pulling month or day of the week (dow) means that you are no longer keeping the years in order. Rather you are grouping for certain components regardless of which year they belonged in.

-- For additional functions you can use with dates, check out the documentation here, but the DATE_TRUNC and DATE_PART functions definitely give you a great start!

-- You can reference the columns in your select statement in GROUP BY and ORDER BY clauses with numbers that follow the order they appear in the select statement. For example

-- SELECT standard_qty, COUNT(*)

-- FROM orders

-- GROUP BY 1 (this 1 refers to standard_qty since it is the first of the columns included in the select statement)

-- ORDER BY 1 (this 1 refers to standard_qty since it is the first of the columns included in the select statement)

-- Code from the Video
-- Query 1:
SELECT occurred_at,
       SUM(standard_qty) AS standard_qty_sum
FROM orders
GROUP BY occurred_at
ORDER BY occurred_at

-- Query 2:
-- https://learn.microsoft.com/en-us/sql/t-sql/functions/datepart-transact-sql?view=sql-server-ver16
SELECT DATEPART(weekday,occurred_at) AS day_of_week,
       account_id,
       occurred_at,
       total
FROM orders

-- Query 3:
SELECT DATEPART(dw,occurred_at) AS day_of_week,
       SUM(total) AS total_qty
FROM orders
GROUP BY 1
ORDER BY 2


------------------------------------------
-- Questions: Working With DATEs
------------------------------------------
-- Use the SQL environment below to assist with answering the following questions. Whether you get stuck or you just want to double-check your solutions, my answers can be found at the top of the next concept.

-- Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?
-- Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?
-- Which year did Parch & Posey have the greatest sales in terms of the total number of orders? Are all years evenly represented by the dataset?
-- Which month did Parch & Posey have the greatest sales in terms of the total number of orders? Are all months evenly represented by the dataset?
-- In which month of which year did Walmart spend the most on gloss paper in terms of dollars?

------------------------------------------
-- Solutions: Working With DATEs
------------------------------------------
-- Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?
 SELECT DATE_PART('year', occurred_at) ord_year,  SUM(total_amt_usd) total_spent
 FROM orders
 GROUP BY 1
 ORDER BY 2 DESC;

-- When we look at the yearly totals, you might notice that 2013 and 2017 have much smaller totals than all other years. If we look further at the monthly data, we see that for 2013 and 2017 there is only one month of sales for each of these years (12 for 2013 and 1 for 2017). Therefore, neither of these is evenly represented. Sales have been increasing year over year, with 2016 being the largest sales to date. At this rate, we might expect 2017 to have the largest sales.

-- Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?
-- In order for this to be 'fair', we should remove the sales from 2013 and 2017. For the same reasons as discussed above.

SELECT DATE_PART('month', occurred_at) ord_month, SUM(total_amt_usd) total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC; 
-- The greatest sales amounts occur in December (12).

-- Which year did Parch & Posey have the greatest sales in terms of the total number of orders? Are all years evenly represented by the dataset?
SELECT DATE_PART('year', occurred_at) ord_year,  COUNT(*) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- Again, 2016 by far has the most amount of orders, but again 2013 and 2017 are not evenly represented to the other years in the dataset.
-- Which month did Parch & Posey have the greatest sales in terms of the total number of orders? Are all months evenly represented by the dataset?December still has the most sales, but interestingly, November has the second most sales (but not the most dollar sales. To make a fair comparison from one month to another 2017 and 2013 data were removed.
-- In which month of which year did Walmart spend the most on gloss paper in terms of dollars?

SELECT DATE_TRUNC('month', o.occurred_at) ord_date, SUM(o.gloss_amt_usd) tot_spent
FROM orders o 
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- May 2016 was when Walmart spent the most on gloss paper.
