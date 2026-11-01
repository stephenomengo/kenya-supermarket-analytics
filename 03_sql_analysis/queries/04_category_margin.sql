-- Q4. Category revenue, gross profit and margin.
SELECT p.category,
       ROUND(SUM(s.line_total))                                                   AS revenue_kes,
       ROUND(100 * SUM(s.line_total) / SUM(SUM(s.line_total)) OVER (), 1)         AS revenue_share_pct,
       ROUND(SUM(s.line_total - s.quantity * p.unit_cost))                        AS gross_profit_kes,
       ROUND(100 * SUM(s.line_total - s.quantity * p.unit_cost) / SUM(s.line_total), 1) AS margin_pct
FROM sales s
JOIN products p USING (product_id)
GROUP BY p.category
ORDER BY revenue_kes DESC;
