-- Q9. Payment method mix and average basket size per method (basket = one transaction).
WITH baskets AS (
    SELECT transaction_id, payment_method, SUM(line_total) AS basket_value
    FROM sales
    GROUP BY transaction_id, payment_method
)
SELECT payment_method,
       COUNT(*)                                          AS baskets,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS share_pct,
       ROUND(AVG(basket_value))                          AS avg_basket_kes
FROM baskets
GROUP BY payment_method
ORDER BY baskets DESC;
