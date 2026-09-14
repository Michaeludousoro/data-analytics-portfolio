# Project 5: Maven Fuzzy Factory Marketing & Website Analytics

> **Status:** complete. SQL analysis, notebook, dashboard, and this write-up are all finished.

**Live dashboard:** [Marketing & Funnel Overview on Tableau Public](https://public.tableau.com/app/profile/michael.udousoro/viz/MavenFuzzyFactory-MarketingFunnelAnalysis/MarketingFunnelOverview)
**Full report:** [report.md](report.md) is the written analysis (about 1,900 words), if you want the whole narrative rather than this skim version.

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
- **Shape:** 6 related tables: `website_sessions`, `website_pageviews`,
  `orders`, `order_items`, `order_item_refunds`, `products`.
- **Period:** March 2012 to March 2015.
- Download and load instructions: see [`sql/00_setup.md`](sql/00_setup.md).

## Approach

1. Load the database into local MySQL; verify row counts and date ranges.
2. Traffic-source analysis: sessions, orders, conversion rate by channel.
3. Bid optimisation: segment by device and campaign.
4. Conversion funnel: pageview-path analysis, step-by-step drop-off.
5. Website A/B tests: before/after conversion, tested for significance.
6. Product & seasonality: launch impact, monthly and year-over-year trends.
7. Tableau dashboard.
8. This case study: findings and recommendations.

## Findings

**Traffic mix.** The business runs on paid search. `gsearch` and `bsearch`
together are about 72% of sessions, and `gsearch/nonbrand` alone is 60%.
Direct plus organic ("(none)") is about 17.5%, a rough proxy for brand
strength.

**Conversion by channel is misleading until you control for repeat visitors.**
Blended across all sessions, `brand` search and direct/organic look like the
best converters (7.3 to 8.9% vs 6.7 to 7.0% for nonbrand). But 63 to 64% of
those sessions are **returning** visitors, who convert far more often
regardless of channel. Restricted to first-time sessions, gsearch nonbrand,
bsearch nonbrand, direct/organic, and gsearch brand all converge to about
6.7 to 6.9%. Channel choice barely matters for new-customer conversion.
Only `bsearch/brand` stays meaningfully higher (8.4%), on small volume.
`socialbook/pilot` is a clear outlier at 1.08% (vs 5.15% for its sibling
campaign). Something in that campaign, whether it's the landing page,
targeting, or device mix, is broken.

**Desktop converts about 2.6x better than mobile** on gsearch nonbrand
(8.22% vs 3.18%, new visitors). Both devices improved steadily from 2012 to
2015 (desktop 4.4% to 10.5%, mobile 1.4% to 3.6%) as the site itself got
better, but the desktop/mobile *ratio* has not closed. It narrowed through
2013 to 2014, then widened again in early 2015, and is currently back near
3x.

## Recommendations

1. **Apply a mobile bid discount (about 50 to 60%) on gsearch nonbrand.**
   Desktop converts 2.6x better; mobile is 31% of sessions but only 15% of
   orders. Re-check the ratio quarterly rather than setting it once, since it
   has moved between 2.1x and 5.5x over the dataset's history.
2. **Investigate brand-search spend.** About 64% of brand-search sessions are
   returning customers who would likely reach the site anyway via direct or
   organic traffic. Recommend a geo holdout test, pausing brand bids in a
   sample of regions and watching total conversions, to size the true
   incremental value.
3. **Audit `socialbook/pilot`.** 5,095 sessions, 55 orders, 1.08% conversion.
   That's 5x worse than the comparable `desktop_targeted` campaign. Check its
   landing page and device mix before spending further on it.

**The conversion funnel leaks most at the top, but bleeds most expensively at
the bottom.** Landing to product (55.2% click-through) and product to cart
(36.3%) together account for about 378,000 of the 440,000 sessions that never
convert. Most of that is normal browsing behaviour, but the scale makes it
the biggest lever. More concerning is that **billing to order is only 62.1%**.
That means 38% of visitors who already entered shipping details abandon at
the payment step, the most qualified traffic in the funnel to be losing. The
site already has 6 landing-page variants (`/home` plus 5 `/lander-N`) and two
billing-page versions (`/billing` replaced by `/billing-2`, a 13x volume
shift), which is evidence of prior A/B tests whose results weren't yet
quantified before this analysis.

4. **The billing-page redesign is a confirmed win. Keep it, no action needed.**
   `/billing-2` converts sessions that reach checkout at 63.4% vs the
   original `/billing`'s 44.8% (an 18.6 point gain, about 41% relative lift).
   The two pages were live at the same time for about 4 months before the
   original was retired, so this is close to a genuine A/B result, not just
   "things got better over time."

5. **`/lander-3` is a confirmed losing landing-page variant.** It ran
   at the same time as `/lander-2` for 18 months (same era, same conditions)
   and converted at less than half the rate (3.39% vs 7.72%). If it's still
   live, retire it. `/lander-5` (current, since Aug 2014) shows the highest
   raw rate (10.17%), but that partly reflects running during the site's
   best-converting era. A rigorous like-for-like comparison would need to
   control for time period, which is a natural next analysis rather than a
   finished one here.

6. **Lean into November and December.** Order volume spikes hard every year
   in the run-up to Christmas (December 2014 was the single highest month in
   the dataset). Marketing budget, inventory, and staffing should be planned
   around this, not spread evenly across the year.

## Website tests

| Test | Result |
|---|---|
| `/billing` vs `/billing-2` | `/billing-2` wins clearly: 63.4% vs 44.8% billing-to-order conversion, tested with a 4-month overlap window |
| `/lander-2` vs `/lander-3` (concurrent, Jul 2013 to Dec 2014) | `/lander-2` wins clearly: 7.72% vs 3.39% |
| `/home`, `/lander-1`, `/lander-4`, `/lander-5` | Ran in non-overlapping windows. Directionally `/lander-5` (10.17%, most recent) looks strongest, but the comparison isn't era-controlled |

## Products & seasonality

- **Mr. Fuzzy is the flagship.** Launched with the company (Mar 2012), with
  23,861 orders and $1.42M in revenue, far ahead of the three later
  cross-sell launches. That's mostly because it's had 3 years on the market
  versus their several months to a year. Monthly run-rate across the three
  newer products is fairly consistent, around 165 to 205 orders a month
  each.
- **Clear, consistent holiday seasonality.** Orders spike every November and
  December (Black Friday, Cyber Monday, and Christmas gifting), then ease
  off into the new year. December 2014 (2,314 orders) is the dataset's peak
  month.

## Repro

```bash
# from the repo root
uv run jupyter lab   # notebooks/ contains the analysis
# SQL lives in sql/, numbered in the order it was written
```
