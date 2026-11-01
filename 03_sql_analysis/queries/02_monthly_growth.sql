-- Q2. Monthly revenue with month-over-month growth, year-over-year growth and a running total.
-- Window functions: LAG and SUM() OVER.
WITH monthly AS (
    SELECT DATE_TRUNC('month', sale_date)::date AS month,
           SUM(line_total) AS revenue
    FROM sales
    GROUP BY 1
)
SELECT TO_CHAR(month, 'YYYY-MM')                                           AS month,
       ROUND(revenue)                                                      AS revenue_kes,
       ROUND(100 * (revenue / LAG(revenue) OVER (ORDER BY month) - 1), 1)  AS mom_growth_pct,
       ROUND(100 * (revenue / LAG(revenue, 12) OVER (ORDER BY month) - 1), 1) AS yoy_growth_pct,
       ROUND(SUM(revenue) OVER (ORDER BY month))                           AS running_total_kes
FROM monthly
ORDER BY month;
