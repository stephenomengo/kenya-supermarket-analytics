-- Load the CSVs. Run from the project root so the relative paths work:
--   psql -U postgres -d kenya_retail -f 03_sql_analysis/load_data.sql
-- Requires schema.sql first, and data/clean/sales_clean.csv from the milestone 2 notebook.

\copy stores FROM 'data/raw/stores.csv' CSV HEADER
\copy products FROM 'data/raw/products.csv' CSV HEADER
\copy customers FROM 'data/raw/customers.csv' CSV HEADER
\copy calendar FROM 'data/raw/calendar.csv' CSV HEADER
\copy promotions FROM 'data/raw/promotions.csv' CSV HEADER
\copy kenya_inflation FROM 'data/raw/kenya_inflation_monthly.csv' CSV HEADER

-- The cleaned sales file has 32 columns (12 original + derived ones), so load it
-- into a staging table first and keep only the 12 columns the sales table needs.
DROP TABLE IF EXISTS stg_sales_clean;
CREATE TABLE stg_sales_clean (
    line_id INT, sale_date DATE, store_id TEXT, transaction_id TEXT, payment_method TEXT,
    customer_id TEXT, product_id TEXT, quantity INT, unit_price NUMERIC, promo_id TEXT,
    discount_pct INT, line_total NUMERIC,
    has_customer_id TEXT, has_promo TEXT, product_name TEXT, category TEXT, unit_cost TEXT,
    store_name TEXT, county TEXT, location_type TEXT, age_group TEXT, loyalty_tier TEXT,
    day_of_week TEXT, is_weekend TEXT, is_holiday TEXT, holiday_name TEXT,
    is_payday_window TEXT, is_school_opening TEXT, revenue TEXT, cost TEXT,
    gross_profit TEXT, year_month TEXT
);
\copy stg_sales_clean FROM 'data/clean/sales_clean.csv' CSV HEADER

INSERT INTO sales (line_id, sale_date, store_id, transaction_id, payment_method, customer_id,
                   product_id, quantity, unit_price, promo_id, discount_pct, line_total)
SELECT line_id, sale_date, store_id, transaction_id, payment_method, customer_id,
       product_id, quantity, unit_price, promo_id, discount_pct, line_total
FROM stg_sales_clean;

DROP TABLE stg_sales_clean;
ANALYZE;

-- Sanity check: row counts
SELECT 'stores' AS table_name, COUNT(*) AS rows FROM stores
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'calendar', COUNT(*) FROM calendar
UNION ALL SELECT 'promotions', COUNT(*) FROM promotions
UNION ALL SELECT 'kenya_inflation', COUNT(*) FROM kenya_inflation
UNION ALL SELECT 'sales', COUNT(*) FROM sales;
