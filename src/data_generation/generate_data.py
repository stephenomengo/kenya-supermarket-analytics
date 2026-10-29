"""Synthetic Kenyan supermarket data generator. All records are fictional."""
import numpy as np, pandas as pd
from pathlib import Path

SEED = 2026
rng = np.random.default_rng(SEED)
OUT = Path(__file__).resolve().parents[2] / "data" / "raw"
OUT.mkdir(parents=True, exist_ok=True)
START, END = "2023-07-01", "2025-06-30"

# ---------- Stores ----------
stores = pd.DataFrame([
    ("S01", "Westlands Fresh Mart", "Nairobi", "Urban", 1.6),
    ("S02", "Kasarani Value Stop", "Nairobi", "Urban", 1.3),
    ("S03", "Nyali Family Supermarket", "Mombasa", "Urban", 1.2),
    ("S04", "Kisumu Lakeside Mart", "Kisumu", "Urban", 1.0),
    ("S05", "Nakuru Town Grocers", "Nakuru", "Urban", 1.0),
    ("S06", "Eldoret Highlands Mart", "Uasin Gishu", "Urban", 0.9),
    ("S07", "Nyeri Central Stores", "Nyeri", "Peri-urban", 0.7),
    ("S08", "Machakos Market Basket", "Machakos", "Peri-urban", 0.7),
    ("S09", "Kisii Hilltop Mart", "Kisii", "Peri-urban", 0.6),
    ("S10", "Kitale Farmers Mart", "Trans Nzoia", "Rural", 0.5),
], columns=["store_id", "store_name", "county", "location_type", "size_factor"])
stores["open_date"] = pd.to_datetime(rng.choice(pd.date_range("2015-01-01", "2022-12-31"), len(stores)))

# ---------- Products ----------
base = {
    "Staples & Grains": [("Maize Flour", 140), ("Pishori Rice", 230), ("Wheat Flour", 150), ("Sugar", 160),
                         ("Cooking Oil", 330), ("Spaghetti", 110), ("Beans", 190), ("Salt", 50)],
    "Dairy & Eggs": [("Fresh Milk", 65), ("Yoghurt", 90), ("Butter", 260), ("Eggs Tray", 420), ("Cheese Slices", 310)],
    "Beverages": [("Black Tea Leaves", 120), ("Instant Coffee", 380), ("Bottled Water", 60), ("Fruit Juice", 160),
                  ("Soda", 70), ("Energy Drink", 120)],
    "Fresh Produce": [("Tomatoes", 80), ("Onions", 90), ("Kale (Sukuma)", 40), ("Potatoes", 100),
                      ("Bananas", 70), ("Avocados", 60), ("Cabbage", 50), ("Carrots", 80)],
    "Household & Cleaning": [("Laundry Soap Bar", 90), ("Washing Powder", 220), ("Dish Wash Liquid", 180),
                             ("Toilet Paper 4pk", 190), ("Bleach", 150), ("Matchbox 10pk", 40)],
    "Personal Care": [("Bar Soap", 70), ("Toothpaste", 150), ("Body Lotion", 280), ("Shampoo", 260),
                      ("Sanitary Pads", 130), ("Deodorant", 240)],
    "Snacks & Confectionery": [("Biscuits", 60), ("Crisps", 50), ("Chocolate Bar", 90), ("Peanuts", 70),
                               ("Mandazi Mix", 110), ("Sweets Pack", 40)],
    "Baby & Health": [("Baby Diapers", 950), ("Baby Wipes", 220), ("Baby Cereal", 480),
                      ("Pain Relief Tablets", 120), ("Hand Sanitizer", 160)],
}
sizes = [("Small", 0.6), ("Regular", 1.0), ("Family", 1.8)]
rows, pid = [], 1
for cat, items in base.items():
    for name, price in items:
        for label, mult in sizes:
            if rng.random() < 0.72:  # not every size exists for every item
                p = max(round(price * mult * rng.uniform(0.92, 1.1) / 5) * 5, 20)
                rows.append((f"P{pid:03d}", f"{name} - {label}", cat, p, round(p * rng.uniform(0.68, 0.88))))
                pid += 1
