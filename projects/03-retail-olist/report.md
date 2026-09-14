# Olist Customer Experience and Retention Analysis

**Prepared for:** Retention Lead, Operations Manager, Category Manager
**Prepared by:** Michael Udousoro, Data Analyst
**Period covered:** September 2016 to October 2018

## Executive summary

This report analyses about 99,000 real orders placed on Olist, a Brazilian multi-seller marketplace, to answer five questions. Who are the valuable customers, and how common is a repeat one. Does a late delivery actually cost a good review. Where across Brazil does the delivery experience break down. Which product categories are pulling their weight. And, using an AI sentiment model on the free-text reviews themselves, what are customers actually saying that the star rating alone doesn't capture.

The short version: this is a marketplace built on new customer acquisition, not repeat loyalty, since only 3% of customers ever buy a second time. A late delivery is the clearest single driver of a bad review found anywhere in this analysis, cutting the average score by nearly two full stars. Delivery experience varies sharply by region in a country the size of Brazil, tracking geography as much as anything the platform controls. One product category, office furniture, stands out with a real quality problem despite solid revenue. And the AI layer on review text agrees with the star rating about two-thirds of the time, which is genuinely useful on its own but also comes with real, explainable limitations worth being upfront about.

## 1. Data and method

The analysis uses eight related tables covering customers, orders, order line items, payments, reviews, products, sellers, and a category name translation table, loaded into a local MySQL database and queried directly in SQL. All 13 SQL files used are saved in the project's `sql/` folder, numbered in the order they were written, so the whole analysis can be rerun by anyone.

One detail matters for reading every customer-level result correctly. Olist assigns a new `customer_id` every time the same person checks out, so counting by `customer_id` alone would make every customer look like a one-time buyer by definition. A separate `customer_unique_id` field identifies the actual person across orders, and that is the key used throughout this report wherever "customer" means a real person rather than a transaction.

For the AI-augmented section, 41% of reviews (40,977 out of 99,224) include free-text comments written in Portuguese. Running a large language model on all of them was not practical within this project's time budget, so a stratified sample of 2,500 reviews was drawn, 500 for each star rating from 1 to 5, and scored with a pretrained multilingual sentiment model (`nlptown/bert-base-multilingual-uncased-sentiment`), which predicts a 1 to 5 star rating directly from text. That prediction is then compared against the star rating the customer actually gave.

## 2. Who are the valuable customers, and how common is a repeat one?

Restricted to orders that were not cancelled or marked unavailable, 94,990 unique customers placed 98,207 orders. Of those customers, 96.96% bought exactly once, and only 3.04% (2,888 customers) ever placed a second order.

Those repeat customers are individually more valuable: an average lifetime value of 308 BRL against 161 BRL for one-time buyers, almost double. But because they are such a small share of the customer base, one-time buyers still account for 94.3% of all revenue in this dataset. This is not evidence of a broken retention program. It is the normal shape of a multi-seller marketplace, where a customer's relationship is mostly with the platform for a single need, not an ongoing relationship with one brand. The practical implication is that the biggest growth lever available here is the efficiency and quality of new customer acquisition and the first purchase experience, since that first purchase is, for 97% of customers, also the only one.

## 3. Does a late delivery actually hurt the review?

Yes, and by a wide margin. Orders delivered after the date Olist itself promised the customer average a 2.57-star review, with 54% of those landing at 1 or 2 stars. Orders delivered on time or early average 4.29 stars, with only 9.2% landing that low. The comparison is measured against each order's own promised delivery date rather than a fixed number of days, which means it isolates the effect of a broken promise specifically, not just a slow shipment on an order that was never promised quickly in the first place.

This is the clearest, largest, most directly actionable relationship found anywhere in this analysis. If Operations can move orders from "late" into "on time," the review-score impact of that single change is larger than any other lever examined in this report.

## 4. Where does the delivery experience break down across Brazil?

Restricted to the 15 states with the highest order volume, average delivery time ranges from 8.7 days in Sao Paulo state, Olist's home base and 42% of all orders in this dataset, up to 23 to 24 days in Para and Maranhao, roughly three times longer. Review scores broadly track this: Sao Paulo's 4.18-star average is among the best in the dataset, while Para (3.84), Maranhao (3.77), Ceara (3.87), and Bahia (3.86) sit at or near the bottom.

This pattern is best explained by Brazil's own size and the concentration of logistics infrastructure around the southeast, rather than by anything Olist is doing differently market to market. It is still a real, measurable gap in the experience a customer in the north of the country gets compared to one in Sao Paulo, and it is useful context for any expansion or logistics investment decision, even though fixing it is a much bigger undertaking than fixing a single broken process.

