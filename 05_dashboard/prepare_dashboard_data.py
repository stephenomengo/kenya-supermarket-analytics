"""Builds the tables for the Power BI dashboard (star schema) from the cleaned and raw data.
Run from the project root:  python 05_dashboard/prepare_dashboard_data.py
Needs data/clean/sales_clean.csv (milestone 2) and 04_forecasting/test_predictions.csv (milestone 6)."""
import numpy as np, pandas as pd
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RAW, CLEAN, OUT = ROOT / "data" / "raw", ROOT / "data" / "clean", Path(__file__).resolve().parent / "data"
OUT.mkdir(exist_ok=True)

sales = pd.read_csv(CLEAN / "sales_clean.csv", parse_dates=["date"], low_memory=False)

# ---- fact_sales: one row per receipt line (lean version of the cleaned table) ----
fact = sales[["line_id", "date", "store_id", "transaction_id", "product_id", "customer_id", "payment_method",
              "quantity", "unit_price", "discount_pct", "promo_id", "revenue", "cost", "gross_profit"]].copy()
fact["has_promo"] = sales.promo_id.notna().astype(int)
fact["is_guest"] = sales.customer_id.isna().astype(int)
fact["customer_type"] = np.where(fact.is_guest == 1, "Guest (no ID)", "Identified")
fact.to_csv(OUT / "fact_sales.csv", index=False)

# ---- dim_date: calendar plus text flags (easier to filter on in Power BI) and monthly inflation ----
cal = pd.read_csv(RAW / "calendar.csv", parse_dates=["date"])
cal["month_number"] = cal.date.dt.month
cal["month_name"] = cal.date.dt.strftime("%b")
cal["year_month"] = cal.date.dt.strftime("%Y-%m")
cal["quarter"] = "Q" + cal.date.dt.quarter.astype(str)
cal["day_number"] = cal.date.dt.dayofweek + 1                      # Monday = 1
cal["week_start"] = cal.date - pd.to_timedelta(cal.date.dt.dayofweek, unit="D")
cal["day_type"] = np.where(cal.is_weekend, "Weekend", "Weekday")
cal["payday_type"] = np.where(cal.is_payday_window, "Payday window", "Other days")
cal["holiday_type"] = np.where(cal.is_holiday, "Public holiday", "Other days")
infl = pd.read_csv(RAW / "kenya_inflation_monthly.csv").rename(columns={"month": "year_month",
        "twelve_month_inflation": "inflation_12m", "annual_average_inflation": "inflation_annual_avg"})
cal = cal.merge(infl, on="year_month", how="left")
cal = cal.drop(columns=["is_weekend", "is_holiday", "is_payday_window", "is_school_opening", "year", "month"])
cal.to_csv(OUT / "dim_date.csv", index=False)

# ---- dimensions ----
pd.read_csv(RAW / "stores.csv").to_csv(OUT / "dim_store.csv", index=False)
pd.read_csv(RAW / "products.csv").to_csv(OUT / "dim_product.csv", index=False)
promo = pd.read_csv(RAW / "promotions.csv"); promo["promo_label"] = promo.promo_id + " (" + promo.target + ", " + promo.discount_pct.astype(str) + "% off)"
promo.to_csv(OUT / "dim_promotion.csv", index=False)

# ---- dim_customer with RFM segment (same rules as SQL query 12; snapshot date = 2025-07-01) ----
cust = pd.read_csv(RAW / "customers.csv")
known = sales.dropna(subset=["customer_id"])
rfm = known.groupby("customer_id").agg(last_purchase=("date", "max"), frequency=("transaction_id", "nunique"), monetary=("revenue", "sum"))
rfm["recency_days"] = (pd.Timestamp("2025-07-01") - rfm.last_purchase).dt.days
def ntile(series, n=5, ascending=True):
    r = series.rank(method="first", ascending=ascending)
    return np.ceil(r * n / len(series)).astype(int)
rfm["r"] = ntile(rfm.recency_days, ascending=False)   # most recent buyers get the highest score
rfm["f"] = ntile(rfm.frequency); rfm["m"] = ntile(rfm.monetary)
def segment(row):
    if row.r >= 4 and row.f >= 4 and row.m >= 4: return "Champions"
    if row.f >= 4 and row.m >= 4: return "Loyal high spenders"
    if row.r >= 4: return "Recent customers"
    if row.r <= 2 and row.f >= 4: return "At risk"
    if row.r <= 2 and row.f <= 2: return "Lost"
    return "Regulars"
rfm["rfm_segment"] = rfm.apply(segment, axis=1)
cust = cust.merge(rfm[["recency_days", "frequency", "monetary", "rfm_segment"]], left_on="customer_id", right_index=True, how="left")
cust["rfm_segment"] = cust.rfm_segment.fillna("No purchases")
cust.to_csv(OUT / "dim_customer.csv", index=False)

# ---- forecast_weekly: test-period forecasts from milestone 6 ----
fc = pd.read_csv(ROOT / "04_forecasting" / "test_predictions.csv", parse_dates=["start"])
fc = fc.rename(columns={"store": "store_id", "start": "week_start", "y": "actual", "pred": "forecast", "mean4": "baseline_last4"})
fc["abs_error"] = (fc.forecast - fc.actual).abs()
fc["baseline_abs_error"] = (fc.baseline_last4 - fc.actual).abs()
fc["abs_pct_error"] = fc.abs_error / fc.actual
fc["baseline_abs_pct_error"] = fc.baseline_abs_error / fc.actual
num_cols = ["actual", "forecast", "baseline_last4", "abs_error", "baseline_abs_error", "abs_pct_error", "baseline_abs_pct_error"]
fc[num_cols] = fc[num_cols].round(4)
fc[["store_id", "week_start"] + num_cols].to_csv(OUT / "forecast_weekly.csv", index=False)

# ---- checks against numbers from earlier milestones ----
print(f"Revenue {fact.revenue.sum():,.0f} | gross profit {fact.gross_profit.sum():,.0f} | transactions {fact.transaction_id.nunique():,} | identified customers {fact.customer_id.nunique():,}")
print("RFM segments:"); print(cust.rfm_segment.value_counts().to_string())
print(f"Forecast MAE {fc.abs_error.mean():,.0f} vs baseline {fc.baseline_abs_error.mean():,.0f}; MAPE {100*fc.abs_pct_error.mean():.1f}%")
for f in sorted(OUT.glob("*.csv")): print(f"{f.name:22s} {len(pd.read_csv(f, low_memory=False)):>8,} rows  {f.stat().st_size/1e6:6.1f} MB")
