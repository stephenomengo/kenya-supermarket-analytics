-- Q14. Monthly revenue and average basket next to Kenyan 12-month inflation (public data from CBK).
-- Used again in milestone 5 to test whether inflation relates to basket value.
WITH baskets AS (
    SELECT transaction_id, TO_CHAR(MIN(sale_date), 'YYYY-MM') AS month, SUM(line_total) AS basket_value
    FROM sales
    GROUP BY transaction_id
)
SELECT b.month,
       ROUND(SUM(b.basket_value))  AS revenue_kes,
       ROUND(AVG(b.basket_value))  AS avg_basket_kes,
       i.twelve_month_inflation    AS inflation_pct
FROM baskets b
JOIN kenya_inflation i USING (month)
GROUP BY b.month, i.twelve_month_inflation
ORDER BY b.month;
