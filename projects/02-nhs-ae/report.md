# NHS A&E Performance: National Trend and Trust Benchmarking

**Prepared for:** NHS England Performance and Operations Leadership
**Prepared by:** Michael Udousoro, Data Analyst
**Period covered:** April 2025 to March 2026

## Executive summary

This report analyses a full year of NHS England's own published A&E performance data, at the level of individual trusts, to answer four questions. How has national 4-hour performance moved over the year, and does it follow a seasonal pattern. Which trusts are the clearest outliers on Type 1 major A&E performance, best and worst. Does the most severe measure, patients waiting 12 or more hours, vary by region. And does trust size explain performance, or is that assumption wrong.

The short version: national performance has run 20 or more percentage points below the NHS's own 95% standard every month of the year, and moves clearly with the season, bottoming out in January 2026. The apparent best performers on a simple Type 1 ranking are children's hospitals, a genuine case-mix confound rather than a transferable best practice. The most severe waits, 12 hours or more, vary about three times over between the best and worst NHS England regions. And trust size, despite being an intuitive explanation, barely predicts performance at all once the full range of trusts is considered, which points attention toward trust-specific operational factors rather than scale itself.

## 1. Introduction

A&E performance against the 4-hour standard is one of the most closely watched measures in the NHS, reported monthly, debated in Parliament, and directly tied to patient experience and, at the most severe end, patient safety. This report works from the same provider-level data NHS England itself publishes every month, at the granularity of individual trusts rather than only the national headline figure, because the national figure alone cannot answer where the pressure is concentrated or whether it's explained by anything as simple as trust size.

Four questions guide the analysis, each chosen because it maps to a real decision a performance or operations team would need to make: whether the current pressure is a seasonal pattern requiring seasonal planning, which specific trusts most need support or most have something to teach others, whether regional resourcing gaps show up in the most severe outcome measure, and whether "bigger trusts struggle more" is actually true or just an intuitive assumption worth checking against the data.

## 2. Data and method

The analysis uses NHS England's provider-level A&E statistics, published as a CSV file every month with one row per trust or independent sector provider. Twelve consecutive months were used, April 2025 through March 2026, the most recent full year available at the time of this analysis, covering 205 distinct providers and 26.97 million total attendances. Each monthly file also includes an embedded national summary row labelled "TOTAL"; this was identified and excluded from every provider-level calculation in this report, so every figure here is built directly from the individual trust rows rather than taken from NHS England's own pre-aggregated total.

One structural fact about the data shapes how trust comparisons in this report were done. A "Type 1" department is a major, consultant-led A&E handling the most acute and complex cases. Many smaller providers run only a Type 3 minor injuries unit or urgent treatment centre, with no Type 1 department at all. Comparing 4-hour performance across every provider without accounting for this would put a walk-in minor injuries unit, which handles simpler cases by design, on the same league table as a major trauma centre. Section 4's trust benchmarking is therefore restricted to Type 1 performance specifically, and only for trusts with at least 12,000 Type 1 attendances across the year, roughly 1,000 a month, to ensure a genuinely active Type 1 department is being measured.

The data was loaded into a local DuckDB file directly from the raw CSVs and queried in SQL. Every query is saved in the project's `sql` folder in the order it was written.

## 3. How has national performance moved, and is it seasonal?

National 4-hour performance, calculated across all attendance types, ranged from 71.8% to 76.6% over the 12 months, never once approaching the NHS's own 95% standard. The pattern across the year is not flat. Performance holds in the mid-70s percent through spring and summer, then declines steadily from October, reaching its lowest point in January 2026 at 71.8%. The 12-hour breach count, the most severe wait measure tracked, moves even more sharply with the same pattern: from a low of roughly 35,000 in July 2025 to 71,517 in January 2026, more than double.

This is not a new observation in general terms, NHS commentary routinely discusses "winter pressure," but this analysis attaches an actual, current scale to it using the most recent full winter cycle available. A performance team using this finding should treat capacity and staffing planning for October through January as a distinct operational period, not an extension of the rest of the year's normal running.

## 4. Which trusts are the clearest outliers?

Ranking trusts with a meaningfully active Type 1 department by the percentage of Type 1 attendances seen within 4 hours produces a genuine surprise at the top. The two best performers, Sheffield Children's NHS Foundation Trust (92.4%) and Alder Hey Children's NHS Foundation Trust (85.2%), are both specialist children's hospitals. This is worth stating plainly rather than treating as a straightforward "best practice" finding: paediatric A&E departments generally see a different, on average less complex, case mix than adult general hospitals, and a general trust cannot simply copy what a children's hospital does and expect the same result. Excluding those two, the genuine top performer among general acute trusts is Calderdale and Huddersfield NHS Foundation Trust at 83.4%.

