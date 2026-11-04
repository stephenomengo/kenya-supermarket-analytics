# 05 - Power BI Dashboard

**Goal:** a dashboard a store manager can use: KPIs, trends, a breakdown by store and the forecast.

## Deliverable
`kenya_retail_dashboard.pbix` (open in Power BI Desktop), with two pages:
1. **Overview** - KPI cards (revenue, transactions, quantity sold, average transaction value, average selling price, products sold, current month revenue), a revenue trend, revenue by payment method, revenue by county and a date slicer.
2. **Forecast** - actual vs predicted weekly revenue, model comparison (MAE for the baselines and the model from milestone 6), top products and daily demand, with a written forecast insight.

`screenshots/` holds one image per page.

## Data source and a known limitation
The dashboard was built from the raw sales table (302,680 lines) and the milestone 6 forecast outputs. It does not use the cleaned table (302,076 lines), so its revenue card shows about KES 79.04M, against 78.89M in the SQL, EDA and statistics milestones, and quantities include the duplicate and negative lines removed in milestone 2. The two-line fix is to point the `sales_transactions` source at `data/clean/sales_clean.csv` and set `line_total` to a decimal type.

## Extra material
- `prepare_dashboard_data.py` - builds a cleaned star-schema data set (7 tables) from the cleaned data
- `measures.dax` - 37 DAX measures (validated in Power BI) for a fuller five-page design
- `dashboard_guide.md`, `insights.md`, `theme.json` - build guide, page insights and a colour theme for that design
