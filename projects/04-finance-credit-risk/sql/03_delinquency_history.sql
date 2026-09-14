-- 03_delinquency_history.sql
--
-- Question: does past late payment behaviour actually predict a serious
-- delinquency in the next two years. The sentinel rows (96/98) found in
-- 02_data_quality_issues.sql are excluded here so they don't distort the
-- pattern.

SELECT
    CASE
        WHEN late_90_plus_days = 0 THEN '0 times'
        WHEN late_90_plus_days = 1 THEN '1 time'
        WHEN late_90_plus_days = 2 THEN '2 times'
        ELSE '3+ times'
    END AS times_90_plus_days_late,
    COUNT(*) AS borrowers,
    SUM(serious_delinquency) AS defaults,
    ROUND(AVG(serious_delinquency) * 100, 2) AS default_rate_pct
FROM borrowers
WHERE late_90_plus_days NOT IN (96, 98)
GROUP BY 1
ORDER BY MIN(late_90_plus_days);
