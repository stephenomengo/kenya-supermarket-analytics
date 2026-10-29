# Data Generation

`generate_data.py` creates all synthetic tables in `data/raw/`.

```bash
pip install pandas numpy
python src/data_generation/generate_data.py
```

- Seed: `2026` (same output every run)
- Tables: stores, products, customers, promotions, calendar, sales_transactions
- Seasonality: December peak, weekends, paydays, public holidays, school-opening weeks
- Injected issues: missing payment methods, negative quantities, price outliers, duplicate lines
