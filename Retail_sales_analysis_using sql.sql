use retail_sales_analysis;

DROP TABLE IF EXISTS retail_sales;

create table retail_sales(
transactions_id int,
sale_date 	date,
sale_time time,	
customer_id	int,
gender	varchar(15),
age	int,
category varchar(15),	
quantiy	int,
price_per_unit 	float,
cogs	float,
total_sale float
);
ALTER TABLE retail_sales ADD CONSTRAINT PRIMARY KEY (transactions_id);
ALTER TABLE retail_sales RENAME COLUMN quantiy TO quantity;


select * from retail_sales;
/* Data Exploration & Cleaning*/
select count(*) from retail_sales;
select distinct(transactions_id) from retail_sales;
select distinct(category) from retail_sales;

/*Checking the null values*/
select * from retail_sales
where transactions_id is null or 
sale_date is null or 
sale_time is null or 
customer_id is null or	
gender	is null or
age	is null or
category	is null or
quantity	is null or
price_per_unit	is null or
cogs	is null or
total_sale is null;

select * from retail_sales;
SET SQL_SAFE_UPDATES = 0;


DELETE FROM retail_sales
WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR gender IS NULL OR age IS NULL OR category IS NULL OR  
quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

select * from retail_sales;

/*Write a SQL query to retrieve all columns for sales made on '2022-11-05*/
select * from retail_sales where sale_date = '2022-11-05';

/*Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
the quantity sold is more than 4 in the month of Nov-2022*/
select * from retail_sales where category = 'Clothing' and date_format(sale_date,'%Y-%m') = '2022-11'
and quantity >= 4;

/*Write a SQL query to calculate the total sales (total_sale) for each category.:
*/
Select category,sum(total_sale) as total_sales from retail_sales
group by category
order by total_sales;

/*Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
*/
select avg(age) as avg_age from retail_sales
where category = 'Beauty';

/*Write a SQL query to find all transactions where the total_sale is greater than 1000.:
*/
select * from retail_sales
where total_sale > 1000;


/*Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.*/
select gender,category,count(transactions_id) as total_transactions from retail_sales
group by gender,category
order by total_transactions;

/*Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
*/
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as r
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE r = 1;

/*Write a SQL query to find the top 5 customers based on the highest total sales:
*/
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


/*Write a SQL query to find the number of unique customers who purchased items from each category.:
*/
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;

/*Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
*/
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;