products = pd.DataFrame(rows, columns=["product_id", "product_name", "category", "unit_price", "unit_cost"])
products["popularity"] = rng.pareto(1.6, len(products)) + 0.3

# ---------- Customers ----------
n_cust = 5000
customers = pd.DataFrame({
    "customer_id": [f"C{i:05d}" for i in range(1, n_cust + 1)],
    "home_county": rng.choice(stores["county"].values, n_cust, p=stores["size_factor"] / stores["size_factor"].sum()),
    "age_group": rng.choice(["18-24", "25-34", "35-44", "45-54", "55+"], n_cust, p=[.14, .34, .27, .16, .09]),
    "loyalty_tier": rng.choice(["Basic", "Silver", "Gold"], n_cust, p=[.62, .28, .10]),
    "signup_date": rng.choice(pd.date_range("2021-01-01", "2025-05-31"), n_cust),
})
cust_w = rng.pareto(2.0, n_cust) + 0.2
cust_w /= cust_w.sum()

# ---------- Calendar ----------
cal = pd.DataFrame({"date": pd.date_range(START, END)})
cal["year"], cal["month"], cal["day_of_week"] = cal.date.dt.year, cal.date.dt.month, cal.date.dt.day_name()
cal["is_weekend"] = cal.date.dt.dayofweek >= 5
fixed = {"01-01": "New Year", "05-01": "Labour Day", "06-01": "Madaraka Day", "10-20": "Mashujaa Day",
         "12-12": "Jamhuri Day", "12-25": "Christmas", "12-26": "Boxing Day"}
moving = {"2024-03-29": "Good Friday", "2024-04-01": "Easter Monday",
          "2025-04-18": "Good Friday", "2025-04-21": "Easter Monday"}
cal["holiday_name"] = cal.date.dt.strftime("%m-%d").map(fixed)
cal["holiday_name"] = cal["holiday_name"].fillna(cal.date.dt.strftime("%Y-%m-%d").map(moving))
cal["is_holiday"] = cal.holiday_name.notna()
cal["is_payday_window"] = (cal.date.dt.day >= 25) | (cal.date.dt.day <= 2)
cal["is_school_opening"] = cal.month.isin([1, 5, 8]) & (cal.date.dt.day <= 10)

# ---------- Promotions ----------
promo_rows = []
for i in range(1, 61):
    s = pd.Timestamp(rng.choice(pd.date_range(START, "2025-06-01")))
    d = int(rng.integers(5, 21))
    by_cat = rng.random() < 0.35
    tgt = rng.choice(products.category.unique()) if by_cat else rng.choice(products.product_id)
    promo_rows.append((f"PR{i:03d}", "Category" if by_cat else "Product", tgt, s,
                       s + pd.Timedelta(days=d), int(rng.choice([5, 10, 15, 20, 25]))))
promotions = pd.DataFrame(promo_rows, columns=["promo_id", "scope", "target", "start_date", "end_date", "discount_pct"])
exp = []
for r in promotions.itertuples():
    pids = products.loc[products.category == r.target, "product_id"] if r.scope == "Category" else [r.target]
    for d in pd.date_range(r.start_date, r.end_date):
        for p in pids:
            exp.append((d, p, r.promo_id, r.discount_pct))
promo_lookup = (pd.DataFrame(exp, columns=["date", "product_id", "promo_id", "discount_pct"])
                .sort_values("discount_pct", ascending=False).drop_duplicates(["date", "product_id"]))

