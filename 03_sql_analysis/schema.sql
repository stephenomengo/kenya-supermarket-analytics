-- Schema for the Kenyan supermarket analytics database (PostgreSQL)
-- Run from the project root:  psql -U postgres -d kenya_retail -f 03_sql_analysis/schema.sql

DROP TABLE IF EXISTS sales, kenya_inflation, promotions, calendar, customers, products, stores CASCADE;

CREATE TABLE stores (
    store_id       TEXT PRIMARY KEY,
    store_name     TEXT NOT NULL,
    county         TEXT NOT NULL,
    location_type  TEXT NOT NULL CHECK (location_type IN ('Urban', 'Peri-urban', 'Rural')),
    open_date      DATE NOT NULL
);

CREATE TABLE products (
    product_id    TEXT PRIMARY KEY,
    product_name  TEXT NOT NULL,
    category      TEXT NOT NULL,
    unit_price    NUMERIC(10,2) NOT NULL CHECK (unit_price > 0),
    unit_cost     NUMERIC(10,2) NOT NULL CHECK (unit_cost > 0)
);

CREATE TABLE customers (
    customer_id   TEXT PRIMARY KEY,
    home_county   TEXT NOT NULL,
    age_group     TEXT NOT NULL,
    loyalty_tier  TEXT NOT NULL CHECK (loyalty_tier IN ('Basic', 'Silver', 'Gold')),
    signup_date   DATE NOT NULL
);

CREATE TABLE calendar (
    calendar_date      DATE PRIMARY KEY,
    year               INT NOT NULL,
    month              INT NOT NULL,
    day_of_week        TEXT NOT NULL,
    is_weekend         BOOLEAN NOT NULL,
    holiday_name       TEXT,
    is_holiday         BOOLEAN NOT NULL,
    is_payday_window   BOOLEAN NOT NULL,
    is_school_opening  BOOLEAN NOT NULL
);

CREATE TABLE promotions (
    promo_id      TEXT PRIMARY KEY,
    scope         TEXT NOT NULL CHECK (scope IN ('Product', 'Category')),
    target        TEXT NOT NULL,
    start_date    DATE NOT NULL,
    end_date      DATE NOT NULL,
    discount_pct  INT NOT NULL CHECK (discount_pct BETWEEN 1 AND 90)
);

CREATE TABLE kenya_inflation (
    month                    TEXT PRIMARY KEY,
    annual_average_inflation NUMERIC(5,2) NOT NULL,
    twelve_month_inflation   NUMERIC(5,2) NOT NULL
);

-- One row per product line on a receipt (cleaned data from milestone 2)
CREATE TABLE sales (
    line_id         INT PRIMARY KEY,
    sale_date       DATE NOT NULL REFERENCES calendar (calendar_date),
    store_id        TEXT NOT NULL REFERENCES stores (store_id),
    transaction_id  TEXT NOT NULL,
    payment_method  TEXT NOT NULL,
    customer_id     TEXT REFERENCES customers (customer_id),
    product_id      TEXT NOT NULL REFERENCES products (product_id),
    quantity        INT NOT NULL CHECK (quantity > 0),
    unit_price      NUMERIC(10,2) NOT NULL,
    promo_id        TEXT REFERENCES promotions (promo_id),
    discount_pct    INT NOT NULL,
    line_total      NUMERIC(12,2) NOT NULL
);

CREATE INDEX idx_sales_date        ON sales (sale_date);
CREATE INDEX idx_sales_store       ON sales (store_id);
CREATE INDEX idx_sales_product     ON sales (product_id);
CREATE INDEX idx_sales_customer    ON sales (customer_id);
CREATE INDEX idx_sales_transaction ON sales (transaction_id);
