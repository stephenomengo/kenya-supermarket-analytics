# Kenyan Supermarket Sales & Customer Analytics

Individual Data Science & Analytics project by **Stephen Omengo Owuor** using synthetic Kenyan supermarket data to explore sales performance, customer behaviour, promotion impact and demand forecasting.

> **Data notice:** All records are synthetic. They do not represent real retailers or consumers.

## Dataset
- 10 fictional stores across 10 counties (urban, peri-urban, rural)
- 98 products in 8 categories, in small / regular / family sizes
- 5,000 synthetic customers with age group and loyalty tier
- 24 months of daily data: 2023-07-01 to 2025-06-30
- ~300k transaction lines: quantity, price, promo discount, payment method (M-Pesa, Cash, Card, Airtel Money), optional customer ID
- Seasonality: December peak, weekends, payday windows, Kenyan public holidays, school-opening weeks
- Documented data-quality issues for cleaning practice: missing payment methods, negative quantities, price outliers, duplicate lines

## Structure
- `src/data_generation/generate_data.py` - reproducible generator (seed 2026)
- `data/raw/` - generated CSVs (stores, products, customers, promotions, calendar, sales_transactions)
- `docs/` - data dictionary and notes

## Roadmap
1. Profile and document data quality
2. Clean into `data/clean/` (raw files untouched)
3. Load into PostgreSQL and run SQL analysis
4. EDA: trends, categories, payment mix, customer segments
5. Promotion uplift analysis
6. Monthly demand forecast vs seasonal-naive baseline
7. Power BI dashboard

## Run
```bash
pip install pandas numpy
python src/data_generation/generate_data.py
```