# ---------- Transactions ----------
month_season = {1: 1.05, 2: .95, 3: .97, 4: 1.05, 5: 1.0, 6: .96, 7: .98, 8: 1.02, 9: .97, 10: 1.0, 11: 1.03, 12: 1.3}
dow_f = {0: .88, 1: .9, 2: .92, 3: .97, 4: 1.12, 5: 1.3, 6: 1.1}
parts = []
for s in stores.itertuples():
    mult = (cal.month.map(month_season) * cal.date.dt.dayofweek.map(dow_f)
            * np.where(cal.is_payday_window, 1.25, 1) * np.where(cal.is_holiday, 1.15, 1)
            * np.where(cal.is_school_opening, 1.1, 1)).values
    lam = 14 * s.size_factor * mult * (1 + 0.03 * np.arange(len(cal)) / len(cal))  # mild growth
    n = rng.poisson(lam)
    parts.append(pd.DataFrame({"date": np.repeat(cal.date.values, n), "store_id": s.store_id}))
baskets = pd.concat(parts, ignore_index=True)
baskets["transaction_id"] = [f"T{i:07d}" for i in range(1, len(baskets) + 1)]
baskets["n_lines"] = np.clip(1 + rng.poisson(1.7, len(baskets)), 1, 9)
baskets["payment_method"] = rng.choice(["M-Pesa", "Cash", "Card", "Airtel Money", "Other"],
                                       len(baskets), p=[.52, .28, .14, .04, .02])
has_cust = rng.random(len(baskets)) < 0.58
baskets["customer_id"] = np.where(has_cust, rng.choice(customers.customer_id.values, len(baskets), p=cust_w), None)

lines = baskets.loc[baskets.index.repeat(baskets.n_lines)].reset_index(drop=True)
# Each basket gets distinct products (weighted sampling without replacement, Efraimidis-Spirakis),
# so a repeated transaction/product line is always a data error, never a real purchase.
pw = (products.popularity / products.popularity.sum()).values
keys = rng.random((len(baskets), len(products))) ** (1 / pw)
order = np.argsort(-keys, axis=1)[:, :9]
mask = np.arange(9)[None, :] < baskets.n_lines.values[:, None]
lines["product_id"] = products.product_id.values[order[mask]]
lines["quantity"] = 1 + rng.poisson(0.6, len(lines))
lines = lines.merge(products[["product_id", "unit_price"]], on="product_id", how="left")
lines = lines.merge(promo_lookup[["date", "product_id", "promo_id", "discount_pct"]],
                    on=["date", "product_id"], how="left")
lines["discount_pct"] = lines.discount_pct.fillna(0).astype(int)
lines["line_total"] = (lines.quantity * lines.unit_price * (1 - lines.discount_pct / 100)).round(2)
lines = lines.drop(columns="n_lines")

# ---------- Documented data-quality issues (for cleaning practice) ----------
idx = lines.sample(frac=0.004, random_state=SEED).index; lines.loc[idx, "payment_method"] = None
idx = lines.sample(frac=0.001, random_state=SEED + 1).index; lines.loc[idx, "quantity"] *= -1
idx = lines.sample(frac=0.0005, random_state=SEED + 2).index; lines.loc[idx, "unit_price"] *= 10
lines = pd.concat([lines, lines.sample(frac=0.002, random_state=SEED + 3)], ignore_index=True)
lines = lines.sort_values(["date", "transaction_id"]).reset_index(drop=True)
lines.insert(0, "line_id", range(1, len(lines) + 1))

# ---------- Save ----------
products.drop(columns="popularity").to_csv(OUT / "products.csv", index=False)
stores.drop(columns="size_factor").to_csv(OUT / "stores.csv", index=False)
customers.to_csv(OUT / "customers.csv", index=False)
promotions.to_csv(OUT / "promotions.csv", index=False)
cal.to_csv(OUT / "calendar.csv", index=False)
lines.to_csv(OUT / "sales_transactions.csv", index=False)
print({k: len(v) for k, v in dict(stores=stores, products=products, customers=customers,
                                    promotions=promotions, calendar=cal, sales=lines).items()})
