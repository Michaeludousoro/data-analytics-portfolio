# Style guide — "clean code in human form"

The goal: someone who has never seen the repo can open any project, read it
top to bottom like an article, and rerun it. This is also what an interviewer
looks for when they say "walk me through your code".

## Python

- **Names say what the thing is.** `monthly_revenue`, not `df2` or `temp`.
  A reader should never have to scroll up to remember what a variable holds.
- **One idea per cell / per function.** If a function needs the word "and" to
  describe it, split it.
- **Formatting is not a decision.** Ruff owns it. Run `ruff format .` and
  `ruff check --fix .`, or let pre-commit do it on commit. Never hand-format.
- **Reusable logic goes in `src/portfolio/`**, not copy-pasted between
  notebooks.
- **Comments explain _why_, not _what_.** The code already says what.
  Good: `# join on the day before, because bookings settle overnight`.
  Noise: `# loop over rows`.
- **Docstrings** on every function in `src/`: one line on what it returns,
  plus a note on any non-obvious argument.

## Notebooks

Each notebook follows the same skeleton so all five projects feel consistent:

1. **Title + the business question** in a markdown cell, one paragraph.
2. **Setup** — imports, `apply_house_style()`, load data.
3. **Numbered sections** (`## 1. Data quality`, `## 2. ...`). Every section
   starts with a markdown cell saying what it does and ends with a one-line
   takeaway.
4. **Findings** — the answer to the business question, quantified.
5. **Recommendation** — what a named stakeholder should do next.

Keep cell outputs in the committed notebook (recruiters read them on GitHub).
Restart-and-run-all before every commit so the outputs match the code.

## SQL

- Keywords **UPPERCASE**, identifiers `lower_snake_case`.
- One column per line in `SELECT`; leading commas or trailing, but be
  consistent.
- **CTEs (`WITH ... AS`) instead of nested subqueries.** Each CTE does one
  step and is named for that step (`weekly_trips`, `station_totals`).
- Filter early, aggregate late.
- A comment above each CTE saying what it produces.
- Every query file starts with a comment: the question it answers.

## Project deliverables

Every project produces, without exception:

- `README.md` — the one-page case study (Context, Question, Approach,
  Findings, Recommendation), with the headline number in the first two lines.
- Clean SQL in `sql/`, analysis in `notebooks/`, reusable code in `src/`.
- A dashboard (Tableau / Power BI) with a screenshot in `outputs/`.
- A short written recommendation aimed at a specific role
  (e.g. "TfL network planning team").

## Commits

- Present tense, imperative: `add weekly trip aggregation`, not `added` / `adds`.
- Small and focused — one logical change per commit.
- The user runs every `git commit` and `git push` themselves.
