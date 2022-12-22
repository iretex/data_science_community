-- COPY orders FROM 'data/orders.csv' DELIMITER ',' - doesn't work with SQL Server
DROP TABLE sales_reps;

CREATE TABLE orders (
    id	int IDENTITY(1,1) PRIMARY KEY,
    account_id	int,
    occurred_at	datetime2(6),
    standard_qty int,
    gloss_qty int,
    poster_qty int,
    total int,
    standard_amt_usd float,
    gloss_amt_usd float,
    poster_amt_usd float,
    total_amt_usd float
);

CREATE TABLE web_events (
    id int IDENTITY(1,1) PRIMARY KEY,
    account_id int,
    occurred_at	datetime2(6),
    channel VARCHAR(16)
)

CREATE TABLE accounts (
    id INT PRIMARY KEY,
    name VARCHAR(64),
    website VARCHAR(64),
    lat FLOAT,
    long FLOAT,
    primary_poc	VARCHAR(32),
    sales_rep_id INT
)

CREATE TABLE sales_reps (
    id INT PRIMARY KEY,
    name VARCHAR(64),
    region_id INT
)

BULK INSERT sales_reps
FROM 'D:\NG005454\Documents\Data Science\SQL\nd104-ent-bmann\data\sales_reps.csv'
WITH
(
    FIRSTROW = 2, -- as 1st one is header
    FIELDTERMINATOR = '\t',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

CREATE TABLE region (
    id INT,
    name VARCHAR(16)
)

INSERT INTO region (id, name)
VALUES (1, 'Northeast'), (2, 'Midwest'), (3, 'Southeast'), (4, 'West')
