# Project 1: Santander Cycles Demand and Rebalancing Analysis

> **Status:** complete. SQL analysis, notebook, README, full report, and a live Tableau dashboard are all finished.

**Full report:** [report.md](report.md) is the written analysis.
**Live dashboard:** [TfL Cycling - Demand and Rebalancing Analysis](https://public.tableau.com/app/profile/michael.udousoro/viz/TfLCycling-DemandandRebalancingAnalysis/Dashboard1) on Tableau Public.

## The scenario

Santander Cycles is London's public bike share scheme, run by TfL. A rebalancing team has to physically move bikes between stations every day, since riders don't naturally return bikes to where they're needed. This project analyses 1.67 million real trips from April and May 2026 to answer the question a TfL network planning team would actually ask: where is demand most imbalanced, and how should bikes be rebalanced.

## The business questions

| Theme | Question |
|-------|----------|
| Demand pattern | When does demand actually happen, by hour of day and day of week? |
| Station imbalance | Which stations chronically fill up or drain out, and need active rebalancing? |
| Network load | Which stations carry the most overall traffic? |
| Fleet mix | Are e-bikes used differently from classic bikes, and what does that mean for fleet placement? |

## Data

- **Source:** TfL's public cycle hire usage data, published at `cycling.data.tfl.gov.uk`.
- **Window:** 1 April to 31 May 2026 (two months), the most recent data available at build time. TfL's archive runs back to 2012, but a full multi-year download is tens of gigabytes and not needed to answer these questions. See [`sql/00_setup.md`](sql/00_setup.md) for the reasoning.
- **Shape:** 1,665,849 trips, 803 stations, over 12,000 individual bikes.
- Loaded into a local DuckDB file, no server needed.

## Findings

**Demand follows a textbook commute pattern on weekdays**, with sharp peaks at 8am and 5 to 6pm (the evening peak is the larger of the two), and a single broad midday hump on weekends that looks like leisure riding rather than commuting. Any rebalancing schedule has to treat weekdays and weekends as genuinely different operating patterns.

**Station imbalance follows the commute, not chance.** Stations that fill up with bikes over the day are almost all in the City of London financial district (Bank, Liverpool Street, Moorgate, Holborn, Monument), where people ride in for work in the morning and don't ride back out until evening. Stations that drain of bikes are major rail termini and park or leisure areas (both Waterloo Station docks, Hyde Park Corner, Knightsbridge, Lancaster Gate), where people arrive by train or on foot and take a bike onward, with nothing coming back to replace it.

**The busiest stations and the most imbalanced stations substantially overlap.** Hyde Park Corner and the Waterloo docks lead the network in raw traffic and also sit among the most imbalanced stations, meaning the absolute number of bikes that need moving there each day is large, not just the percentage.

**E-bikes, already 19% of trips, are used differently from classic bikes.** They average a longer trip and are used for a round trip (same start and end station, typical of a leisure loop) less than half as often as classic bikes, 1.9% versus 3.2%. This points to e-bikes doing more genuine point-to-point commuting, which is useful for deciding where to prioritise e-bike availability.

## Limitations

- The two-month window (April to May 2026) captures spring conditions only. A full year would be needed to confirm whether the commute pattern and station imbalance hold through winter weather and summer tourist season, when leisure riding is likely to shift the balance further.
- Station-level net flow is measured over the whole window, not hour by hour, so it identifies which stations need daily rebalancing overall, not the exact time of day a van should arrive. Section 2's hourly pattern is the input a real schedule would combine this with.
- No weather or event data (planned as part of the original scope) is included in this build; a delay or a major event in central London would show up in the data as an unexplained demand spike without weather context to explain it.

## Repro

```bash
# from the repo root
uv run jupyter lab   # notebooks/01_demand_and_rebalancing.ipynb has the full analysis
# SQL lives in sql/, runs directly against the DuckDB file in data/processed/
```
