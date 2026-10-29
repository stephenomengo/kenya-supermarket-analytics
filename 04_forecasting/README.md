# 04 - Demand Forecasting

**Goal:** forecast monthly demand by store and product category, and test whether a model beats a simple baseline.

## Approach
1. Aggregate sales to monthly level
2. Baseline: seasonal-naive (same month last year)
3. Candidate model(s), e.g. Holt-Winters, SARIMA or a gradient-boosted model with calendar features
4. Time-based train/test split (no shuffling)
5. Compare with MAE / RMSE / MAPE

## Planned contents
- `forecasting.ipynb`
- `metrics.md` - model vs baseline results
- `figures/`
