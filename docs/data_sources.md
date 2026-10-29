# Data Sources

## Inventory
| Dataset | Type | Source | Period | Rows | Terms / licence |
|---|---|---|---|---|---|
| stores.csv | Generated | `src/data_generation/generate_data.py` | n/a | 10 | Own work, fictional data |
| products.csv | Generated | same script | n/a | 98 | Own work, fictional data |
| customers.csv | Generated | same script | n/a | 5,000 | Own work, fictional data |
| promotions.csv | Generated | same script | 2023-07 to 2025-06 | 60 | Own work, fictional data |
| calendar.csv | Generated | same script | 2023-07-01 to 2025-06-30 | 731 | Own work, fictional data |
| sales_transactions.csv | Generated | same script | 2023-07-01 to 2025-06-30 | 302,680 | Own work, fictional data |
   | kenya_inflation_monthly.csv | **Public** | Central Bank of Kenya, Inflation Rates (https://www.centralbank.go.ke/inflation-rates/), based on KNBS data | 2023-07 to 2025-06 | 24 | **To confirm:** CBK terms of use | CBK website terms (https://www.centralbank.go.ke/?p=1394): content © Central Bank of Kenya, provided as general information with no warranty. No open-data licence found; used for non-commercial coursework with attribution

## Generated data
- Seed `2026`, so the same data is produced on every run
- Built-in seasonality: December peak, weekends, paydays, Kenyan public holidays, school-opening weeks
- Injected issues for cleaning practice: missing payment methods, negative quantities, price outliers, duplicate lines

## Public data: Kenyan inflation rates.
- Official figures come from the Kenya National Bureau of Statistics (KNBS). The Central Bank of Kenya publishes the monthly 12-month inflation rates at https://www.centralbank.go.ke/inflation-rates/
- Retrieval: download or copy the monthly inflation rates for July 2023 to June 2025 and save them as `data/raw/kenya_inflation_monthly.csv,
- Record the date retrieved: 29 Oct 2026.
- Use: join to monthly sales to test whether inflation relates to basket value (milestone 5) and as a possible external feature in the forecast (milestone 6)

## Limitations
- Sales, stores, products and customers are fictional, so findings describe the simulated data and not real Kenyan retail
- Inflation rates are national and cover all goods, so they are only a rough proxy for supermarket prices. The June 2024 annual-average and 12-month values were swapped in the source table, and I corrected them.”
- The public inflation figures are the Central Bank of Kenya's, reproduced for educational use. Check CBK's terms before reusing them outside this project.
