-- Q3. Store performance: overall rank, rank within location type, and share of chain revenue.
SELECT st.store_name,
       st.county,
       st.location_type,
       ROUND(SUM(s.line_total))                                               AS revenue_kes,
       ROUND(100 * SUM(s.line_total) / SUM(SUM(s.line_total)) OVER (), 1)     AS share_pct,
       RANK() OVER (ORDER BY SUM(s.line_total) DESC)                          AS overall_rank,
       RANK() OVER (PARTITION BY st.location_type ORDER BY SUM(s.line_total) DESC) AS rank_in_type,
       COUNT(DISTINCT s.transaction_id)                                       AS transactions,
       ROUND(SUM(s.line_total) / COUNT(DISTINCT s.transaction_id))            AS avg_basket_kes
FROM sales s
JOIN stores st USING (store_id)
GROUP BY st.store_name, st.county, st.location_type
ORDER BY overall_rank;
