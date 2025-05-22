WITH customer_last_purchase AS (
	SELECT
		cohort_year,
		customerkey,
		full_name,
		orderdate,
		ROW_NUMBER() OVER (PARTITION BY customerkey ORDER BY orderdate) AS rn,
		first_purchase_date
	
	FROM
		cohort_analysis
), churned_customers AS (

	SELECT
		customerkey,
		full_name,
		orderdate AS last_purchase_date,
		CASE
			WHEN orderdate < (SELECT MAX(orderdate)FROM sales) - INTERVAL '6 months' THEN 'Churned' 
			ELSE 'Active'
		END AS customer_status,
		cohort_year 
	
	FROM 
		customer_last_purchase 
	
	WHERE
		rn = 1
)

SELECT
	cohort_year,
	customer_status,
	COUNT(customerkey) AS num_customers,
	SUM(COUNT(customerkey)) OVER(PARTITION BY cohort_year) AS total_customers,
	ROUND(COUNT(customerkey) / SUM(COUNT(customerkey)) OVER (PARTITION BY cohort_year), 2) AS status_percentage
FROM
	churned_customers 

GROUP BY
	cohort_year,
	customer_status 
	
	
	
	