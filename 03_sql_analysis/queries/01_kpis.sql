-- Q1. Headline KPIs: how big is the business and how profitable?
SELECT ROUND(SUM(s.line_total))                                                   AS revenue_kes,
       ROUND(SUM(s.line_total - s.quantity * p.unit_cost))                        AS gross_profit_kes,
       ROUND(100 * SUM(s.line_total - s.quantity * p.unit_cost) / SUM(s.line_total), 1) AS gross_margin_pct,
       COUNT(DISTINCT s.transaction_id)                                           AS transactions,
       ROUND(SUM(s.line_total) / COUNT(DISTINCT s.transaction_id))                AS avg_basket_kes,
       COUNT(DISTINCT s.customer_id)                                              AS identified_customers
FROM sales s
JOIN products p USING (product_id);
