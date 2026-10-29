# Problem Statement

## Context
A mid-sized Kenyan supermarket chain with 10 stores across 10 counties wants to understand what drives its sales and how to plan stock and promotions better. The data is synthetic and covers July 2023 to June 2025.

## Business questions
1. How do sales vary by month, weekday, payday and holiday, and by store and county type?
2. Which categories and products drive revenue and margin?
3. Did promotions increase sales enough to justify the discounts?
4. Do customers who pay with M-Pesa spend more than those who pay by cash or card?
5. Which customers are the most valuable (cohorts and RFM segments)?
6. Does national inflation (CPI) relate to basket value and demand?
7. Can we forecast monthly demand better than a "same month last year" baseline?

## How success is measured
- A cleaned dataset with every fix documented (before/after counts)
- Findings backed by SQL queries and statistical tests with plain-language conclusions
- A forecast with lower error (MAE / RMSE) than the seasonal-naive baseline
- A dashboard a store manager can use without help

## Where each question is answered
| Questions | Milestone |
|---|---|
| 1, 2 | 3 - Exploratory Data Analysis |
| 5 | 4 - SQL Analytics |
| 3, 4, 6 | 5 - Statistical Analysis |
| 7 | 6 - Predictive Model |
| All | 7 - Dashboard and Storytelling |
