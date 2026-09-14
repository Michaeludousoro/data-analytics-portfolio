-- 01_data_overview.sql
--
-- Question: how big is this dataset, and what is the baseline default rate
-- before any modelling happens.

SELECT
    COUNT(*) AS borrowers,
    SUM(serious_delinquency) AS serious_delinquencies,
    ROUND(AVG(serious_delinquency) * 100, 2) AS default_rate_pct,
    COUNT(*) FILTER (WHERE monthly_income IS NULL) AS missing_income,
    COUNT(*) FILTER (WHERE dependents IS NULL) AS missing_dependents
FROM borrowers;
