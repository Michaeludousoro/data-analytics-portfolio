-- 04_age_and_utilization.sql
--
-- Question: two more classic credit risk factors, age and how much of
-- their available credit a borrower is already using. The one age = 0
-- row and the small number of extreme utilization values are excluded so
-- one or two bad rows don't distort a whole band's default rate.

SELECT
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age < 40 THEN '30 to 39'
        WHEN age < 50 THEN '40 to 49'
        WHEN age < 60 THEN '50 to 59'
        WHEN age < 70 THEN '60 to 69'
        ELSE '70 and over'
    END AS age_band,
    COUNT(*) AS borrowers,
    ROUND(AVG(serious_delinquency) * 100, 2) AS default_rate_pct
FROM borrowers
WHERE age > 0
GROUP BY 1
ORDER BY MIN(age);

-- Utilization band: the amount of revolving credit in use as a share of
-- the limit. Capped at 2 (200% of limit) to exclude the handful of clear
-- data errors identified in 02_data_quality_issues.sql.
SELECT
    CASE
        WHEN revolving_utilization < 0.1 THEN 'Under 10%'
        WHEN revolving_utilization < 0.3 THEN '10% to 30%'
        WHEN revolving_utilization < 0.6 THEN '30% to 60%'
        WHEN revolving_utilization < 1.0 THEN '60% to 100%'
        ELSE 'Over 100% (over limit)'
    END AS utilization_band,
    COUNT(*) AS borrowers,
    ROUND(AVG(serious_delinquency) * 100, 2) AS default_rate_pct
FROM borrowers
WHERE revolving_utilization <= 2
GROUP BY 1
ORDER BY MIN(revolving_utilization);
