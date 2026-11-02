# 04 - Demand Forecasting

**Goal:** forecast next week's revenue per store and test whether a model beats simple baselines.

## Contents
- `forecasting.ipynb` - the full pipeline: weekly dataset, time-ordered split, baselines, two models, tuning on validation, one final test, rolling-origin backtest, error analysis, feature importance
- `metrics.md` - results, comparison with baselines and what the model gets wrong
- `model_comparison.csv` - test-set metrics for baselines and model
- `test_predictions.csv` - every test-set forecast (store, week, actual, predicted, baselines)
- `figures/` - 7 charts

## Approach
1. Aggregate to store x week (104 complete weeks)
2. Baselines: same as last week, average of last 4 weeks, same week last year
3. Models: Ridge on log revenue, gradient boosting; settings tuned on validation only
4. Time-based split with no shuffling; the test set is used once
5. Metrics: MAE, RMSE, MAPE, bias

## Run
Run milestone 2 first (it creates `data/clean/sales_clean.csv`), then run all cells. Needs `scikit-learn`.
