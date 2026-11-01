-- Q12. RFM segmentation of identified customers (snapshot date = day after the last sale).
-- Recency = days since last purchase, Frequency = number of baskets, Monetary = total spend.
-- Each is scored 1-5 with NTILE, then mapped to a segment name.
WITH rfm AS (
    SELECT customer_id,
           DATE '2025-07-01' - MAX(sale_date)  AS recency_days,
           COUNT(DISTINCT transaction_id)      AS frequency,
           SUM(line_total)                     AS monetary
    FROM sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),
scored AS (
    SELECT *,
           NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,
           NTILE(5) OVER (ORDER BY frequency)         AS f_score,
           NTILE(5) OVER (ORDER BY monetary)          AS m_score
    FROM rfm
),
segmented AS (
    SELECT *,
           CASE
               WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
               WHEN f_score >= 4 AND m_score >= 4                  THEN 'Loyal high spenders'
               WHEN r_score >= 4                                   THEN 'Recent customers'
               WHEN r_score <= 2 AND f_score >= 4                  THEN 'At risk'
               WHEN r_score <= 2 AND f_score <= 2                  THEN 'Lost'
               ELSE 'Regulars'
           END AS segment
    FROM scored
)
SELECT segment,
       COUNT(*)                                                    AS customers,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)          AS customers_pct,
       ROUND(AVG(recency_days), 1)                                 AS avg_recency_days,
       ROUND(AVG(frequency), 1)                                    AS avg_baskets,
       ROUND(SUM(monetary))                                        AS revenue_kes,
       ROUND(100 * SUM(monetary) / SUM(SUM(monetary)) OVER (), 1)  AS revenue_share_pct
FROM segmented
GROUP BY segment
ORDER BY revenue_kes DESC;
