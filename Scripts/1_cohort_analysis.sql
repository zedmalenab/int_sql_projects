SELECT
	cohort_year,
	SUM(total_net_revenue) AS total_revenue,
	COUNT(DISTINCT customerkey) AS total_customers,
	SUM(total_net_revenue) / COUNT(DISTINCT customerkey)  AS revenue_per_customer

FROM 
	cohort_analysis

WHERE
	orderdate = first_purchase_date

GROUP BY 
	cohort_year