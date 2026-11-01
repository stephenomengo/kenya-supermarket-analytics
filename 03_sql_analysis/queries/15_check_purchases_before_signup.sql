-- Q15. Data-integrity check: purchases dated before the customer's signup date.
SELECT COUNT(*)                                                       AS lines_before_signup,
       COUNT(DISTINCT s.customer_id)                                  AS customers_affected,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM sales WHERE customer_id IS NOT NULL), 1) AS pct_of_identified_lines
FROM sales s
JOIN customers c USING (customer_id)
WHERE s.sale_date < c.signup_date;
