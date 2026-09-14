# Data Analytics Portfolio

Five end-to-end data **analyst** case studies, one per sector. Each starts
from a real business question, uses public data, and ends with a dashboard
and a recommendation for a named stakeholder — not just a model.

| # | Sector | Business question | Core skills | Tools |
|---|--------|-------------------|-------------|-------|
| 1 | Transport (TfL) | Where is Santander Cycles demand most imbalanced, and how should bikes be rebalanced? | time series, geospatial, external data joins, operational KPIs | SQL, Python, Tableau |
| 2 | Healthcare (NHS) | What drives A&E 4-hour target breaches, and which trusts are outliers? | benchmarking, regression, messy public data | SQL, Python, Power BI |
| 3 | Retail — Customer Experience & Retention (Olist) | Which customer segments should marketing target, and what is unstructured review text saying that the numbers don't? | relational SQL, cohort retention, RFM, CLV, LLM-based sentiment/topic tagging, geospatial delivery analysis | SQL, Python, an LLM API, Tableau |
| 4 | Finance (American Express Default Prediction) | Can we cut default losses without rejecting too many good borrowers? | classification as a business decision, cost-benefit, Excel modelling | SQL, Python, Excel, Power BI |
| 5 | Marketing (Maven Fuzzy Factory) — **done** | Which channels convert, where does the funnel leak, did the launch work, did the A/B tests work? | SQL (CTEs, window functions, conditional aggregation), funnels, attribution, A/B testing | SQL, Python, Tableau — [live dashboard](https://public.tableau.com/app/profile/michael.udousoro/viz/MavenFuzzyFactory-MarketingFunnelAnalysis/MarketingFunnelOverview) |

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
