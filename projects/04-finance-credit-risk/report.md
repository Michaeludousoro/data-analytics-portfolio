# Credit Risk: Setting a Smarter Approval Cutoff

**Prepared for:** Consumer Lending Risk and Underwriting Leadership
**Prepared by:** Michael Udousoro, Data Analyst
**Data:** Give Me Some Credit, 150,000 borrowers

## A note on the data

This project was originally planned around Kaggle's American Express Default Prediction
competition. That dataset is 16 to 50GB across its files and sits behind Kaggle's competition
rules, which need a logged in account to accept, so there was no way to download it here. In its
place, this report uses Give Me Some Credit, a smaller and older Kaggle credit risk dataset with
150,000 borrowers and 10 features that are all in plain, human readable terms, things like age,
monthly income, and how many times someone has been late on a payment, rather than American
Express's roughly 190 anonymised columns. The business question this report answers is the one
originally planned: can a lender reduce default losses without rejecting too many borrowers who
would have repaid.

## Executive summary

This report builds a simple, explainable credit risk score from a borrower's application data,
then uses it to answer the question that actually matters to a lending business: where should the
approval cutoff sit. Two things stand out. First, a borrower's own payment behaviour, specifically
how much of their available credit they are using and whether they have been seriously late
before, predicts future default far better than their income does. Second, and more importantly
for decision making, the "right" cutoff is not a statistical question but a financial one: it
depends entirely on what a default costs the lender against what a good borrower is worth, and
this report prices that trade-off directly rather than optimising an abstract accuracy number.
Under illustrative cost assumptions, a 10% risk cutoff catches close to two-thirds of defaults
while rejecting only about one in eight good borrowers, and is worth roughly $3.2 million more
than approving everyone, on a 45,000-borrower test set.

## 1. Introduction

Every lender making unsecured credit decisions faces the same trade-off: reject too few
borrowers and losses from default eat into or erase the portfolio's profit; reject too many and
the business turns away customers who would have paid on time and been profitable. Getting this
right needs two separate things done well. First, a way to separate risky borrowers from safe
ones using only information available at the time of application. Second, and less often done
carefully, a clear-eyed decision about where to draw the approval line once that separation
exists, because the model's job stops at producing a risk score, and a human or a policy still
has to turn that score into an approve or decline decision.

This report does both. It builds a logistic regression risk score from ten application-level
features, checks that it actually separates risky from safe borrowers well, then treats the
cutoff choice as what it is: a financial decision that trades the cost of a missed default
against the cost of a lost good customer, made explicit with a small Excel model so the two key
assumptions behind it can be changed by anyone reviewing this work.

## 2. Data and method

The data covers 150,000 borrowers, one row per borrower, with a target flag for whether that
borrower had a serious delinquency, 90 or more days past due, within two years of the record
being taken. 10,026 borrowers, 6.68%, had one. Ten features were used: revolving credit
utilization, age, three separate late payment history counts (30 to 59 days, 60 to 89 days, and
90 or more days late), debt ratio, monthly income, number of open credit lines, number of real
estate loans, and number of dependents.

Four data quality issues were found and handled before modelling, all documented and checked in
[`sql/02_data_quality_issues.sql`](sql/02_data_quality_issues.sql). One borrower is recorded as
age 0. 269 borrowers show a 96 or 98 against a late payment count, a known data entry pattern in
this dataset rather than a real count. 371 borrowers show revolving utilization above 200% of
their credit limit, up to a maximum of 50,708, and 28,877 show a debt ratio above 10, up to a
maximum of 329,664, both implausible as real ratios. Rather than dropping these borrowers
outright, extreme values were capped at a sensible maximum, keeping every borrower in the
analysis while stopping a handful of data entry errors from dominating the model. Monthly income
was missing for about 20% of borrowers and dependents for about 2.6%; both were checked for
whether the missingness itself carried a risk signal (it did not, see section 5) before being
filled with the median value.

The data was loaded into a local DuckDB file and explored in SQL first; every query is saved in
the project's `sql` folder in the order it was written. The risk score itself, a logistic
regression, was built in Python with scikit-learn, trained on 70% of the cleaned data and
evaluated on the remaining 30% (45,000 borrowers) that the model never saw during training.

## 3. What actually predicts a serious delinquency?

Two features stand out clearly above the rest. Late payment history is the single strongest
predictor: borrowers with no 90 or more day late payment on record default 4.63% of the time.
A single such late payment already raises that to 33.66%, roughly seven times higher, and two or
more pushes it past 50%. This is a large, clean, and intuitive pattern: past serious delinquency
is the best available signal for future serious delinquency.

Revolving credit utilization, how much of a borrower's available credit limit is currently in
use, is nearly as strong. Borrowers using under 10% of their limit default 1.81% of the time.
That climbs steadily through the bands, reaching 16.50% at 60 to 100% utilization and 40.01% for
anyone already over their limit, roughly 22 times the lowest band. A borrower who is maxed out is,
on this data, a fundamentally different risk than one comfortably under their limit, well before
any late payment shows up on their record.

Age has a milder but still real relationship: default rates fall fairly steadily from 11.73%
under 30 to 2.32% at 70 and over, most plausibly an income-and-tenure effect rather than
something a lender should act on directly given fair lending considerations around age as a
factor.

## 4. Building and checking the risk score

A logistic regression was chosen deliberately over a more complex model. A lending business
needs to be able to explain to a borrower, a regulator, or its own risk committee why a given
application was declined, and a logistic regression's coefficients translate directly into "this
factor raised or lowered the score by this much" in a way that a more opaque model does not offer
without extra work. Trained on the eleven cleaned features (the ten original features plus a flag
for missing income), the model reaches an AUC of 0.85 on the 45,000-borrower held-out test set.
That means: given one random borrower who defaulted and one random borrower who did not, the
model correctly scores the defaulter as riskier 85% of the time. That is a strong result for a
model built from ten fairly simple, human-readable features, and it is well within the range
needed to make a cutoff-based decision meaningfully better than approving everyone or nobody.

