WITH customer_ltv AS (
SELECT 
	customerkey,
	full_name,
	SUM(total_net_revenue) AS total_ltv
	
FROM
	cohort_analysis ca 

GROUP BY
	ca.customerkey, 
	ca.full_name
), customer_segments AS (

	SELECT 
		PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_ltv) AS ltv_25th_percentile,
		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_ltv) AS ltv_75th_percentile
	
	FROM
		customer_ltv 
), segmentation_value AS (

	SELECT
		c.*,
		CASE 
			WHEN c.total_ltv < cs.ltv_25th_percentile THEN '1 - Low-Value'
			WHEN c.total_ltv <= cs.ltv_75th_percentile THEN '2 - Mid-Value'
			ELSE '3 - High-Value'
		END AS customer_segments
	FROM 
		customer_ltv c,
		customer_segments cs
	)
	
SELECT
	customer_segments,
	SUM(total_ltv) AS total_ltv
FROM
	segmentation_value 
	
GROUP BY
	customer_segments 
	
ORDER BY
	customer_segments  DESC