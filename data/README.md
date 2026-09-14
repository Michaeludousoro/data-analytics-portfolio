# Data

This folder is for **shared** reference data used by more than one project.
Project-specific data lives under `projects/<project>/data/`.

## Rules

- **`raw/`** — original downloads, exactly as they came. Never edited by hand,
  never committed to git (see `.gitignore`). Each project's `README.md` says
  where to download its raw data.
- **`processed/`** — cleaned, analysis-ready tables written by our own code.
  May be committed if small (< ~5 MB) so the Quarto site can rebuild in CI.
- Every dataset must be **reproducible**: a script or documented steps that
  turn `raw/` into `processed/`. An interviewer will ask "could someone else
  rerun this?" — the answer must be yes.