At the other end, the worst-performing general trusts cluster in the low-to-mid 50s percent, a gap of roughly 20 to 25 percentage points from the best general performers, measured against the exact same national standard over the exact same 12 months. That gap is large enough, and consistent enough across a full year rather than one unusual month, to be a genuine signal worth investigating trust by trust, not noise.

## 5. Does the most severe measure vary by region?

Grouping every trust by its NHS England region and looking specifically at 12+ hour breaches per 1,000 attendances, rather than the more forgiving 4-hour measure, shows a roughly three-times gap between the best and worst regions. North East and Yorkshire records the fewest severe breaches relative to its volume, 10.27 per 1,000 attendances. North West records the most, 31.47 per 1,000. London, the Midlands, and the South East sit in between, each in the high teens to low twenties.

This finding matters specifically because it uses the 12-hour measure rather than the 4-hour one. A 4-hour breach is a missed target; a 12+ hour wait, particularly from a decision to admit, is widely treated within the NHS as a genuine patient safety concern, and is the measure most likely to reflect real harm rather than administrative pressure alone. A three-times regional gap on that specific measure is a stronger and more urgent finding than the same gap would be on the 4-hour figure.

## 6. Does trust size explain performance?

A natural hypothesis is that busier trusts simply get overwhelmed and perform worse. Plotting each trust's average monthly Type 1 attendance volume against its percentage seen within 4 hours, across the 124 trusts with a meaningful Type 1 department, produces a correlation of 0.07, which is, in practical terms, no linear relationship at all.

Looking only at the handful of very largest trusts by volume does suggest a pattern: several of the biggest trusts in the country, including some of England's largest teaching hospital trusts, sit noticeably below the national average on 4-hour performance. But this pattern does not hold once the full range of trust sizes is considered. Several mid-sized and even some large trusts perform well above average, and several smaller trusts perform below it. The overall correlation being close to zero means trust size is not, by itself, a reliable predictor of performance.

The practical implication is that "our trust is struggling because it's big" is not a safe assumption to act on. Whatever is actually driving performance differences between trusts, most plausibly staffing levels, bed occupancy and discharge flow, local population health need, and social care availability, none of which are present in this dataset, is more trust-specific than a simple function of size, and that is where investigation should focus next rather than on scale itself.

## 7. Limitations

Four limitations apply to this analysis. First, the Type 1 trust benchmarking in section 4 is restricted to providers with at least 12,000 annual Type 1 attendances, so smaller providers and those running only Type 2 or Type 3 departments are not represented in that specific ranking, though they are included in the national totals in sections 3 and 5. Second, the 12-month window covers exactly one winter cycle; confirming that the seasonal pattern in section 3 is a structural, repeating feature rather than a one-off would need several years of the same data. Third, this analysis identifies which trusts and regions are statistical outliers, not why they are outliers. Staffing levels, bed occupancy, discharge delays into social care, and local demand patterns are all plausible explanations not available in this dataset, and any of the findings here should be treated as the starting point for investigation, not the end of it. Fourth, the children's-hospital finding in section 4 is a useful general reminder: any league table built from a single metric needs a case-mix check before a "best practice" conclusion is drawn from it, and this dataset does not include the additional clinical or demographic detail that a full case-mix adjustment would require.

## 8. Conclusion and recommendations

1. **Treat October through January as a distinct operational period for capacity and staffing planning**, not a continuation of the rest of the year, given the clear and substantial seasonal decline in performance culminating in January.
2. **Investigate Calderdale and Huddersfield's operating model directly**, as the genuine top performer among general acute trusts, rather than looking to the children's hospitals at the top of the raw ranking.
3. **Prioritise the North West and Midlands regions for 12-hour breach reduction work specifically**, given they carry the most severe end of the problem at roughly three times the rate of the best-performing region.
4. **Do not treat trust size as an explanation for poor performance**, and redirect root-cause investigation toward staffing, bed occupancy, and discharge flow at the specific trusts identified as outliers in section 4.
5. **Extend this analysis with case-mix, staffing, and bed occupancy data** to move from identifying outlier trusts to explaining what is actually driving the gap between them.

## References

1. NHS England, "A&E Attendances and Emergency Admissions." Available: https://www.england.nhs.uk/statistics/statistical-work-areas/ae-waiting-times-and-activity/
2. NHS England, "Winter Situation Reports." Available: https://www.england.nhs.uk/statistics/statistical-work-areas/winter-daily-sitreps/
3. The King's Fund, "Urgent and Emergency Care Statistics Explained." Available: https://www.kingsfund.org.uk
