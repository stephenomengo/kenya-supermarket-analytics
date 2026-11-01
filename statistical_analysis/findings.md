# Statistical Findings

Six tests on the cleaned data (302,076 lines, 112,202 baskets, 731 days). Significance level 5%. After Holm correction for multiple testing, **two** results are significant: weekends and promotion revenue. Full table: `test_summary.csv`.

| # | Question | Test | Result | Conclusion |
|---|---|---|---|---|
| 1 | Do weekends earn more than weekdays? | Welch t-test, Mann-Whitney | +25% (KES 21,628 to 29,166 more per day), p < 0.001, Cohen's d = 1.13 | **Yes** |
| 2 | Did promotions raise sales? | Paired Wilcoxon on 88 products | Units +0.02/day (95% CI -0.16 to +0.19), p = 0.40. Net revenue -14%, p < 0.001 | **No extra units, and lower revenue** |
| 3 | Do M-Pesa customers spend more than cash customers? | Welch t-test, Mann-Whitney | KES 702 vs 704, difference -2.5 (95% CI -11.8 to +6.8), p = 0.60 | **No difference found** |
| 4 | Does inflation move with basket size? | Pearson, Spearman | r = -0.20 (95% CI -0.56 to 0.22), p = 0.35 | **No clear relationship** |
| 5 | Do loyalty tiers differ in spend per customer? | Kruskal-Wallis, ANOVA | p = 0.30 (ANOVA p = 0.11) | **No difference found** |
| 6 | Is payment method linked to location type? | Chi-square | chi2 = 5.68, p = 0.68, Cramer's V = 0.005 | **Independent** |

## In plain language
1. **Weekends:** a weekend day earns about 25% more than a weekday. A regression that also accounts for paydays, holidays, December and school opening gives similar effects: weekend +26%, payday +27%, December +30%, holiday +18%, school opening +13%. The model explains 59% of the variation in daily revenue. **Action:** staff and stock for weekends and paydays.
2. **Promotions:** products sold the same number of units on promotion days as on other days, but net revenue per product-day fell by about KES 139 (14%). The discounts cost money and brought no extra sales. **Action:** stop or redesign the promotions.
3. **Payments:** M-Pesa and cash baskets are the same size to within about KES 12, so accepting more M-Pesa should not change basket value.
4. **Inflation:** no relationship found, but 24 months is a small sample. Only correlations stronger than about 0.54 could be detected reliably, so a weak link is not ruled out.
5. **Loyalty tiers:** typical (median) spend is almost identical across tiers (about KES 4,200 to 4,450). Silver's higher average comes from a few very large spenders, so the tiers do not identify better customers.
6. **Payment and location:** payment shares are nearly identical in urban, peri-urban and rural stores.

## Assumption checks
- Daily revenue is right-skewed (Shapiro p < 0.001), so the Welch t-test was confirmed with Mann-Whitney. The two agree.
- Regression residuals: Durbin-Watson 1.68 (mild autocorrelation), Breusch-Pagan p = 0.27 (constant variance). Robust standard errors were used.
- Basket values are strongly skewed (3.3), so tests were repeated on the log scale and with Mann-Whitney. Same conclusion.
- Chi-square: the smallest expected count is 121, well above the minimum of 5.

## Limits
The data is simulated, and only the calendar effects were built in on purpose. Non-significant results mean no effect was found in this dataset, not that none exists in real stores. Promotion days were not randomly assigned, so seasonality could play a small part in test 2.
