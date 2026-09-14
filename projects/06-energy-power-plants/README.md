# Project 6: Global Power Plants, Energy Transition Analytics

> **Status:** complete. Data cleaning, three research questions, visualizations, notebook, and the full report are all finished. A Tableau/Power BI dashboard is still to come (we build those together, live).

**Full report:** [report.md](report.md) is the full written analysis (methodology, findings, limitations, references).

## The scenario

Governments, utilities, and investors all make decisions that depend on how fast the world is actually shifting away from fossil fuel electricity generation, and where that shift is happening. This project analyses the World Resources Institute's Global Power Plant Database, about 28,700 power plants in 164 countries, covering roughly 80% of the world's generation capacity, to answer that question directly from the data rather than from headlines.

This project started life as a university assignment I completed while studying. It's rebuilt here from scratch, independently, to a higher standard and with my own research questions, as a genuine portfolio piece rather than a resubmission of that coursework.

## The research questions

| # | Question | Why it matters |
|---|---|---|
| 1 | Which countries are furthest along the renewable transition, and which are furthest behind? | Determines exposure to fossil fuel price shocks and progress toward climate commitments |
| 2 | What does the age profile of the fossil fleet say about the scale of replacement needed to meet climate targets? | Power plants run for decades; fleet age drives how large a retirement/replacement programme is coming |
| 3 | How reliable is public reporting on power plant data, and does that reliability vary by fuel type? | An almost-50%-missing field changes how much any age- or vintage-based finding can be trusted |

## Data

- **Source:** World Resources Institute, Global Power Plant Database.
- **Shape:** 28,664 plants, 22 columns, 164 countries.
- **Grain:** one row per power plant.

## Data cleaning (see the notebook for the full log)

- **17 rows (all China) had corrupted coordinates** (values like `1075744`, almost certainly a dropped decimal point). Rather than guess the correction, these were set to null and excluded from map-based analysis only; every other column for those rows is still used.
- **No imputation.** Missing commissioning year (47.8%), owner (36.9%), and secondary fuel columns are left as null and excluded pairwise, never filled in.
- **`estimated_generation_gwh` used as the generation figure**, not the year-by-year `generation_gwh_2013-2016` columns, since those are 71-98.5% missing while the estimate is only 3.9% missing.
- **A `fuel_category` column was derived**: Renewable (Hydro, Solar, Wind, Geothermal, Wave and Tidal), Fossil (Coal, Gas, Oil, Petcoke, Cogeneration), Nuclear, and Other (Biomass, Waste, Storage). Biomass and Waste are kept out of "Renewable" on purpose, since their real emissions depend on feedstock and combustion method.

## Findings

**By plant count, renewables already make up 62% of the world's power plants. By capacity, they're only 25%.** Fossil fuel plants are, on average, far bigger than renewable ones, so the capacity mix hasn't caught up with the plant-count mix yet.

**The renewable transition is geography as much as policy.** The most renewable-heavy grids (Paraguay 100%, Norway 96%, Tajikistan 88%) are hydro-rich countries. The least renewable grids are almost entirely Gulf oil and gas states at or near 0%. This dataset's vintage is roughly 2017-2018; several of those Gulf states have since announced or built real solar capacity, so this reflects the transition's starting point, not necessarily today.

**Fossil fuel still adds more new capacity than renewables every decade, including the most recent one, but renewable's share is growing fast.** In the 2000s, renewables were 15% of new capacity added; in the 2010s (a partial decade in this data), that rose to 28%. The transition is real and accelerating, but it hasn't flipped yet.

**Renewable plants are the least documented part of the entire dataset.** Solar, biomass, and wind are missing a commissioning year for 60-64% of plants, versus 25-28% for coal and oil. This means any age comparison between fossil and renewable fleets is itself biased toward the better-documented half of each, which is a genuine limitation on how far research question 2's conclusions can be pushed.

## Limitations

- Dataset vintage is roughly 2017-2018; renewable buildout has continued fast since then, especially in the Gulf and in China.
- Almost half the dataset has no commissioning year, and that missingness is not random across fuel types (see finding above), which limits confidence in any age-based comparison.
- No cost, emissions, or capacity-factor data is included, so this analysis speaks to installed capacity and fleet age, not actual electricity output, cost of generation, or carbon emissions directly.

## Repro

```bash
# from the repo root
uv run jupyter lab   # notebooks/01_eda_and_research_questions.ipynb has the full analysis
```
