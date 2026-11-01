# SQL Findings

Results from running the 15 queries on the cleaned data (302,076 lines).

## Cross-check with the EDA
The SQL results match the pandas EDA from milestone 3: revenue KES 78.9M, 112,202 transactions, average basket KES 703, gross margin 21.9%, Westlands first with 16.3% of revenue, weekend +25%, payday +28%, holiday +36%. Getting the same numbers from two different tools is the main check that both are right.

## What the queries show
1. **Seasonality (Q2, Q7, Q8):** December is +41.7% over November in 2023, and revenue is flat year on year.
2. **Stores (Q3):** the six urban stores lead, and average basket is almost the same everywhere (KES 693 to 713), so store revenue differs by traffic, not basket size.
3. **Products (Q5, Q6, Q13):** a few family-size staples dominate, and the most common basket pair is Salt - Family with Dish Wash Liquid - Small (7,973 baskets).
4. **Promotions (Q10):** the costliest promotions are 15% off on Staples & Grains, costing about KES 90k, 76k and 59k in discounts.
5. **Customers (Q11, Q12):** about 42% of the first cohort is still active the month after first purchase. RFM puts 24.5% of customers in "Champions", who make 66.5% of identified revenue, while 27.1% are "Lost" and make 5.6%.
6. **Data check (Q15):** 17.6% of identified purchase lines (30,925 lines, 1,682 customers) are dated before the customer's signup date. The simulation did not tie signup dates to purchases, so cohorts use first purchase month, not signup date.
