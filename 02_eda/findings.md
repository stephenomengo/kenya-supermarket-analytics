# Five Findings That Matter Most

Data: 302,076 cleaned sales lines, 112,202 baskets, 10 stores, July 2023 to June 2025. Total revenue KES 78.9 million, gross margin 21.9%, average basket KES 703 (median KES 520).

## 1. Sales are driven by the calendar
- December revenue is about 33% higher than the average of other months (`figures/02_monthly_revenue.png`).
- Weekend days earn about 25% more than weekdays, paydays (25th to 2nd) about 28% more, and public holidays about 36% more (`figures/04_calendar_effects.png`).
- The payday effect still holds at +29% when looking only at non-December weekdays, so it is not just a weekend or December effect.
- Revenue was flat between year 1 and year 2 (-0.2%), so there is no growth trend.
- **Action:** staff and stock up for December, weekends and paydays.

## 2. Revenue is concentrated in a few stores
- The 6 urban stores make 73% of revenue. Westlands alone makes 16%, and the rural Kitale store 6% (`figures/05_stores.png`).
- Average revenue per store: urban KES 9.6M, peri-urban KES 5.6M, rural KES 4.4M.
- Gross margin is the same (21.9%) in every location type, so the gap is volume, not pricing.
- **Action:** protect the top stores first, and review whether the weakest stores can grow volume.

## 3. A small set of products carries the business
- The top 10 of 98 products make 48% of revenue, and the top 20% make 65% (`figures/07_top_products.png`).
- Staples & Grains is the biggest category (27% of revenue), followed by Baby & Health (17%).
- Margins are similar across categories: Personal Care is highest at 24.3% and Household & Cleaning lowest at 19.3% (`figures/06_categories.png`).
- **Action:** keep the top products always in stock, and look at why Household & Cleaning earns the thinnest margin.

## 4. Customers: a few matter a lot, and loyalty tiers do not separate them
- 42% of revenue comes from guest checkouts with no customer ID, so the chain cannot track almost half its sales.
- Among identified customers, the top 10% generate 51% of revenue (`figures/08_customer_concentration.png`).
- Loyalty tier does not track spending: Gold customers spend the least per customer (KES 7,689) and Silver the most (KES 11,890) (`figures/09_customer_segments.png`). Identified and guest baskets are almost the same size (KES 704 vs 702).
- **Action:** push loyalty sign-up at the till, and redesign the tiers so they reflect spend.

## 5. Payments and promotions show no visible effect
- M-Pesa is 52% of baskets, cash 28%, card 14%, Airtel Money 4%. Average basket is about KES 700 for every method, so payment method does not appear to change how much people spend (`figures/10_payments.png`).
- 6% of lines are sold on promotion with an average discount of 14.6%. Quantity per line is 1.61 on promotion and 1.60 without, so promotions did not lift quantities. The discounts cost about KES 645k (0.8% of list-price sales).
- **To test formally in milestone 5.**

## Limits
The data is simulated. Some patterns (calendar effects, store sizes) were built in on purpose. The absence of payment, loyalty and promotion effects partly reflects how the data was generated, so report these as results from this dataset, not as claims about real Kenyan retail.
