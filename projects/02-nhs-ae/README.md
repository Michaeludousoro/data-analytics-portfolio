# Project 2: NHS A&E Performance, National Trend and Trust Benchmarking

> **Status:** complete. SQL analysis, notebook, README, full report, and a live dashboard are all finished.
>
> **A note on the dashboard tool:** this was originally planned as a Power BI dashboard. Power BI Desktop only runs on Windows, and Power BI's web service needs a work or school Microsoft account rather than a personal one, so neither was usable on this Mac without a heavy Windows-VM setup. Built in Tableau instead, same tool as the TfL project.

**Full report:** [report.md](report.md) is the written analysis.
**Live dashboard:** [NHS A&E Performance - National Trend and Trust Benchmarking](https://public.tableau.com/app/profile/michael.udousoro/viz/NHSAEPerformance-NationalTrendandTrustBenchmarking/NHSAEPerformance) on Tableau Public.

## The scenario

NHS England publishes A&E performance data for every trust in the country every month. This project analyses a full year of that real, current data (April 2025 to March 2026) to answer the question a health service performance team would actually ask: what is driving 4-hour target breaches, and which trusts are the clearest outliers, best and worst.

## The business questions

| Theme | Question |
|-------|----------|
| National trend | How has 4-hour performance moved over the last 12 months, and is there a seasonal pattern? |
| Trust benchmarking | Which trusts are the clearest outliers on Type 1 (major A&E) performance? |
| Regional gaps | Does the most severe measure, 12+ hour waits, vary by region? |
| Size and performance | Do busier trusts perform worse, or is that not actually true? |

## Data

- **Source:** NHS England's public provider-level A&E statistics, published monthly.
- **Window:** April 2025 to March 2026, 12 months, the most recent full year available at build time.
- **Shape:** 205 distinct trusts and providers, 2,386 provider-month rows, 26.97 million attendances.
- Setup and source URLs: see [`sql/00_setup.md`](sql/00_setup.md).

## Findings

**National performance has sat well below the NHS's own standard all year, and moves with the season.** 4-hour performance ranged from 71.8% to 76.6% across the 12 months, far short of the 95% standard every single month. October through January is clearly the worst stretch, and January 2026 was the low point: 71.8% performance and 71,517 attendances waiting 12 or more hours, more than double July's figure. This is winter pressure showing up with an actual scale attached, not just a seasonal comment.

**The best-performing trusts by Type 1 percentage are children's hospitals, which is a real confound, not a best-practice story.** Sheffield Children's (92.4%) and Alder Hey Children's (85.2%) top the list, but a specialist children's A&E sees a different, generally less complex case mix than a general adult hospital, so this isn't directly replicable. Excluding those two, Calderdale and Huddersfield leads general trusts at 83.4%. The worst general trusts sit in the low-to-mid 50s percent, a genuine 20 to 25 point gap from the best general performers on the same national standard.

**The most severe measure, 12+ hour waits, varies about three times over by region.** North East and Yorkshire has the fewest severe breaches relative to volume (10.27 per 1,000 attendances); North West has the most (31.47 per 1,000). This is the measure most likely to reflect real patient harm, not the more forgiving 4-hour target.

**Trust size barely explains performance.** The correlation between average monthly Type 1 volume and 4-hour performance across 124 trusts is 0.07, essentially no linear relationship. A handful of the very largest trusts do skew toward below-average performance by eye, but that doesn't hold as a general pattern once the full range of trust sizes is considered. This argues against "big trusts are struggling because they're big" as an explanation, and toward something more trust-specific, staffing, local demand, bed and discharge flow, being the more useful place to look.

## Limitations

- Type 1 performance benchmarking is restricted to trusts with at least 12,000 Type 1 attendances a year, to avoid comparing a walk-in minor injuries unit against a major trauma centre; smaller providers are not represented in the trust ranking.
- The 12-month window (April 2025 to March 2026) covers one winter cycle. Confirming the seasonal pattern is structural, not a one-off, would need multiple years of the same provider-level data.
- This analysis identifies which trusts and regions are outliers, not why. Staffing levels, bed occupancy, social care discharge delays, and local population health are all plausible drivers not present in this dataset.
- The children's-hospital confound noted in the findings is a reminder that comparing trusts by a single metric always needs a case-mix check before drawing a "best practice" conclusion.

## Repro

```bash
# from the repo root
uv run jupyter lab   # notebooks/01_ae_performance_analysis.ipynb has the full analysis
# SQL lives in sql/, runs directly against the DuckDB file in data/processed/
```
