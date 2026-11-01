# 03 - SQL Analysis (PostgreSQL)

**Goal:** load the cleaned data into PostgreSQL and answer the business questions with SQL: joins, aggregations, window functions, customer cohorts and RFM segments.

## Contents
- `schema.sql` - 7 tables with primary keys, foreign keys, CHECK constraints and indexes
- `load_data.sql` - loads the CSVs (cleaned sales go through a staging table) and prints row counts
- `queries/` - 15 queries, one file each, with the business question as a comment
- `run_queries.sh` - runs every query and saves the result as a CSV in `results/`
- `results/` - exported query results
- `findings.md` - what the queries show

## Tables
`sales` (fact, one row per receipt line) joined to `stores`, `products`, `customers`, `calendar` and `promotions`, plus `kenya_inflation` (public CBK data).

## Run (from the project root)
```bash
createdb -U postgres kenya_retail
psql -U postgres -d kenya_retail -f 03_sql_analysis/schema.sql
psql -U postgres -d kenya_retail -f 03_sql_analysis/load_data.sql
bash 03_sql_analysis/run_queries.sh postgres kenya_retail
```
Needs `data/clean/sales_clean.csv` from the milestone 2 notebook.

## Queries
| # | Question | Techniques |
|---|---|---|
| 01 | Headline KPIs | JOIN, aggregates |
| 02 | Monthly revenue, MoM and YoY growth, running total | LAG, SUM OVER |
| 03 | Store ranking and share of revenue | RANK, PARTITION BY |
| 04 | Category revenue and margin | JOIN, window share |
| 05 | Top 3 products per category | ROW_NUMBER, CTE |
| 06 | Pareto: cumulative revenue share of products | cumulative SUM OVER |
| 07 | Weekend, payday and holiday effects | CTE, UNION ALL |
| 08 | Daily revenue with 7-day rolling average | window frame |
| 09 | Payment mix and basket size | CTE, window share |
| 10 | Most expensive promotions | JOIN, discount cost |
| 11 | Customer cohorts and retention | CTEs, FIRST_VALUE |
| 12 | RFM customer segments | NTILE, CASE |
| 13 | Products bought together | self-join |
| 14 | Monthly sales vs Kenyan inflation | JOIN to public data |
| 15 | Data check: purchases before signup date | integrity check |
