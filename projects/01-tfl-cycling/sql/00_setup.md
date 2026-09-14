## Data and setup

Source: TfL's public cycle hire usage data, published as CSV files at
`cycling.data.tfl.gov.uk`. Each file covers a half-month of trips across the
whole Santander Cycles (London's public bike share) network.

This analysis uses the four most recent files available at build time
(1 April to 31 May 2026), about 1.67 million trips. TfL's full archive goes
back to 2012, but a full multi-year download is tens of gigabytes and not
needed to answer the demand and rebalancing questions this project asks. Two
recent months give enough volume to see real hourly, daily, and station-level
patterns, and reflect how the network runs today rather than a decade ago.

Loaded into a local DuckDB file (`data/processed/tfl_cycling.duckdb`), no
server needed. To rebuild it, download the CSVs into `data/raw/` and rerun
the load step at the top of the notebook.