Looking at which features actually drive the score confirms the pattern from section 3.
Revolving utilization has by far the largest coefficient, followed by the three late payment
history features in order of severity. Age and debt ratio pull the score down slightly for older,
lower-ratio borrowers. Monthly income and number of dependents have almost no independent effect
once utilization and payment history are already in the model, a genuinely useful finding on its
own: income alone is a weak predictor of default, behaviour is a strong one, which argues against
leaning too heavily on income verification alone in an underwriting process.

## 5. Is missing income itself a warning sign?

Before simply filling in missing income values and moving on, it is worth checking whether the
absence of that value means something. It does not, at least not in the direction someone might
expect: borrowers with no income recorded actually default slightly less often, 5.61%, than
borrowers who did report their income, 6.95%. That rules out the concern that a missing income
field is quietly flagging something to hide, and justifies treating it as an ordinary missing
value, filled with the median and given its own flag column so the model can still use the fact
that it was missing if that combination with other features turns out to matter.

## 6. Where should the cutoff sit?

A risk score is not, on its own, a decision. Somewhere a line has to be drawn: reject anyone
scored above it, approve everyone else. Moving that line down catches more defaults but rejects
more good borrowers along with them; moving it up does the reverse. The right place for that line
depends entirely on what those two outcomes are actually worth to the lender, so this report
prices the trade-off directly using two illustrative assumptions: an average profit of $300 per
good approved borrower over the life of the credit line, and an average loss of $2,500 per
borrower who is approved and then seriously defaults. These two numbers are not sourced from a
real lender's books, they are the kind of figures a credit risk team would supply from its own
portfolio data, and they are kept isolated in one place, both in this report and in an
accompanying Excel workbook, specifically so they can be replaced without redoing any of the
underlying analysis.

Under those assumptions, the best cutoff on the 45,000-borrower test set is 10%: reject anyone
the model scores at 10% risk or higher. That single rule catches 63.9% of the defaults that would
otherwise have been approved, while rejecting only 12.4% of the borrowers who would actually have
repaid, and raises the portfolio's net value by roughly $3.2 million compared with approving
everyone, no model at all. The shape of the trade-off is worth stating plainly too: a much more
aggressive 2% cutoff catches nearly every default, 97.2%, but rejects 69.4% of good borrowers
doing so, and this destroys more value than it protects, because so many profitable borrowers are
turned away to stop a comparatively smaller amount of loss. The lesson is not "reject more
aggressively is always safer," it is that the cutoff sits at the point where the marginal defaults
still being caught are worth more than the marginal good borrowers still being rejected, and past
that point it stops paying for itself.

The accompanying Excel workbook, [`outputs/dashboards/cutoff_scenario_model.xlsx`](outputs/dashboards/cutoff_scenario_model.xlsx),
reproduces this table with the two dollar assumptions as live, editable cells, so a risk or
finance team can substitute their own numbers and see the recommended cutoff and portfolio value
recalculate immediately, without needing to touch the Python model.

## 7. Limitations

Several limitations should shape how this analysis is used. The two dollar assumptions behind
the recommended cutoff are illustrative rather than sourced from a real lender's actual unit
economics, so the exact number, 10%, should be treated as an example of the method, not a number
to adopt directly; the Excel model exists to make replacing those two assumptions straightforward.
The model itself is a single logistic regression trained on one static snapshot of 150,000
borrowers with no macroeconomic context and no ability to adapt over time, so it represents a
first, explainable pass at the underwriting problem rather than a production-ready system, and
any real deployment would need retraining, monitoring, and revalidation on an ongoing basis. The
handful of data entry errors identified in section 2, capped rather than removed, reflects a
judgement call made to preserve every borrower in the analysis, not a neutral or unique correct
choice, and a different analyst might reasonably choose differently. Finally, and most
importantly for anything beyond this exploratory analysis, no fair lending or disparate impact
review has been carried out on this model or its features; that kind of review, checking whether
the model produces unequal outcomes across protected groups either directly or through a proxy
variable, is a standard and necessary step before any credit model like this could be considered
for real use, and nothing in this report should be read as a substitute for it.

## 8. Conclusion and recommendations

1. **Prioritise payment behaviour over income verification in underwriting.** Utilization and
   late payment history predict default far better than income does in this data; income alone
   adds little once behaviour is accounted for.
2. **Treat the approval cutoff as a financial decision, not a fixed rule**, and revisit it
   whenever the underlying cost of a default or the value of a good customer changes materially.
3. **Replace the two illustrative dollar assumptions in the Excel model with real portfolio
   figures** before treating any specific cutoff number as a recommendation to act on.
4. **Commission a fair lending and disparate impact review** before this or any similar model is
   considered for real underwriting use, covering both direct features and any proxy risk.
5. **Treat this model as a first pass, not a finished system.** A production deployment would
   need retraining on a rolling basis, live monitoring for drift, and validation against more
   recent data than this one static snapshot provides.

## References

1. Kaggle, "Give Me Some Credit." Available: https://www.kaggle.com/c/GiveMeSomeCredit
2. Consumer Financial Protection Bureau, "Fair Lending Report." Available: https://www.consumerfinance.gov/about-us/newsroom/
3. scikit-learn documentation, "Logistic Regression." Available: https://scikit-learn.org/stable/modules/linear_model.html#logistic-regression
