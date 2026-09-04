-- SQl Retail Sales Analysis Project
CREATE DATABASE retail_sales_analysis;

USE retail_sales_analysis;

-- Create Table
DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
transaction_id INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id	INT,
gender VARCHAR(10),
age INT,
category VARCHAR(20),
quantity INT,
price_per_unit DECIMAL(10,2),
cogs DECIMAL(10,2),
total_sale DECIMAL(10,2)
	);
    
SELECT * FROM retail_sales;
SELECT COUNT(*)
FROM retail_sales as total_count;

SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
where transactionS_id IS NULL
OR
sale_date IS NULL
OR 
sale_time IS NULL
OR 
gender IS NULL
OR
Age IS NULL
OR 
category IS NULL
OR 
quantity IS NULL
OR 
price_per_unit IS NULL
OR 
cogs IS NULL
OR 
total_sale IS NULL;

-- data Exploration

-- How many sales we have?
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- How many customers we have?

SELECT COUNT(customer_id) as total_sale FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales;

-- How many unique category we have?
SELECT COUNT(DISTINCT category) as total_sale FROM retail_sales;


-- Date Analysis & Business Key Problems & answers
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.3 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.4 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.5 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.6 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.7 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.8 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.9 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
-- Q.10 Find customers who made purchases in multiple categories
-- Q.11. Find the top 10 transactions by revenue

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category, sum(total_sale ) as total_sales
FROM retail_sales 
GROUP BY 1;

-- Q.3 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT category, 
AVG(age) AS avg_age
FROM retail_sales
WHERE category = 'beauty';

-- Q.4 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q.5 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT gender,
category,count(*) as total_trans 
FROM retail_sales
GROUP BY 1,2
ORDER BY 2;

-- Q.6 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT extract(year from sale_date) as year,
extract(month from sale_date) as month,
AVG(total_sale) AS avg_sales,
RANK()OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) 
ORDER BY AVG(total_sale) DESC) AS ranks
FROM retail_sales
GROUP BY 1,2
ORDER BY 1,3 DESC;

SELECT * FROM 
(
  SELECT extract(YEAR FROM sale_date) AS YEAR,
  extract(MONTH FROM sale_date) AS MONTH,
  AVG(total_sale) AS avg_sales,
  RANK()OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) 
  ORDER BY AVG(total_sale) DESC) AS ranks
  FROM retail_sales
  GROUP BY 1,2
  ORDER BY 1,3 DESC
  ) 
  AS t1
WHERE ranks = 1;

-- Q.7 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT customer_id, 
SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

SELECT * FROM retail_sales;

-- Q.8 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category,
COUNT(distinct customer_id) AS unique_cs 
FROM retail_sales
GROUP BY 1;

-- Q.9 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

SELECT *, CASE 
WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'morning'
WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
ELSE 'evening'
END AS shift
FROM retail_sales;

-- Q.10 Find customers who made purchases in multiple categories

SELECT customer_id,
COUNT(DISTINCT category) AS category_count
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(DISTINCT category) > 1
ORDER BY category_count DESC;

-- Q.11 Find the top 10 transactions by revenue

SELECT
    transactions_id,
    customer_id,
    category,
    quantity,
    total_sale
FROM retail_sales
ORDER BY total_sale DESC
LIMIT 10;

-- End OF PROJECT