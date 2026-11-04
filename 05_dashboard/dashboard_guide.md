# Power BI Build Guide

Build the dashboard in **Power BI Desktop** in about 1 to 2 hours. Everything you need is prepared: the data tables, the measures and the text for each page.

## 1. Prepare and import the data
1. From the project root run `~/anaconda3/python.exe 05_dashboard/prepare_dashboard_data.py`. It creates 7 CSVs in `05_dashboard/data/` and prints the key totals.
2. In Power BI Desktop: **Home > Get data > Text/CSV**, and load all 7 files (`fact_sales`, `dim_date`, `dim_store`, `dim_product`, `dim_customer`, `dim_promotion`, `forecast_weekly`). Click **Load** each time.
3. In **Model view**, check that every date column has type *Date* and `has_promo` / `is_guest` are whole numbers.

## 2. Model (star schema)
Create these relationships in Model view (drag the column from one table to the other). All are **many-to-one, single direction**.

| From (many side) | To (one side) |
|---|---|
| `fact_sales[date]` | `dim_date[date]` |
| `fact_sales[store_id]` | `dim_store[store_id]` |
| `fact_sales[product_id]` | `dim_product[product_id]` |
| `fact_sales[customer_id]` | `dim_customer[customer_id]` |
| `fact_sales[promo_id]` | `dim_promotion[promo_id]` |
| `forecast_weekly[week_start]` | `dim_date[date]` |
| `forecast_weekly[store_id]` | `dim_store[store_id]` |

Then:
- Select `dim_date` > **Table tools > Mark as date table** > choose `date`.
- Select column `month_name` > **Column tools > Sort by column** > `month_number`. Do the same for `day_of_week` sorted by `day_number`.
- **View > Themes > Browse for themes** and load `theme.json`.

## 3. Add the measures
Create an empty table (**Home > Enter data**, name it `_Measures`). For each measure in `measures.dax`: right-click `_Measures` > **New measure** > paste. Set formats: percentages as %, revenue as whole numbers with thousands separators.

## 4. Build the five pages
Use a white background, one blue accent, and a text box on every page with the insight from `insights.md`. Keep 4 to 6 visuals per page.

### Page 1 - Executive Overview
*Questions: how big is the business, is it growing, which stores lead?*
- **Slicers:** `dim_date[date]` (between), `dim_store[location_type]`, `dim_store[county]`
- **Cards:** Revenue, Gross Margin %, Transactions, Avg Basket, Revenue YoY %
- **Clustered column + line:** X `dim_date[year_month]`, columns Revenue, line Revenue LY
- **Bar chart:** Y `dim_store[store_name]`, X Revenue, legend `dim_store[location_type]`, data labels on

### Page 2 - Trends and Seasonality
*Questions: when do customers buy, and do prices (inflation) matter?*
- **Column:** X `dim_date[day_of_week]`, Y Avg Daily Revenue
- **Cards:** Weekend Uplift %, Payday Uplift %, Holiday Uplift %
- **Line:** X `dim_date[date]`, Y Revenue 7-day Avg
- **Line and column:** X `dim_date[year_month]`, columns Avg Basket, line Avg Inflation 12m (secondary axis)

### Page 3 - Stores, Products and Promotions
*Questions: which stores and products matter most, and do promotions pay off?*
- **Table:** `store_name`, `county`, `location_type`, Revenue, Store Share %, Gross Margin %, Avg Basket
- **Bar:** Y `dim_product[category]`, X Revenue, tooltip Gross Margin %
- **Bar (Top 10):** Y `dim_product[product_name]`, X Revenue; Filters pane > product_name > Top N = 10 by Revenue
- **Cards:** Top 10 Products Share %, Discount Cost, Discount Cost %, Promo Lines %
- **Bar (Top 10):** Y `dim_promotion[promo_label]`, X Discount Cost; Top N = 10 by Discount Cost

### Page 4 - Customers and Payments
*Questions: who are our customers and how do they pay?*
- **Donut:** legend `fact_sales[customer_type]`, values Revenue
- **Bar:** Y `dim_customer[rfm_segment]`, X Revenue (excludes guests automatically); add Customers as a second bar chart beside it
- **Column:** X `dim_customer[loyalty_tier]`, Y Revenue per Customer
- **Column:** X `fact_sales[payment_method]`, Y Avg Basket; add a second visual with Basket Share %

### Page 5 - Forecast
*Questions: how much will each store sell next week, and how reliable is the forecast?*
- **Slicer:** `dim_store[store_name]`
- **Line:** X `forecast_weekly[week_start]`, Y Actual Revenue (weekly), Forecast Revenue, Baseline Forecast
- **Cards:** Forecast MAE, Baseline MAE, Forecast Improvement %, Forecast MAPE %
- **Clustered bar:** Y `dim_store[store_name]`, X Forecast MAPE % and Baseline MAPE %
- Note under the chart: "Forecast covers 30 Dec 2024 to 29 Jun 2025 (test period of the model)."

## 5. Check your numbers
With no slicers selected, the cards should show these values (from the SQL and EDA milestones). If one is different, a relationship or measure is wrong.

| Measure | Expected |
|---|---|
| Revenue | 78,890,104 |
| Gross Profit | 17,284,668 |
| Gross Margin % | 21.9% |
| Transactions | 112,202 |
| Avg Basket | 703 |
| Identified Customers | 4,891 |
| Weekend / Payday / Holiday Uplift | +25.2% / +28.2% / +36.1% |
| Top 10 Products Share % | 47.7% |
| Discount Cost / Discount Cost % | 645,121 / 0.8% |
| Guest Revenue % | 41.9% |
| Forecast MAE / Baseline MAE | 8,130 / 11,848 |
| Forecast Improvement % | 31% |

## 6. Save the evidence
1. **File > Save as** `05_dashboard/kenya_retail_dashboard.pbix`.
2. Take one screenshot per page (Windows+Shift+S) and save as `05_dashboard/screenshots/page1_overview.png`, `page2_trends.png`, `page3_stores_products.png`, `page4_customers.png`, `page5_forecast.png`.
3. **File > Export > Export to PDF** and save it in `05_dashboard/`.
4. Optional: **Publish** to the Power BI service (needs a work or school account) for a hosted link.
