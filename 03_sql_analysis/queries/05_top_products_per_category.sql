-- Q5. Top 3 products in each category by revenue. Window function: ROW_NUMBER with PARTITION BY.
WITH product_revenue AS (
    SELECT p.category, p.product_name, SUM(s.line_total) AS revenue
    FROM sales s
    JOIN products p USING (product_id)
    GROUP BY p.category, p.product_name
),
ranked AS (
    SELECT category, product_name, revenue,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY revenue DESC) AS rank_in_category
    FROM product_revenue
)
SELECT category, rank_in_category, product_name, ROUND(revenue) AS revenue_kes
FROM ranked
WHERE rank_in_category <= 3
ORDER BY category, rank_in_category;
