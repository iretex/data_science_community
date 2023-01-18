SELECT account_id,
       channel,
       COUNT(id) as events
FROM web_events
GROUP BY account_id, channel
ORDER BY account_id, channel DESC;

SELECT account_id,
       channel
FROM web_events
GROUP BY account_id, channel
ORDER BY account_id;

SELECT DISTINCT account_id,
       channel
FROM web_events
ORDER BY account_id

------------------------------------------
-- Questions: DISTINCT
------------------------------------------
-- Use DISTINCT to test if there are any accounts associated with more than one region.
 SELECT DISTINCT a.name account_name, r.name region_name
 FROM accounts a
 JOIN sales_reps s
 ON a.sales_rep_id = s.id
 JOIN region r
 ON r.id = s.region_id
 WHERE a.name in (
    SELECT a.name
    FROM (
         SELECT a.name account_name, COUNT(r.name) region_name
         FROM accounts a
         JOIN sales_reps s
         ON a.sales_rep_id = s.id
         JOIN region r
         ON r.id = s.region_id
         GROUP BY a.name
         HAVING COUNT(r.name) > 1
    ) reg_c
    -- WHERE region_count > 1
    )
 ORDER BY account_name, region_name


-- Have any sales reps worked on more than one account?
 SELECT DISTINCT a.name account_name, s.name rep_name
 FROM accounts a
 JOIN sales_reps s
 ON a.sales_rep_id = s.id
 JOIN region r
 ON r.id = s.region_id
--  WHERE COUNT(r.name) > 1
 ORDER BY rep_name


 ------------------------------------------
--  Solutions: DISTINCT
 ------------------------------------------

-- Use DISTINCT to test if there are any accounts associated with more than one region.
-- The below two queries have the same number of resulting rows (351), so we know that every account is associated with only one region. If each account was associated with more than one region, the first query should have returned more rows than the second query.

SELECT a.id as "account id", r.id as "region id", 
a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;
-- and

SELECT DISTINCT id, name
FROM accounts;
-- Have any sales reps worked on more than one account?
-- Actually, all of the sales reps have worked on more than one account. The fewest number of accounts any sales rep works on is 3. There are 50 sales reps, and they all have more than one account. Using DISTINCT in the second query assures that all of the sales reps are accounted for in the first query.

SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;
-- and

SELECT DISTINCT id, name
FROM sales_reps;