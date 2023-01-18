Lesson Overview

Up to this point, you have learned a lot about working with data using SQL. You’ve covered a handful of basic SQL concepts, including aggregate functions and joins. In this lesson, we’ll cover subqueries, a fundamental advanced SQL topic.

This lesson will focus on the following components of subqueries, and you will be able to:

- Create subqueries to solve real-world problems
- Differentiate between Subqueries and Joins
- Implement the best type of Subqueries
- Consider the tradeoffs to using subqueries
- Implement the best subquery strategy

Sometimes, the question you are trying to answer can’t be solved with the set of tables in your database. Instead, there’s a need to manipulate existing tables and join them to solve the problem at hand.

This is where subqueries come to the rescue!

If you can’t think of a situation where this need exists, don’t worry. We’ll review a few real-world applications where existing tables need to be manipulated and joined. And how subqueries help us get there.


## What exactly is a subquery?
A subquery is a query within a query.

As a reminder, a query has both SELECT and FROM clauses to signify what you want to extract from a table and what table you’d like to pull data from. A query that includes subquery, as a result, has multiple SELECT and FROM clauses.
The subquery that sits nested inside a larger query is called an INNER QUERY. This inner query can be fully executed on its own and often is run independently before when trying to troubleshoot bugs in your code.
Example from the Video
This query cannot be run in our workspaces it is just an example

``
SELECT product_id,
       name,
       price
FROM db.product
Where price > (SELECT AVG(price)
              FROM db.product)
``

# Subqueries in Real-world Applications

When do you need to use a subquery?

You need to use a subquery when you have the need to manipulate an existing table to “pseudo-create” a table that is then used as a part of a larger query. In the examples below, existing tables cannot be joined together to solve the problem at hand. Instead, an existing table needs to be manipulated, massaged, or aggregated in some way to then join to another table in the dataset to answer the posed question.

Set of Problems:

1. Identify the top-selling Amazon products in months where sales have exceeded $1m
    - Existing Table: Amazon daily sales
    - Subquery Aggregation: Daily to Monthly
2. Examine the average price of a brand’s products for the highest-grossing brands
    - Existing Table: Product pricing data across all retailers
    - Subquery Aggregation: Individual to Average
3. Order the annual salary of employees that are working less than 150 hours a month
    - Existing Table: Daily time-table of employees
    - Subquery Aggregation: Daily to Monthly

Let’s pause here to make sure you are starting to build intuition around when to use Subqueries vs. when to use JOINS. Don’t worry if you don’t get the correct answer. We will be going in-depth into this in the coming pages. Just based on what we have covered in this video, take a stab at this quiz.

Example:

``
SELECT product_id,
       name,
       price
FROM db.product
Where price > (SELECT AVG(price)
              FROM db.product)
``

## Subqueries vs. Joins

Often, SQL users will question the differences between joins and subqueries. After all, they essentially do the same thing: join tables together to create a single output. However, there are times when subqueries are more appropriate than joins and vice versa. In this section of our lesson, we’ll cover the differences between the two and when to use each.

### Differences between Subqueries and Joins
#### Use Cases:
_Subquery_: When an existing table needs to be manipulated or aggregated to then be joined to a larger table.

_Joins_: A fully flexible and discretionary use case where a user wants to bring two or more tables together and select and filter as needed.

#### Syntax:
_Subquery_: A subquery is a query within a query. The syntax, as a result, has multiple **SELECT** and **FROM** clauses.

_Joins_: A join is simple stitching together multiple tables with a common key or column. A join clause cannot stand and be run independently.

#### Dependencies:
_Subquery_: A subquery clause can be run completely independently. When trying to debug code, subqueries are often run independently to pressure test results before running the larger query.

_Joins_: A join clause cannot stand and be run independently.

### Similarities between Subqueries and Joins
**Output**:

Both subqueries and joins are essentially bringing multiple tables together (whether an existing table is first manipulated or not) to generate a single output.

**Deep-dive topics**:

