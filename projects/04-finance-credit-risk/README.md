# Project 4: Credit Risk, Setting a Smarter Approval Cutoff

> **Status:** complete. SQL analysis, notebook, scorecard model, Excel scenario model, README, full report, and a live dashboard are all finished.
>
> **A note on the dashboard tool:** this was originally planned as a Power BI dashboard. Power BI Desktop only runs on Windows, and its web service needs a work or school Microsoft account rather than a personal one. I set up a Windows 11 virtual machine through Parallels (which worked well) and installed Power BI Desktop there, but ran into keyboard input issues that made it impractical to work in reliably. I built the dashboard in Tableau instead, the same tool I used for the TfL and NHS projects, which also keeps the dashboards consistent across the portfolio.

**Full report:** [report.md](report.md) is the written analysis.
**Live dashboard:** [Credit Risk - Cutoff Analysis](https://public.tableau.com/app/profile/michael.udousoro/viz/CreditRisk-CutoffAnalysis/CreditRiskCutoffAnalysis) on Tableau Public.

## A note on the data

This project was originally planned around Kaggle's American Express Default Prediction
competition. That dataset turned out to be 16 to 50GB and gated behind Kaggle competition rules
that need a logged in account, so it could not be used here. It was swapped for **Give Me Some
Credit**, a smaller, older Kaggle credit risk dataset with 150,000 borrowers and features that
are all human readable, rather than American Express's roughly 190 anonymised columns. The
business question is unchanged. See [`sql/00_setup.md`](sql/00_setup.md) for the full
explanation.

## The scenario

A lender wants to approve borrowers who will repay and decline borrowers who will seriously
default, using only information available at the time of application. This project builds a
simple, explainable risk score from a borrower's credit history, then answers the real business
question underneath that: where should the approval cutoff sit, given that being too strict
loses good, profitable customers and being too lax loses money to defaults.

## The business questions

| Theme | Question |
|-------|----------|
| Risk drivers | Which factors actually predict a serious delinquency? |
| Scoring | Can a simple, explainable model separate risky from safe borrowers? |
| Cutoff | Where should the approval line sit, and what does moving it cost or save? |
| Data quality | Are there data entry errors that would distort the picture if left in? |

## Data

- **Source:** Give Me Some Credit (originally a Kaggle competition), 150,000 borrowers.
- **Target:** whether the borrower had a serious delinquency within two years.
- **Features:** revolving credit utilization, age, late payment history, debt ratio, monthly
  income, open credit lines, real estate loans, and dependents.
- Setup and source details: see [`sql/00_setup.md`](sql/00_setup.md).

## Findings

**Late payment history is the strongest signal in the data.** Borrowers with no 90+ day late
payment on record default 4.63% of the time. A single such late payment raises that to 33.66%,
roughly seven times higher. Two or more push it past 50%.

**Credit utilization is nearly as strong.** Borrowers using under 10% of their available
revolving credit default 1.81% of the time. That rises to 16.50% at 60 to 100% utilization and
40.01% for anyone already over their limit, about 22 times higher than the lowest band.

**A simple, explainable logistic regression scores borrowers well.** Trained on 11 features, the
model reaches an AUC of 0.85 on held-out data, meaning it correctly ranks a random defaulter as
riskier than a random non-defaulter 85% of the time. Utilization and late payment history drive
the score by far; income and dependents matter little once behaviour is already accounted for.

**The right approval cutoff is a dollar question, not a statistics question.** Under illustrative
cost assumptions ($300 average profit per good approved borrower, $2,500 average loss per
default), rejecting anyone scored at 10% risk or higher catches 63.9% of defaults while only
turning away 12.4% of good borrowers, and lifts portfolio value by about $3.2 million on a
45,000-borrower test set compared with approving everyone. Being far more aggressive, a 2%
cutoff, catches 97.2% of defaults but rejects 69.4% of good borrowers along with them and
actually destroys more value than it saves. An [Excel scenario model](outputs/dashboards/cutoff_scenario_model.xlsx)
lets those two dollar assumptions be changed live to see how the recommended cutoff shifts.

**Missing income is not itself a risk signal.** Borrowers with no income recorded default
slightly less often (5.61%) than borrowers with income recorded (6.95%), ruling out the concern
that a missing value is hiding something.

## Limitations

- The two dollar assumptions behind the cutoff recommendation, profit per good borrower and loss
  per default, are illustrative, not sourced from a real lender's books. The Excel model exists
  specifically so those two numbers can be replaced with real ones.
- This is a single logistic regression trained on one static snapshot of 150,000 borrowers, with
  no macroeconomic context and no monitoring over time; it is a first, explainable pass at the
  problem, not a production-ready underwriting model.
- A handful of data entry errors (a borrower recorded as age 0, late payment counts of 96 or 98,
  utilization and debt ratios in the thousands) were capped rather than deleted so no borrower
  was dropped from the analysis, but this is a judgement call, not a neutral one.
- No fair lending or disparate impact review has been done on this model, something a real
  deployment would require before going anywhere near production.

## Repro

```bash
# from the repo root
uv run jupyter lab   # notebooks/01_credit_risk_scorecard.ipynb has the full analysis
# SQL lives in sql/, runs directly against the DuckDB file in data/processed/
```
