# Marketing & Website Performance Analysis for Maven Fuzzy Factory

**Prepared for:** CEO, Marketing Director, Website Manager
**Prepared by:** Michael Udousoro, Data Analyst
**Period covered:** March 2012 to March 2015
**Live dashboard:** [Marketing & Funnel Overview, Tableau Public](https://public.tableau.com/app/profile/michael.udousoro/viz/MavenFuzzyFactory-MarketingFunnelAnalysis/MarketingFunnelOverview)

## Executive summary

Maven Fuzzy Factory grew from a single product in March 2012 to a multi
product e-commerce business that has now processed over 32,000 orders. This
report answers five questions the leadership team raised over that time.
Which marketing channels are actually worth the spend. How paid search bids
should be split between desktop and mobile. Where the website loses
potential customers. Whether two website redesigns actually worked. And
what the underlying seasonal and product trends look like.

The short version: the core paid search channel is healthy and earning its
keep. Mobile traffic is being bid on inefficiently. The most expensive point
of customer loss is not where the most people drop off, it is where the
most qualified visitors drop off. Both website tests that were run
succeeded and should stay live. And demand is strongly seasonal around the
holidays, which should shape how budget and stock are planned. Six specific
recommendations follow at the end.

## 1. Data and method

This analysis uses the Maven Fuzzy Factory database: six related tables
covering website sessions, individual pageviews, orders, order line items,
refunds, and the product catalogue. In total that is roughly 472,000
sessions and 32,000 orders. Every query was written and run in SQL against
a MySQL database, checked in Python, and visualised in Tableau. All of the
SQL is saved in the project's `sql/` folder so the analysis can be rerun by
anyone.

Two choices in how this was done matter for reading the results correctly.
First, conversion rates are shown both across all sessions and restricted
to first time sessions only. Returning visitors convert at much higher
rates no matter which channel brought them, so comparing channels without
separating this out gives a misleading picture (more on this in Section 2).
Second, the two website tests covered in Section 4 were not run as
proper concurrent A/B tests. One page simply replaced another over time.
Where the old and new version happened to be live at the same time, that
overlap window is used as the fairer comparison, and it is called out
explicitly.

## 2. Which channels are worth the spend

Paid search drives most of the traffic. Google and Bing search together
make up about 72% of all sessions, and generic (non branded) Google search
alone is 60%. Direct visits and organic search, which cost nothing to
acquire, add another 17.5%. That last figure is a decent proxy for how
strong the brand already is.

At first glance, brand targeted search and direct or organic traffic
convert noticeably better than generic paid search (7.3 to 8.9% versus
6.7 to 7.0%). That comparison is misleading. Between 63 and 64% of sessions
in the better performing groups are returning visitors, and returning
visitors simply buy more often, regardless of channel. Once the comparison
is limited to first time visitors, generic paid search, direct or organic
traffic, and brand search all land within half a percentage point of each
other, somewhere around 6.7 to 6.9%. In other words, for bringing in new
customers, the channel barely matters. What looked like a brand premium
earlier was mostly just a difference in how many returning customers each
channel happened to carry.

One real outlier does show up. A social media campaign called `pilot`
converts at 1.08%, about five times worse than its sibling campaign on the
same platform (5.15%), even with similar traffic volume. Channel choice
does not explain this. Something specific to that campaign, whether it is
targeting, the ad creative, or the landing page, is not working.

## 3. Desktop versus mobile: a bidding problem

Within that dominant search channel, device type produces the biggest gap
found in this whole analysis. Looking at first time visitors only, desktop
sessions convert at 8.22% against mobile's 3.18%. A desktop visitor is
roughly two and a half times more likely to buy than a mobile visitor.
Desktop is 69% of sessions in this channel but 85% of its orders. Mobile is
31% of sessions but only 15% of orders.

Tracking this month by month over the full three years shows both devices
improved steadily as the site itself got better. Desktop conversion rose
from around 4.4% to 10.5%, mobile from around 1.4% to 3.6%. That is a good
sign for the business overall. But the gap between them has not closed for
good. It narrowed during 2013 and 2014 to roughly 2.1 to 2.5 times, then
widened again in early 2015 back to roughly 2.7 to 3.1 times. So the
evidence does not support "mobile will catch up on its own." It supports
treating the gap as a lasting feature of this channel that needs watching.

Since Google Ads and similar platforms allow a separate bid for each
device, this is a straightforward, low risk fix. Right now, money is being
spent on mobile clicks at close to the same rate as desktop clicks, even
though mobile converts at less than half the rate.

## 4. Where the checkout process loses customers

Following every session from the landing page through to an order placed
shows five points where people fall away. Two of those points matter for
different reasons, and it is worth telling them apart.

The biggest loss in raw numbers happens early. Only 55.2% of sessions ever
reach a product page, and of those, only 36.3% add anything to a cart.
Between those two steps alone, roughly 378,000 of the 440,000 sessions that
never convert are lost. Most of this is just normal browsing. Most people
who visit any online shop are not there to buy on the spot. But the scale
of it means even a small improvement here would move the business a lot.

The more worrying finding sits at the bottom of the funnel. Of the sessions
that reach the billing step, only 62.1% go on to place an order. That is a
worse rate than the step before it, where 80.7% of people move from
shipping to billing. And this step loses the most qualified visitors in the
whole funnel: people who have already typed in their shipping details and
are one click from paying. Losing someone that close to buying costs the
business more, per lost session, than losing someone who only glanced at
the homepage.

## 5. Did the two website tests actually work

The site's history shows two deliberate changes: a redesigned checkout page
(`/billing` was replaced by `/billing-2`) and a series of six landing page
versions tested over time. Both were checked directly against the data.

**The billing page redesign clearly worked.** The original page converted
sessions that reached it into orders at 44.8%. The redesign converts at
63.4%. That is an 18.6 percentage point improvement, or about 41% in
relative terms. The two versions were live at the same time for around four
months before the old one was retired, which makes this close to a real
controlled comparison rather than a simple before and after guess. This
directly helps the weak point found in Section 4. The redesign is already
part of the fix for the billing problem, and it should stay as the
standard page.

**One landing page version is a confirmed loser.** Two versions,
`/lander-2` and `/lander-3`, ran at the same time for eighteen months under
the same conditions. `/lander-2` converted at 7.72% against `/lander-3`'s
3.39%, less than half. If `/lander-3` is still getting any traffic, it
should be pulled. The newest version, `/lander-5`, has the highest raw
conversion rate of any landing page (10.17%), but it also ran during the
period when the site's overall conversion rate was already at its best
(see Section 3). So that figure should not yet be taken as proof
that `/lander-5` is genuinely the best design. A fair test would need to
hold the time period steady, which was outside the scope of this analysis.

## 6. Products and seasonality

The original product, The Original Mr. Fuzzy, is still the flagship. It has
generated 23,861 orders and roughly $1.42 million in revenue over the full
period, well ahead of the three products launched later. Most of that gap
comes down to time on the market rather than weaker demand. Each later
product has had less time to build up sales before the data cuts off, and
their monthly order rates, roughly 165 to 205 orders per product per month,
are actually fairly close to each other.

Demand follows a clear, repeating seasonal pattern. Orders rise through the
second half of every year and spike hard in November and December, which
lines up with Black Friday, Cyber Monday, and Christmas gift buying for a
plush toy company. December 2014 was the busiest month in the whole
dataset, with 2,314 orders. This is a structural part of the business, not
a one off. Marketing budget, stock levels, and staffing should be planned
around this pattern rather than spread evenly across the year.

## 7. Limitations

There are four things worth being upfront about. First, the dataset has no
advertising cost or bid data, so the channel and device recommendations
here are based on conversion rate and order volume, not directly on return
on ad spend. Any bidding decision should be checked against real cost
numbers before it goes live. Second, the two website tests in Section 5
were not run as proper randomised experiments. The overlap windows used
here are the fairest comparison available, but other factors could still be
playing a part. Third, the dataset ends partway through March 2015, so that
final month is incomplete and was treated carefully in the seasonality
analysis. Fourth, this report does not include formal statistical
significance testing on the conversion rate differences. The gaps reported
are large enough, and consistent enough across different cuts of the data,
to be treated as reliable directionally, but a follow up analysis with
proper hypothesis testing would strengthen the smaller comparisons, in
particular the short `/lander-4` test and the social media campaign
comparison.

## 8. Recommendations

1. **Cut mobile bids by roughly 50 to 60% on generic Google search**, and check the desktop to mobile ratio again every quarter rather than setting it once. It has moved between 2.1 and 5.5 times over the life of the dataset.
2. **Test brand search spend with a geo holdout.** Many brand search sessions are returning customers who would likely have found the site anyway through direct or organic traffic. Pausing brand bids in a handful of regions and watching total conversions would show the real value being added.
3. **Look into the `socialbook/pilot` campaign**, its landing page and its device mix, before spending more on it. Its conversion rate stands out with no channel level explanation.
4. **Keep the billing page redesign live.** It is a confirmed, solid improvement and needs no further action.
5. **Retire `/lander-3`** if it is still live, and run a proper time controlled comparison before calling `/lander-5` the winning design.
6. **Plan marketing, stock, and staffing around the November to December peak** rather than spreading resources evenly through the year.

## References

1. Maven Analytics, *Advanced SQL: MySQL Data Analysis & Business Intelligence*, Maven Fuzzy Factory database (2012 to 2015 simulated e-commerce dataset).
2. Google Ads Help, "About bid adjustments," Google LLC. Available: https://support.google.com/google-ads/answer/2470096
3. R. Kohavi, D. Tang, and Y. Xu, *Trustworthy Online Controlled Experiments: A Practical Guide to A/B Testing*. Cambridge University Press, 2020.
