-- Q10. The 10 promotions that cost the most in discounts, and how much they sold.
SELECT pr.promo_id,
       pr.scope,
       pr.target,
       pr.discount_pct,
       COUNT(*)                                                     AS lines_sold,
       SUM(s.quantity)                                              AS units_sold,
       ROUND(SUM(s.line_total))                                     AS revenue_kes,
       ROUND(SUM(s.quantity * s.unit_price - s.line_total))         AS discount_cost_kes
FROM sales s
JOIN promotions pr USING (promo_id)
GROUP BY pr.promo_id, pr.scope, pr.target, pr.discount_pct
ORDER BY discount_cost_kes DESC
LIMIT 10;
