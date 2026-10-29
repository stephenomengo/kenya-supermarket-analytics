# 01 - Data Cleaning & Preparation

**Goal:** find the data-quality problems in the raw sales data, fix each one with evidence, and produce clean tables without touching `data/raw/`.

## Contents
- `01_cleaning.ipynb` - the full pipeline (load, validate, profile, fix, build features, validate, save)
- `../data/clean/cleaning_log.csv` - one row per fix with the number of rows affected
- `../data/clean/sales_clean.csv` - cleaned table (created by the notebook, not tracked in Git because of its size)

## Issues found and fixed
| Issue | Rows | Fix |
|---|---|---|
| Exact duplicate lines | 604 | Dropped, kept first |
| Negative quantity | 302 | Absolute value (line total was still positive) |
| Unit price 10x catalogue price | 151 | Restored from product catalogue |
| Missing payment method | 1,208 | Filled from the same transaction (1,121); rest labelled `Unknown` (87) |

Missing `customer_id` (guest checkout) and `promo_id` (no promotion) are not errors, so they are kept and flagged.

## Run
Run `src/data_generation/generate_data.py` first, then open the notebook and run all cells. Output: 302,076 clean rows with 32 columns.
