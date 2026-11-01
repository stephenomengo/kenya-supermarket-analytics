# Statistical Analysis

**Goal:** test six business questions with hypothesis tests and confidence intervals, checking each test's assumptions first.

## Contents
- `statistical_analysis.ipynb` - the analysis (setup, six tests, summary table with Holm correction)
- `findings.md` - plain-language conclusion for each test
- `test_summary.csv` - one row per test with p-value, adjusted p-value and effect
- `figures/` - assumption and result charts

## Tests
1. Weekend vs weekday revenue (Welch t-test, Mann-Whitney, regression with controls)
2. Promotions vs normal days (paired Wilcoxon on units and net revenue)
3. M-Pesa vs cash basket value (Welch, Mann-Whitney, Kruskal-Wallis)
4. Inflation vs average basket (Pearson, Spearman, power check)
5. Loyalty tier vs spend per customer (Kruskal-Wallis, ANOVA)
6. Payment method vs location type (chi-square, Cramer's V)

## Run
Run milestone 2 first (it creates `data/clean/sales_clean.csv`), then run all cells. Needs `scipy` and `statsmodels`.
