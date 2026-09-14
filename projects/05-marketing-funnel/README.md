# Project 5 — Maven Fuzzy Factory: Marketing & Website Analytics

> **Status:** in progress. Findings and recommendations are filled in as the analysis proceeds.

**Live dashboard:** [Marketing & Funnel Overview on Tableau Public](https://public.tableau.com/app/profile/michael.udousoro/viz/MavenFuzzyFactory-MarketingFunnelAnalysis/MarketingFunnelOverview)

## The scenario

Maven Fuzzy Factory is a (simulated) e-commerce startup that sells plush toys
online. It launched in **March 2012**. I am its first data analyst. Over the
company's first three years, the CEO, the Marketing Director and the Website
Manager send me questions by email. I answer each one with SQL, then package
the results into a dashboard and a written analysis for the leadership team.

## The business questions

| Theme | Question |
|-------|----------|
| Traffic sources | Which marketing channels bring sessions, and which bring *paying customers*? |
| Bid optimisation | Where should we increase or cut paid-search spend, by channel and device? |
| Conversion funnel | Where in the click path do users drop off before ordering? |
| Website testing | Did the new landing page and the new checkout page lift conversion? |
| Product & seasonality | How did product launches perform, and what is the seasonal pattern of demand? |

## Data

- **Source:** Maven Fuzzy Factory database, from Maven Analytics' *Advanced SQL:
  MySQL Data Analysis & Business Intelligence* course. Credit: Maven Analytics.
- **Shape:** 6 related tables — `website_sessions`, `website_pageviews`,
  `orders`, `order_items`, `order_item_refunds`, `products`.
- **Period:** March 2012 – March 2015.
- Download and load instructions: see [`sql/00_setup.md`](sql/00_setup.md).

## Approach

1. Load the database into local MySQL; verify row counts and date ranges.
2. Traffic-source analysis — sessions, orders, conversion rate by channel.
3. Bid optimisation — segment by device and campaign.
4. Conversion funnel — pageview-path analysis, step-by-step drop-off.
5. Website A/B tests — before/after conversion, tested for significance.
6. Product & seasonality — launch impact, monthly and year-over-year trends.
7. Tableau dashboard.
8. This case study: findings + recommendations.

## Findings

**Traffic mix.** The business runs on paid search: `gsearch` + `bsearch` are
~72% of sessions, `gsearch/nonbrand` alone is 60%. Direct + organic ("(none)")
is ~17.5% — a rough proxy for brand strength.

**Conversion by channel is misleading until you control for repeat visitors.**
Blended across all sessions, `brand` search and direct/organic look like the
best converters (7.3–8.9% vs 6.7–7.0% for nonbrand). But 63–64% of those
sessions are **returning** visitors, who convert far more often regardless of
channel. Restricted to first-time sessions, gsearch nonbrand, bsearch nonbrand,
direct/organic, and gsearch brand all converge to ~6.7–6.9% — channel choice
barely matters for new-customer conversion. Only `bsearch/brand` stays
meaningfully higher (8.4%), on small volume. `socialbook/pilot` is a clear
outlier at 1.08% (vs 5.15% for its sibling campaign) — something in that
campaign (landing page, targeting, or device mix) is broken.

**Desktop converts ~2.6× better than mobile** on gsearch nonbrand
(8.22% vs 3.18%, new visitors). Both devices improved steadily from 2012 to
2015 (desktop 4.4%→10.5%, mobile 1.4%→3.6%) as the site itself got better,
but the desktop/mobile *ratio* has not closed — it narrowed through 2013–14
then widened again in early 2015, currently back near 3×.

## Recommendations

1. **Apply a mobile bid discount (~50–60%) on gsearch nonbrand.** Desktop
   converts 2.6× better; mobile is 31% of sessions but only 15% of orders.
   Re-check the ratio quarterly rather than setting it once — it has moved
   between 2.1× and 5.5× over the dataset's history.
2. **Investigate brand-search spend.** ~64% of brand-search sessions are
   returning customers who would likely reach the site anyway via direct or
   organic. Recommend a geo holdout test (pause brand bids in a sample of
   regions, watch total conversions) to size the true incremental value.
3. **Audit `socialbook/pilot`.** 5,095 sessions, 55 orders, 1.08% conversion —
   5× worse than the comparable `desktop_targeted` campaign. Check its landing
   page and device mix before spending further on it.

**The conversion funnel leaks most at the top, but bleeds most expensively at
the bottom.** Landing→product (55.2% click-through) and product→cart (36.3%)
together account for ~378k of the ~440k sessions that never convert — most of
that is normal browsing behaviour, but the scale makes it the biggest lever.
More concerning: **billing→order is only 62.1%** — 38% of visitors who already
entered shipping details abandon at the payment step, the most qualified
traffic in the funnel to be losing. The site already has 6 landing-page
variants (`/home` + 5 `/lander-N`) and two billing-page versions
(`/billing` → `/billing-2`, a 13× volume shift) — evidence of prior A/B tests
whose results aren't yet quantified here.

4. **Evaluate the billing-page redesign** (`/billing` vs `/billing-2`) and the
   landing-page tests (`/home` vs each `/lander-N`) directly — the data
   suggests tests were run; we haven't yet confirmed they worked.

_(Website-test and product/seasonality sections still to come.)_

## Repro

```bash
# from the repo root
uv run jupyter lab   # notebooks/ contains the analysis
# SQL lives in sql/, numbered in the order it was written
```
