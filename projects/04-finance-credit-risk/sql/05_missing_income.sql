-- 05_missing_income.sql
--
-- Question: nearly 20% of borrowers have no monthly income recorded. Before
-- deciding how to handle that in a model, it matters whether missing income
-- is random or whether it is itself a risk signal.

SELECT
    CASE WHEN monthly_income IS NULL THEN 'Income missing' ELSE 'Income recorded' END AS income_status,
    COUNT(*) AS borrowers,
    ROUND(AVG(serious_delinquency) * 100, 2) AS default_rate_pct
FROM borrowers
GROUP BY 1;
