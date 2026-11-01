-- Q8. Daily revenue with a 7-day rolling average to smooth the weekly cycle.
-- Window frame: ROWS BETWEEN 6 PRECEDING AND CURRENT ROW.
WITH daily AS (
    SELECT sale_date, SUM(line_total) AS revenue
    FROM sales
    GROUP BY sale_date
)
SELECT sale_date,
       ROUND(revenue) AS revenue_kes,
       ROUND(AVG(revenue) OVER (ORDER BY sale_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)) AS rolling_7day_avg_kes
FROM daily
ORDER BY sale_date;
