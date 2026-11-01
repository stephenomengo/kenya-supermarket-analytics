-- Q11. Cohort retention: group identified customers by the month of their first purchase,
-- then count how many are active in each following month.
WITH customer_months AS (
    SELECT DISTINCT customer_id, DATE_TRUNC('month', sale_date)::date AS active_month
    FROM sales
    WHERE customer_id IS NOT NULL
),
cohorts AS (
    SELECT customer_id, active_month,
           MIN(active_month) OVER (PARTITION BY customer_id) AS cohort_month
    FROM customer_months
),
activity AS (
    SELECT cohort_month,
           (EXTRACT(YEAR FROM active_month) - EXTRACT(YEAR FROM cohort_month)) * 12
             + EXTRACT(MONTH FROM active_month) - EXTRACT(MONTH FROM cohort_month) AS months_since_first,
           COUNT(DISTINCT customer_id) AS active_customers
    FROM cohorts
    GROUP BY cohort_month, months_since_first
)
SELECT TO_CHAR(cohort_month, 'YYYY-MM') AS cohort_month,
       months_since_first::int,
       active_customers,
       ROUND(100.0 * active_customers / FIRST_VALUE(active_customers) OVER (PARTITION BY cohort_month ORDER BY months_since_first), 1) AS retention_pct
FROM activity
ORDER BY cohort_month, months_since_first;
