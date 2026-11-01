-- Q7. Do weekends, paydays and public holidays change average daily revenue?
WITH daily AS (
    SELECT c.calendar_date, c.is_weekend, c.is_payday_window, c.is_holiday, SUM(s.line_total) AS revenue
    FROM sales s
    JOIN calendar c ON c.calendar_date = s.sale_date
    GROUP BY c.calendar_date, c.is_weekend, c.is_payday_window, c.is_holiday
)
SELECT 'Weekend' AS factor, is_weekend AS flag, COUNT(*) AS days, ROUND(AVG(revenue)) AS avg_daily_revenue_kes FROM daily GROUP BY is_weekend
UNION ALL
SELECT 'Payday window', is_payday_window, COUNT(*), ROUND(AVG(revenue)) FROM daily GROUP BY is_payday_window
UNION ALL
SELECT 'Public holiday', is_holiday, COUNT(*), ROUND(AVG(revenue)) FROM daily GROUP BY is_holiday
ORDER BY factor, flag;
