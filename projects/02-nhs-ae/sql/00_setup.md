## Data and setup

Source: NHS England's public "A&E Attendances and Emergency Admissions"
provider-level statistics, published monthly as CSV files at
england.nhs.uk. Each file has one row per NHS trust or independent sector
provider for that month, with attendance counts, 4-hour and 12-hour breach
counts, split by department type (Type 1 major A&E, Type 2 single
specialty, Type 3/Other minor injury units), plus emergency admissions.

This build uses the 12 most recent months available at build time, April
2025 to March 2026, a full year, about 2,400 provider-month rows after
removing the embedded national "TOTAL" summary row each file includes.

Loaded into a local DuckDB file (`data/processed/nhs_ae.duckdb`), no server
needed. To rebuild it, download the CSVs into `data/raw/` (the exact URLs
are in the notebook's setup cell) and rerun the load step.

Note: one important structural fact about this data. A "Type 1" department
is a major, consultant-led A&E. Many smaller providers only run a "Type 3"
minor injury unit or urgent treatment centre, with zero Type 1 attendances.
Comparing 4-hour performance across all providers without splitting by
type would be misleading, since a walk-in minor injuries unit and a major
trauma centre are not doing comparable work. This analysis focuses Type 1
performance on providers who actually run a Type 1 department.
