# Forecast Metrics and Findings

**Task:** forecast next week's revenue for each of the 10 stores, using history up to last week and the known calendar of the target week. Time-ordered split: train Jul 2023 - Jun 2024, validation Jul - Dec 2024, test Dec 2024 - Jun 2025 (26 weeks x 10 stores).

## Results (test set, used once)
| Model | MAE (KES) | RMSE (KES) | MAPE | Bias (KES) |
|---|---|---|---|---|
| Baseline: same as last week | 14,468 | 18,167 | 20.9% | +1,024 |
| Baseline: average of last 4 weeks | 11,848 | 15,005 | 17.3% | +2,241 |
| Baseline: same week last year | 11,197 | 14,689 | 16.1% | +315 |
| **Model: Ridge on log revenue (alpha 0.1)** | **8,130** | **10,291** | **12.0%** | +268 |

- The model was chosen on the validation set (MAE 7,868, against 10,240 for the best baseline there). Gradient boosting reached 8,062 and was not better, so the simpler model was kept.
- On the test set the model's MAE is **31% lower** than the baseline chosen on validation (last 4 weeks) and **27% lower** than the best baseline on test (same week last year).
- The improvement is stable: across four rolling 13-week windows, the model beat the best baseline by 20% to 31%.

## What the model gets wrong
- **Store-level bias:** it over-forecasts store S05 by about KES 4,300 a week and S01 by 2,800, and under-forecasts S02 by 2,600. It uses one store effect for the whole period, so it misses store-specific drift.
- **Weak stores are harder:** MAPE is 8% to 10% for the large urban stores (S01, S02, S03) and 13% to 16% for the smaller ones (S04, S06 to S10), where a few customers more or less is a bigger share.
- **Biggest misses:** the worst eight forecasts are 15% to 46% off. Six are ordinary weeks with no holiday (for example S04 in the week of 5 May 2025: forecast 78k, actual 54k), and nothing in the calendar explains them, so they look like random swings in customer numbers. Two are holiday weeks where it under-forecast the peak (S02 in the weeks of 30 Dec 2024 and 28 Apr 2025).
- **Holiday weeks** are not worse than ordinary weeks (average error -1.8% against +3.4%), so the holiday feature works.
- **Mild over-forecasting overall in ordinary weeks** (+3.4%), partly because a forecast based on past weeks is a little high when demand dips.

## How close to the limit?
Customer counts and basket sizes are random, so even a perfect model would miss by roughly 11% (MAPE) on weekly store revenue. The model's 12.0% is only about 0.8 points above that, so there is little room left to improve with this data.

## What drives the forecast
Store identity matters most by far (store size), then the payday-window days in the week, then school-opening days and holidays. Last week's revenue adds little once store and calendar are known.

## Limits
- Only 24 months of simulated data: the model has seen each calendar event once or twice (for example one December before the validation period).
- Weekly forecasts for the test period were made one week ahead. Forecasting further ahead would need different inputs.
- The data is synthetic, so the tidy calendar effects are partly built in, and real stores would be messier.