What happens under the hood: Query plans are similar for both subqueries and joins. You can read more about how query plans are [here](https://www.essentialsql.com/what-is-a-query-plan/). We will not be going in-depth for these in this lesson.

### Subquery vs Joins Overview

|**Components** |**Subquery** | **JOINS**|
|---|---|---|
|Combine data from multiple tables into a single result	| X | X |
|Create a flexible view of tables stitched together using a “key”	| |	X |
| Build an output to use in a later part of the query |	X | |	
| Subquery Plan: What happens under the hood |	X |	X |
Example from the Video
This query cannot be run in our workspaces it is just an example

Query 1

``
SELECT product_id,
       name,
       price
FROM db.product
Where price > (SELECT AVG(price)
              FROM db.product)
``

Query 2

```sql
SELECT a.brand_id,
       a.total_brand_sales
       AVG(b.product_price)
FROM brand_table a
JOIN brand_table b
ON b.brand_id = a.brand_id
GROUP BY a.brand_id, a.total_brand_sales
ORDER BY a.total_brand_sales desc;
```

### Subqueries and Joins Deep-dives
The following comparison will help iterate again the differences between subqueries and joins.

Subqueries:

**Output**: Either a scalar (a single value) or rows that have met a condition. 

**Use Case:** Calculate a scalar value to use in a later part of the query (e.g., average price as a filter). 

**Dependencies:** Stand independently and be run as complete queries themselves.

Joins:

**Output:** A joint view of multiple tables stitched together using a common “key”. 

**Use Case:** Fully stitch tables together and have full flexibility on what to “select” and “filter from”. 

**Dependencies:** Cannot stand independently.

QUIZ QUESTION

Which of the following is true of subqueries and not true of joins?
Ans: Can standalone and be run as an independent expression

## Subquery Basics
Now, it’s time to review subquery fundamentals before writing our first subquery. Below are a set of rules to consider when building and executing subqueries.

**Fundamentals to Know about Subqueries:**
- Subqueries must be fully placed inside parentheses.
- Subqueries must be fully independent and can be executed on their own
- Subqueries have two components to consider:
    - Where it’s placed
    - Dependencies with the outer/larger query

**A caveat with subqueries being independent:**

In almost all cases, subqueries are fully independent. They are "interim”/temp tables that can be fully executed on their own. **However, there is an exception.** When a subquery, typically in the form of a nested or inline subquery, is correlated to its outer query, it cannot run independently. This is most certainly an edge case since correlated subqueries are rarely implemented compared to standalone, simple subqueries.



Subquery Basics Explained Below
![Subquery Basics](https://video.udacity-data.com/topher/2021/April/608b1e4a_screen-shot-2021-04-29-at-1.59.16-pm/screen-shot-2021-04-29-at-1.59.16-pm.png)

**Placement:**

There are four places where subqueries can be inserted within a larger query:

- With
- Nested
- Inline
- Scalar

**Dependencies:**
A subquery can be **dependent** on the outer query or **independent** of the outer query.

Resources:
One of my favorite resources on subqueries that covers use cases, syntax, and examples is from Microsoft and can be found [here](https://docs.microsoft.com/en-us/sql/relational-databases/performance/subqueries?view=sql-server-ver15).

QUIZ QUESTION
Identify the TRUE statement(s) about SQL subqueries.

## Subqueries: Placement
Before writing any code, a strong SQL user considers what problem he or she is trying to solve, where the subquery needs to be placed, and larger tradeoffs (e.g., readability).

The key concept of placement is where exactly the subquery is placed within the context of the larger query. There are four different places where a subquery can be inserted. From my experience, the decision of which placement to leverage stems from (1) the problem at hand and (2) the readability of the query.

**Subquery Placement:**

**With:** This subquery is used when you’d like to “pseudo-create” a table from an existing table and **visually scope** the temporary table at the top of the larger query.

**Nested:** This subquery is used when you’d like the temporary table to act as a filter within the larger query, which implies that it often sits within the **where clause**.

**Inline**: This subquery is used in the same fashion as the **WITH** use case above. However, instead of the temporary table sitting on top of the larger query, it’s embedded within the **from clause**.

**Scalar**: This subquery is used when you’d like to generate a scalar value to be used as a benchmark of some sort.

For example, when you’d like to calculate the average salary across an entire organization to compare to individual employee salaries. Because it’s often a single value that is generated and used as a benchmark, the scalar subquery often sits within the **select clause**.

**Advantages:**

**Readability**: ```With``` and ```Nested``` subqueries are most advantageous for readability.

**Performance**: **Scalar** subqueries are advantageous for performance and are often used on smaller datasets.

Quiz time

Use the image below for the quiz towards the end of the page. We know that you have not seen the detailed examples of subquery placements yet, but this is a good exercise to start building intuition around the placement of subqueries. So give it a try! Subquery placements are a tricky topic, so let's get more practice with it.

1:

```sql
WITH subquery_name (column_name1, ...) AS
 (SELECT ...)
SELECT ...
```
2:
```sql
SELECT student_name
FROM
  (SELECT student_id, student_name, grade
   FROM student
   WHERE teacher =10)
WHERE grade >80;
```
3:
```sql
SELECT s.s_id, s.s_name, g.final_grade
FROM student s, grades g
WHERE s.s_id = g.s_id
IN (SELECT final_grade
    FROM grades g
    WHERE final_grade >3.7
   );
```
4:
```sql
SELECT s.student_name
  (SELECT AVG(final_score)
   FROM grades g
   WHERE g.student_id = s.student_id) AS
     avg_score
FROM student s;
```

Subqueries

In the video above, we review what it’s really like to build and execute a subquery. You’ll notice the following order of operations.

1. **Build the Subquery**: The aggregation of an existing table that you’d like to leverage as a part of the larger query.
2. **Run the Subquery**: Because a subquery can stand independently, it’s important to run its content first to get a sense of whether this aggregation is the interim output you are expecting.
3. **Encapsulate and Name**: Close this subquery off with parentheses and call it something. In this case, we called the subquery table ‘sub.’
4. **Test Again**: Run a SELECT * within the larger query to determine if all syntax of the subquery is good to go.
5. **Build Outer Query**: Develop the SELECT * clause as you see fit to solve the problem at hand, leveraging the subquery appropriately.

Now, it’s time to try your hand at building subqueries. Run through the checklist below -- Good luck!

Code from Video
```sql
SELECT channel,
       AVG(event_count) AS avg_event_count
FROM
(SELECT DATE_TRUNC('day',occurred_at) AS day,
        channel,
        count(*) as event_count
   FROM web_events
   GROUP BY 1,2
   ) sub
   GROUP BY 1
   ORDER BY 2 DESC
   ```

## Subquery Formatting
The first concept that helps when thinking about the format of a subquery is the placement of it: with, nested, inline, or scalar.

The second concept to consider is an indentation, which helps heighten readability for your future self or other users that want to leverage your code. The examples in this class are indented quite far—all the way to the parentheses. This isn’t practical if you nest many subqueries, but in general, be thinking about how to write your queries in a readable way. Examples of the same query written in multiple different ways are provided below. You will see that some are much easier to read than others.

### Badly Formatted Queries
Though these poorly formatted examples will execute the same way as the well-formatted examples, they just aren't very friendly for understanding what is happening!

Here is the first, where it is impossible to decipher what is going on:
```sql
SELECT * FROM (SELECT DATE_TRUNC('day',occurred_at) AS day, channel, COUNT(*) as events FROM web_events GROUP BY 1,2 ORDER BY 3 DESC) sub;
```
This second version, which includes some helpful line breaks, is easier to read than the previous version, but it is still not as easy to read as the queries in the **Well Formatted Query** section.

```sql
SELECT *
FROM (
SELECT DATE_TRUNC('day',occurred_at) AS day,
channel, COUNT(*) as events
FROM web_events 
GROUP BY 1,2
ORDER BY 3 DESC) sub;
```
## Well Formatted Query

Now for a well-formatted example, you can see the table we are pulling from much easier than in the previous queries.
```sql
SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
      FROM web_events 
      GROUP BY 1,2
      ORDER BY 3 DESC) sub;
```
Additionally, if we have a **GROUP BY, ORDER BY, WHERE, HAVING**, or any other statement following our subquery, we would then indent it at the same level as our outer query.

The query below is similar to the above, but it is applying additional statements to the outer query, so you can see there are **GROUP BY** and **ORDER BY** statements used on the output and are not tabbed. The inner query **GROUP BY** and **ORDER BY** statements are indented to match the inner table.
```sql
SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
      FROM web_events 
      GROUP BY 1,2
      ORDER BY 3 DESC) sub
GROUP BY day, channel, events
ORDER BY 2 DESC;
```
These final two queries are so much easier to read!

SQL Subqueries & Temporary Tables

## Key Details to Highlight
In the first subquery you wrote, you created a table that you could then query again in the **FROM** statement. This was an **inline subquery**.

In the video below, Derek reviews how to build a **nested subquery**. The subquery sits within the filter section of the larger query and leverages a logical operator (e.g., “=”).


**Expert Tip**
Note that you should not include an alias when you write a subquery in a conditional statement. This is because the subquery is treated as an individual value (or set of values in the **IN** case) rather than as a table. **Nested and Scalar subqueries often do not require aliases the way With and Inline subqueries do**.

**Code from the video**
You can test this query in our workspace below!

**Nested Subquery**

```sql
SELECT *
FROM orders
WHERE DATE_TRUNC('month',occurred_at) =
 (SELECT DATE_TRUNC('month',MIN(occurred_at)) AS min_month
  FROM orders)
ORDER BY occurred_at
```

## Subqueries: Dependencies

**Simple Subquery**
```sql
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
```

**Correlated Subquery**
```sql
SELECT employee_id,
       name
FROM employees_db emp
WHERE salary > 
      (SELECT AVG(salary)
       FROM employees_db
       WHERE department = emp.department
      );
```
The second concept to consider before writing any code is the dependency of your subquery to the larger query. A subquery can either be simple or correlated. In my experience, it’s better to keep subqueries simple to increase readability for other users that might leverage your code to run or adjust.

**Simple Subquery:** The inner subquery is completely independent of the larger query.

**Correlated Subquery:** The inner subquery is dependent on the larger query.

**When to use Correlated Query**
However, sometimes, it’s slick to include a correlated subquery, specifically when the value of the inner query is dependent on a value outputted from the main query (e.g., the filter statement constantly changes). In the example below, you’ll notice that the value of the inner query -- average GPA -- keeps adjusting depending on the university the student goes to. THAT is a great use case for the correlated subquery.

```sql
SELECT first_name, last_name, GPA, university
 FROM student_db outer_db
 WHERE GPA >
                (SELECT AVG(GPA)
                 FROM student_db
                 WHERE university = outer_db.university);
```

**Quiz Time**
Try the following quiz to full grasp the difference between the output of a Simple and Correlated Query. Use the image below for the quiz at the end of the page.

![dependencies_subquery_quiz](https://video.udacity-data.com/topher/2020/May/5ec0f463_screen-shot-2020-05-17-at-1.16.47-am/screen-shot-2020-05-17-at-1.16.47-am.png)
dependencies_subquery_quiz

Subquery 1.
```sql
SELECT first_name, last_name, (
                 SELECT AVG(GPA)
                 FROM outer_db
                 WHERE university = outer_db.university) GPA, university
 FROM student_db outer_db;
 ```
Subquery 2.
```sql
SELECT first_name, last_name, GPA, university
 FROM student_db outer_db
 WHERE GPA >
                (SELECT AVG(GPA)
                 FROM student_db
                 WHERE university = outer_db.university);
```

## Views in SQL
**Need for Views**

Assume you run a complex query to fetch data from multiple tables. Now, you’d like to query again on the top of the result set. And later, you’d like to query more on the same result set returned earlier. So, there arises a need to store the result set of the original query, so that you can re-query it multiple times. This necessity can be fulfilled with the help of views.

**Understanding Views**

Tables in SQL reside in the database persistently. In contrast, **views** are the virtual tables that are derived from one or more base tables. The term virtual means that the views do not exist physically in a database, instead, they reside in the memory (not database), just like the result of any query is stored in the memory.

The syntax for creating a view is
```sql
CREATE VIEW <VIEW_NAME>
AS
SELECT …
FROM …
WHERE …
```
The query above is called a view-definition. Once created, **you can query a view just like you’d query a normal table**, by using its name. The tuples in a view are created as an outcome of a SQL query that selects the filtered data from one or more tables. Let’s see a few examples below.

**Examples**
**Example 1** - Consider the same **Parch & Posey** database schema again, where the sales_reps table contains details about sales representatives and the ```region``` table contains the list of regions.

> Suppose you are managing sales representatives who are looking after the accounts in the Northeast region only. The details of such a subset of sales representatives can be fetched from two tables, and stored as a view:
```sql
create view v1
as
select S.id, S.name as Rep_Name, R.name as Region_Name
from sales_reps S
join region R
on S.region_id = R.id
and R.name = 'Northeast';
```
The query above will store the result as a view (virtual table) with the name “V1” that can be queried later.

**Example 2** - Consider another example from **Parch & Posey** database schema again, where you have practiced the following query in the “Joins” lesson:

> Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. Your final result should have 3 columns: region name, account name, and unit price.

The query would be
```sql
CREATE VIEW V2
AS
SELECT r.name region, a.name account, 
       o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;
```
You can save the result set of the query as a view (virtual table) with the name “V2” that can be queried later.

> Note - You can use any SELECT query in the CREATE VIEW query. The above two examples show a join query, whereas the next example shows a subquery used in creating a view.

**Example 3** - The subquery you saw earlier, can be also stored as a view.

> Show the report which channels send the most traffic per day on average to Parch and Posey.
```sql
CREATE VIEW V3
AS
SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
         FROM web_events 
         GROUP BY 1,2) sub
GROUP BY channel
```
Now, this view can be queried for any information that it contains. For example, you can see the maximum value of ```average_events``` as:
```sql
select max(average_events)
from v3;
```

## Points to Remember
**Can we update the base tables by updating a view?**

Since views do not exist physically in the database, it is may or may not be possible to execute UPDATE operations on views. It depends on the SELECT query used in the view definition. Generally, if the SELECT statement contains either an AGGREGATE function, GROUPING, or JOIN, then the view may not update the underlying base tables.

**Can we insert or delete a tuple in the base table by inserting or deleting a tuple in a view?**

Again, it depends on the view definition. If a view is created from a single base table, then yes, you can insert/delete tuples by doing so in the view.

**Can we alter the view definition?**

Most of the databases allow you to alter a view. For example, Oracle and IBM DB2 allows us to alter views and provides ```CREATE OR REPLACE VIEW``` option to redefine a view.

SQL Subqueries & Temporary Tables







