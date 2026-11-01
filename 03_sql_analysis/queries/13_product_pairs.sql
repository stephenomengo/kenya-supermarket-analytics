-- Q13. Which pairs of products are most often bought in the same basket? (self-join on transaction)
SELECT a.product_name AS product_a,
       b.product_name AS product_b,
       COUNT(*)       AS baskets_together
FROM (SELECT s.transaction_id, p.product_id, p.product_name FROM sales s JOIN products p USING (product_id)) a
JOIN (SELECT s.transaction_id, p.product_id, p.product_name FROM sales s JOIN products p USING (product_id)) b
  ON a.transaction_id = b.transaction_id AND a.product_id < b.product_id
GROUP BY a.product_name, b.product_name
ORDER BY baskets_together DESC
LIMIT 10;