## 5. Which product categories drive revenue, and where is the quality flag?

Health and beauty is the single largest revenue category in the top 15 (1.24 million BRL) and also reviews well (4.19 stars), so there is no tension there between volume and quality. Bed, bath, and table products generate strong revenue but a comparatively lower 3.92-star average. The one category that stands out as a genuine quality problem is office furniture: solidly ranked by revenue (269,418 BRL, still inside the top 15) but with a clearly lower 3.52-star average than every other category in that group. That gap is large enough, and isolated enough to one category, to be worth a direct look at return rates, product listings, and seller quality specifically within office furniture, rather than treating it as noise.

## 6. What does the AI layer add: does the review text agree with the star rating?

Across the 2,500-review sample, the sentiment model's reading of the text and the customer's actual star rating agree on overall direction, negative, neutral, or positive, 67.8% of the time. That agreement is not even across rating levels. Negative reviews (1 to 2 stars) are the easiest to confirm from the text alone, at 86% agreement. Neutral, 3-star reviews are the hardest, at only 22%, because a 3-star review very often still contains a specific, real complaint even when the overall rating lands in the middle, which pulls the model toward reading the text as more negative than the star rating alone suggests.

The most useful output of this exercise is not the overall accuracy number, it is the specific disagreements. 16.9% of reviews rated 4 or 5 stars contain text the model reads as negative. Some of these are genuine hidden complaints worth surfacing to a category or operations team even though the star rating looks fine on the surface: for example, a review reading "delivery was fast, it just wasn't 100% because the item arrived with a stain," rated highly overall but flagging a real, specific defect a dashboard built only on star ratings would never surface.

It is equally important to be honest about where the model gets it wrong. Several of the "hidden complaint" hits in the sample are simply model errors on short or informal text rather than real hidden complaints, for instance a misspelled but clearly positive "great produdto" scored as negative. The clearest individual failure found was a genuinely negative review, translating to "this is the worst shopping site, deliveries are a mess," which the model scored as 5-star. This has a specific, explainable cause: Olist anonymises its sellers in this public dataset using Game of Thrones house names, and a general-purpose sentiment model has no way to know that a word like a house name refers to a brand it should read as a normal noun rather than, apparently, something it associates with positive connotations. This is a useful, concrete limitation to flag for anyone building on this approach, not a reason to discard the method, since it points directly at how a production version of this analysis should be improved: de-anonymising or masking proper nouns before scoring, and likely fine-tuning on a sample of this platform's own reviews rather than relying on an off-the-shelf model.

## 7. Limitations

Four limitations apply across this analysis. First, only 41% of reviews carry free text, so the AI-augmented findings in section 6 describe that subset of customers who chose to write something, not every customer. Second, the sentiment sample itself is 2,500 of the 40,977 reviews with text, chosen for practicality within this project's time budget rather than the full population, though it was stratified to guarantee every star rating is represented rather than being dominated by the most common ratings. Third, no zip-code-level geolocation table was available for this build, so the geographic analysis in section 4 works at the state level rather than city or delivery-route level, which would allow a sharper read on exactly where within a state the delivery time is being lost. Fourth, all monetary figures are in Brazilian Real and have not been converted to another currency, since the business questions here are about relative comparison across categories, states, and customer types, not absolute value in a specific reader's home currency.

## 8. Conclusion and recommendations

1. **Treat delivery reliability as the single highest-leverage lever on customer satisfaction.** Nothing else examined in this analysis moves the review score anywhere near as much as the gap between a late and an on-time delivery.
2. **Invest in first-purchase experience over loyalty programmes.** With 97% of customers never returning, the highest-value work is making that one purchase go well, not building repeat-purchase incentives few customers will ever use.
3. **Prioritise logistics investment in the states with both high volume and long delivery times** (particularly Bahia, Ceara, and the other northeastern states identified in section 4), where the customer base is large enough to make an improvement worthwhile.
4. **Audit the office furniture category specifically** for return rates, listing quality, and seller performance, given its isolated but real quality gap.
5. **Use AI-based review scoring as a triage signal for hidden complaints in high-star reviews**, not as a replacement for the star rating itself, and plan to mask brand and seller names before scoring in any production version of this approach.

## References

1. Olist, "Brazilian E-Commerce Public Dataset by Olist." [Online]. Available: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
2. NLP Town, "bert-base-multilingual-uncased-sentiment." [Online]. Available: https://huggingface.co/nlptown/bert-base-multilingual-uncased-sentiment
3. F. F. Reichheld, "The One Number You Need to Grow," *Harvard Business Review*, December 2003.
