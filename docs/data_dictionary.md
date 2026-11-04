# Data Dictionary

All data is synthetic except `kenya_inflation_monthly` (Central Bank of Kenya). Files are in `data/raw/` unless stated.

## stores.csv (10 rows)
| Column | Description |
|---|---|
| store_id | Store code, S01 to S10 (primary key) |
| store_name | Store name |
| county | County where the store is located |
| location_type | Urban, Peri-urban or Rural |
| open_date | Date the store opened |

## products.csv (98 rows)
| Column | Description |
|---|---|
| product_id | Product code, P001 onward (primary key) |
| product_name | Name and size (Small, Regular, Family) |
| category | One of 8 categories (Staples & Grains, Dairy & Eggs, Beverages, Fresh Produce, Household & Cleaning, Personal Care, Snacks & Confectionery, Baby & Health) |
| unit_price | List price in KES |
| unit_cost | Cost to the chain in KES |

## customers.csv (5,000 rows)
| Column | Description |
|---|---|
| customer_id | Customer code, C00001 onward (primary key) |
| home_county | Customer's home county |
| age_group | 18-24, 25-34, 35-44, 45-54 or 55+ |
| loyalty_tier | Basic, Silver or Gold |
| signup_date | Loyalty signup date (not tied to purchase dates) |

## calendar.csv (731 rows, 1 Jul 2023 to 30 Jun 2025)
| Column | Description |
|---|---|
| date | Calendar date (primary key) |
| year, month, day_of_week | Date parts |
| is_weekend | Saturday or Sunday |
| is_holiday, holiday_name | Kenyan public holiday flag and name |
| is_payday_window | 25th of the month to the 2nd |
| is_school_opening | First 10 days of January, May and August |

## promotions.csv (60 rows)
| Column | Description |
|---|---|
| promo_id | Promotion code (primary key) |
| scope | Product or Category |
| target | The product_id or category the promotion applies to |
| start_date, end_date | Promotion period |
| discount_pct | Discount, 5 to 25 |

## kenya_inflation_monthly.csv (24 rows, public data)
| Column | Description |
|---|---|
| month | Month as YYYY-MM |
| annual_average_inflation | Annual average inflation, % |
| twelve_month_inflation | 12-month inflation, % |

Source: Central Bank of Kenya, based on KNBS data. See `docs/data_sources.md`.

## sales_transactions.csv (raw, 302,680 rows)
One row per product line on a receipt.
| Column | Description |
|---|---|
| line_id | Line number (primary key) |
| date | Sale date |
| store_id | Store code |
| transaction_id | Receipt (basket) code; several lines share one |
| payment_method | M-Pesa, Cash, Card, Airtel Money or Other |
| customer_id | Loyalty customer, empty for guest checkouts |
| product_id | Product code |
| quantity | Units sold |
| unit_price | Price per unit in KES |
| promo_id | Promotion applied, empty if none |
| discount_pct | Discount applied, 0 if none |
| line_total | quantity x unit_price x (1 - discount) |

**Known issues in the raw file (fixed in `01_cleaning`):** 604 duplicate lines, 302 negative quantities, 151 unit prices at 10x the catalogue price, 1,212 missing payment methods.

## sales_clean.csv (cleaned, 302,076 rows, created by `01_cleaning`)
All columns above, plus:
| Column | Description |
|---|---|
| has_customer_id, has_promo | True if the line has a customer / promotion |
| product_name, category, unit_cost | Joined from products |
| store_name, county, location_type | Joined from stores |
| age_group, loyalty_tier | Joined from customers (empty for guests) |
| day_of_week, is_weekend, is_holiday, holiday_name, is_payday_window, is_school_opening | Joined from calendar |
| revenue | Same as line_total |
| cost | quantity x unit_cost |
| gross_profit | revenue - cost |
| year_month | Month as YYYY-MM |
