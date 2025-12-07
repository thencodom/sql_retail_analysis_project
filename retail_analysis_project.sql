-- Create table 
CREATE TABLE retail_sales
		(
			transactions_id	INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME,
			customer_id	INT,
			gender VARCHAR(20),
			age	INT,
			category VARCHAR(50),
			quantity	INT,
			price_per_unit INT,
			cogs FLOAT,
			total_sale FLOAT
		
		)
SELECT * FROM retail_sales
LIMIT 10

SELECT 
COUNT (*)
FROM retail_sales


-- Data cleaning
SELECT *
FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR 
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR 
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL


-- Data exploration
-- How many sales we have?
SELECT COUNT (*) as total_sale FROM retail_sales

-- How many unique customers do we have?
SELECT COUNT (DISTINCT customer_id) as total_customers FROM retail_sales


-- Data Analysis & Business Problems and Answers
-- What category sells the most?
SELECT 
	MAX(category) as category, 
	SUM(quantity) as total_quantity_sold
FROM retail_sales
GROUP BY category

-- write a SQL query to retrieve all columns for sales made on ‘2022-11-05’
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05'

-- retrieve all transactions where the category is ‘clothing’ and the quantity sold is greater than or equal to 4 in the month of Nov-2022
SELECT 
	*
FROM retail_sales
WHERE category = 'Clothing'
	AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' -- Compares the months
	AND quantity >= 4

-- calculate the total sales for each category
SELECT
	category,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY category

-- find the average age of customers who purchase items from the beauty category
SELECT
	category,
	ROUND(AVG(age), 0)
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category

-- find all the transactions where the total sale is greater than 1000
SELECT *
FROM retail_sales 
WHERE total_sale >= 1000

-- find the total number of transactions made by each gender in each category
SELECT
	category,
	gender,
	COUNT(transactions_id) as total_transactions
FROM retail_sales
GROUP BY 
	category,
	gender
ORDER BY 1

-- calculate the average sale for each month. Find out best selling month in each year.
SELECT
	year,
	month,
	total_sale
FROM -- () creates the following as a subquery
	(SELECT
		EXTRACT(YEAR FROM sale_date) AS year, -- learned the EXTRACT function
		EXTRACT(MONTH FROM sale_date) AS month,
		AVG(total_sale) AS total_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
	FROM retail_sales
	GROUP BY 1, 2
) AS t1 -- give the subquery a name
WHERE rank = 1
--ORDER BY 1, 3 DESC


-- the top five customers based on the highest total sales
SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 
	1
ORDER BY 2 DESC
LIMIT 5


-- find the number of unique customers who purchase items from each category
SELECT
	COUNT(DISTINCT customer_id) AS customer,
	category
FROM retail_sales
GROUP BY 2


-- write a SQL query to create each shift and number of orders (example morning is greater < 12, afternoon between 12 & 17, evening is >17
-- learning customer segmentation

WITH hourly_sale AS (
	SELECT *, 
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS shift
	FROM retail_sales
)
SELECT
	shift
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift

-- End of project