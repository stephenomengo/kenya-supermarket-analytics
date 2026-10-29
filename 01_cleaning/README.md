# 01 - Data Cleaning & Preparation

**Goal:** profile the raw data, document every quality issue, and produce clean tables without touching `data/raw/`.

## Planned contents
- `01_profiling.ipynb` - row counts, nulls, duplicates, outliers, date ranges
- `02_cleaning.ipynb` - fixes applied, with before/after counts
- `cleaning_log.md` - each issue, how many rows, and the decision taken

## Known issues to find
Missing payment methods, negative quantities, unit-price outliers (about 10x), duplicate transaction lines.

## Output
Cleaned CSVs saved to `data/clean/`.
