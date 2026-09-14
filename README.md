# Data Analytics Portfolio

Six end-to-end data **analyst** case studies, one per sector. Each starts
from a real business or research question, uses public data, and ends with
a written report and, where it fits, a dashboard and a recommendation for a
named stakeholder, not just a model.

| # | Sector | Business question | Core skills | Tools |
|---|--------|-------------------|-------------|-------|
| 1 | Transport (TfL) — **done** | Where is Santander Cycles demand most imbalanced, and how should bikes be rebalanced? | time series, DuckDB, operational KPIs, demand pattern analysis | SQL (DuckDB), Python, [Tableau](https://public.tableau.com/app/profile/michael.udousoro/viz/TfLCycling-DemandandRebalancingAnalysis/Dashboard1) |
| 2 | Healthcare (NHS) — **done** | What drives A&E 4-hour target breaches, and which trusts are outliers? | benchmarking, seasonal trend analysis, real government open data | SQL (DuckDB), Python, [Tableau](https://public.tableau.com/app/profile/michael.udousoro/viz/NHSAEPerformance-NationalTrendandTrustBenchmarking/NHSAEPerformance) (originally planned as Power BI, swapped, see project README) |
| 3 | Retail, Customer Experience & Retention (Olist) — **done** | Who are the valuable customers, does late delivery hurt reviews, and what does an AI sentiment layer on the review text add? | relational SQL, RFM/customer value, AI-augmented review sentiment, geographic and category analysis | SQL, Python, a pretrained NLP model, [Tableau](https://public.tableau.com/app/profile/michael.udousoro/viz/OlistRetail-RevenueandDeliveryAnalysis/OlistRetailAnalysis) |
| 4 | Finance (Credit Risk) — **done** | Can we cut default losses without rejecting too many good borrowers? | classification as a business decision, cost-benefit, Excel scenario modelling | SQL (DuckDB), Python, Excel, [Tableau](https://public.tableau.com/app/profile/michael.udousoro/viz/CreditRisk-CutoffAnalysis/CreditRiskCutoffAnalysis) (originally planned as Power BI, swapped, see project README) |
| 5 | Marketing (Maven Fuzzy Factory) — **done** | Which channels convert, where does the funnel leak, did the launch work, did the A/B tests work? | SQL (CTEs, window functions, conditional aggregation), funnels, attribution, A/B testing | SQL, Python, Tableau, [live dashboard](https://public.tableau.com/app/profile/michael.udousoro/viz/MavenFuzzyFactory-MarketingFunnelAnalysis/MarketingFunnelOverview) |
| 6 | Energy (Global Power Plant Database) — **done** | How far along is the world's shift away from fossil fuel generation, and how reliable is the data behind that question? | data cleaning and documentation, EDA, geospatial visualization, written analytical reporting | Python, Plotly, matplotlib |

Full write-ups: **[portfolio website](#)** _(link added once the Quarto site is published)_.

## Repository layout

```
data-analytics-portfolio/
├── pyproject.toml         # dependencies + Ruff config (managed by uv)
├── uv.lock               # exact locked versions - reproducible installs
├── src/portfolio/        # shared helpers: file paths, house chart style
├── data/                 # shared reference data (raw/ is gitignored)
├── docs/style-guide.md   # the code standard for this repo
├── projects/
│   └── NN-<name>/
│       ├── README.md     # the one-page case study (60-second skim)
│       ├── report.md     # the full written report (~1,000-2,000 words)
│       ├── data/         # raw/ (gitignored) + processed/
│       ├── sql/          # queries, one concern per file
│       ├── notebooks/    # the analysis
│       ├── src/          # project-specific reusable code
│       └── outputs/      # figures + dashboard screenshots
└── site/                 # Quarto portfolio website
```

## Setup

Requires [uv](https://docs.astral.sh/uv/) and [Quarto](https://quarto.org/).

```bash
uv sync                              # create .venv and install everything
uv run python -m ipykernel install --user --name data-portfolio
uv run pre-commit install            # format/lint on every commit
uv run jupyter lab                   # start working
```

Every project's `README.md` explains where to download its raw data.

## Tooling

- **uv** — Python 3.12, virtual environment, locked dependencies
- **DuckDB** — SQL directly on CSV/Parquet, no database server
- **Ruff** — linting and formatting (see `docs/style-guide.md`)
- **Quarto** — renders the notebooks and write-ups into the portfolio site
