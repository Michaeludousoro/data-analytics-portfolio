# Setup and data source

## A note on the dataset

This project was originally planned around Kaggle's American Express Default
Prediction competition dataset. That dataset turned out not to be usable
here: it is 16 to 50GB across its files, and it sits behind Kaggle's
competition rules, which need a logged in account to accept, so there is no
way to script the download.

Instead this project uses **Give Me Some Credit**, a smaller and older
Kaggle dataset (also a credit risk problem, also originally a Kaggle
competition) with about 150,000 borrowers and 10 features that are all
human readable, things like age, monthly income, and how many times someone
has been 30 to 59 days late on a payment. American Express's dataset has
around 190 anonymised columns, so honestly, this dataset makes for a better
portfolio piece anyway: every finding below can be explained in plain
English rather than "feature 47 was important."

The business question is unchanged from the original plan: can a lender
cut default losses without rejecting too many good borrowers.

- **Source:** Give Me Some Credit, originally a Kaggle competition, mirrored on GitHub at
  `github.com/JLZml/Credit-Scoring-Data-Sets` (folder `3. Kaggle/Give Me Some Credit`).
- **File used:** `cs-training.csv`, 150,000 rows, one row per borrower.
- **Target:** `SeriousDlqin2yrs`, whether the borrower had a serious
  delinquency (90+ days past due, or worse) in the two years after the
  record was taken.

## Loading the data

The raw CSV is loaded into a local DuckDB file with column names cleaned up
to plain snake_case, and the two numeric columns that came in as text
because of `NA` values (`MonthlyIncome`, `NumberOfDependents`) cast back to
numbers:

```python
import duckdb

con = duckdb.connect("data/processed/credit_risk.duckdb")
con.execute("""
    CREATE OR REPLACE TABLE borrowers AS
    SELECT
        column00 AS borrower_id,
        seriousdlqin2yrs AS serious_delinquency,
        revolvingutilizationofunsecuredlines AS revolving_utilization,
        age,
        numberoftime3059dayspastduenotworse AS late_30_59_days,
        debtratio AS debt_ratio,
        TRY_CAST(monthlyincome AS DOUBLE) AS monthly_income,
        numberofopencreditlinesandloans AS open_credit_lines,
        numberoftimes90dayslate AS late_90_plus_days,
        numberrealestateloansorlines AS real_estate_loans,
        numberoftime6089dayspastduenotworse AS late_60_89_days,
        TRY_CAST(numberofdependents AS DOUBLE) AS dependents
    FROM read_csv_auto('data/raw/cs-training.csv', header=true, normalize_names=true)
""")
```

Result: 150,000 borrowers, 10,026 of them (6.68%) had a serious
delinquency. Every SQL file in this folder runs against this table.
