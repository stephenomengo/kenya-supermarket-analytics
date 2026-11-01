-- Q6. Pareto analysis: how much of revenue comes from the top products? Cumulative share with SUM() OVER.
WITH product_revenue AS (
    SELECT p.product_name, SUM(s.line_total) AS revenue
    FROM sales s
    JOIN products p USING (product_id)
    GROUP BY p.product_name
)
SELECT ROW_NUMBER() OVER (ORDER BY revenue DESC)                                 AS product_rank,
       product_name,
       ROUND(revenue)                                                            AS revenue_kes,
       ROUND(100 * SUM(revenue) OVER (ORDER BY revenue DESC) / SUM(revenue) OVER (), 1) AS cumulative_share_pct
FROM product_revenue
ORDER BY product_rank
LIMIT 20;
