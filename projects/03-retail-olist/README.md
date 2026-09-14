# Project 3: Olist Customer Experience & Retention Analytics

> **Status:** complete. SQL analysis, an AI sentiment layer on real customer reviews, notebook, README, full report, and a live dashboard are all finished.

**Full report:** [report.md](report.md) is the written analysis.
**Live dashboard:** [Olist Retail - Revenue and Delivery Analysis](https://public.tableau.com/app/profile/michael.udousoro/viz/OlistRetail-RevenueandDeliveryAnalysis/OlistRetailAnalysis) on Tableau Public.

## The scenario

Olist is a Brazilian marketplace that connects small sellers to major online storefronts. This project analyses about 99,000 real orders placed on Olist between September 2016 and October 2018, to answer questions a Retention Lead, an Operations Manager, and a Category Manager would each genuinely ask: who are the valuable customers, does a late delivery actually cost you a good review, where does the experience break down across a country the size of Brazil, and what are customers saying in their own words that the star rating alone doesn't capture.

## The business questions

| Theme | Question |
|-------|----------|
| Customer value | Who are the valuable customers, and how common is a repeat customer on this platform? |
| Delivery and satisfaction | Does a late delivery actually hurt the review score, and by how much? |
| Geography | Which states have the best and worst delivery and satisfaction experience? |
| Category performance | Which product categories drive revenue, and does any of them have a quality problem? |
| Voice of customer (AI layer) | What do customers say in free-text reviews, and does that agree with the star rating they gave? |

## Data

- **Source:** Brazilian E-Commerce Public Dataset by Olist.
- **Shape:** 8 related tables covering customers, orders, order items, payments, reviews, products, sellers, and a category name translation table. Loaded into a local MySQL database, same setup as Project 5.
- **Period:** September 2016 to October 2018.
- Setup instructions: see [`sql/00_setup.md`](sql/00_setup.md).

## Findings

**Olist is an acquisition-driven marketplace, not a loyalty-driven one.** Only 3.0% of customers ever place a second order. Those repeat customers are worth almost twice as much individually (308 BRL average lifetime value versus 161 BRL for one-time buyers), but they're such a small share of the base that 94% of all revenue still comes from people who never come back. This isn't a broken retention funnel so much as the normal shape of a multi-seller marketplace where the relationship is mostly with the platform for a single purchase, not an ongoing brand relationship. The real lever here is acquisition efficiency and getting the first purchase right, not a loyalty programme.

**A late delivery is the single biggest driver of a bad review found in this analysis.** Orders delivered after Olist's own promised date average 2.57 stars, with 54% landing at 1 or 2 stars. Orders delivered on time or early average 4.29 stars, with only 9% that low. "Late" is measured against the date actually promised to that customer, not a fixed number of days, so this isolates the effect of a broken promise.

**Delivery time varies about three times over across Brazil's top states by order volume**, and satisfaction moves with it. Sao Paulo state, Olist's home base and 42% of all orders, sees 8.7-day average delivery and the best reviews (4.18 stars). The northern and northeastern states (Para, Maranhao, Ceara, Bahia) see 19 to 24 day average delivery and noticeably lower reviews. This tracks Brazil's own size and logistics infrastructure more than anything Olist directly controls, but it's a real, measurable gap in the experience by region.

**Health and beauty is the top revenue category and also reviews well** (4.19 stars). `office_furniture` is the one clear quality flag among the top 15 categories by revenue: a meaningfully lower 3.52-star average, worth a direct look at that category's return rates and product listings.

**The AI layer: does the review text agree with the star rating?** A pretrained multilingual sentiment model was run on a stratified sample of 2,500 reviews with real customer text (out of 40,977 total with text). The text and the star rating agree on direction (negative, neutral, positive) 67.8% of the time. Negative reviews are the easiest to confirm from text alone (86% agreement); neutral 3-star reviews are the hardest (only 22%), because a 3-star review usually contains a specific complaint even when the overall rating is middling. The genuinely useful finding is in the disagreements: 16.9% of 4 and 5 star reviews contain text the model reads as negative, a real hidden-complaint signal worth surfacing to a category or ops team even when the star rating alone looks fine. Some of these are model errors on short or informal text rather than real hidden complaints, and that limitation is discussed honestly in the full report, including a specific example where the model misread a genuinely negative review because Olist anonymises sellers with Game of Thrones house names, which a general-purpose model has no way to recognise as a brand.

## Limitations

- Only 41% of reviews include free text, and the sentiment sample (2,500 of 40,977) is a subset chosen for runtime practicality, not the full population.
- The sentiment model was not fine-tuned on this dataset or on e-commerce Portuguese specifically, and its accuracy is weakest on short, informal, or ambiguous text, as discussed in the report.
- No geolocation (zip-code to lat/lon) table was available for this build, so the geographic analysis is at the state level rather than city or delivery-route level.
- Currency figures are in Brazilian Real (BRL), not converted to another currency.

## Repro

```bash
# from the repo root
uv run jupyter lab   # notebooks/01_retail_analysis.ipynb has the full analysis
# SQL lives in sql/, numbered in the order it was written
```
