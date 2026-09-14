-- 05_volume_vs_performance.sql
--
-- Question (Operational Research): do busier Type 1 departments perform
-- worse against the 4-hour standard, or is performance independent of
-- volume? This tells leadership whether the fix is "add capacity at busy
-- sites" or something else entirely.

SELECT
    "Org name"                    AS trust,
    SUM("A&E attendances Type 1") AS type1_attendances,
    ROUND(SUM("A&E attendances Type 1") / 12.0, 0) AS avg_monthly_type1_attendances,
    ROUND(
        100.0 * (1 - SUM("Attendances over 4hrs Type 1") / SUM("A&E attendances Type 1")),
        1
    ) AS pct_within_4hrs
FROM ae_provider
WHERE "Org Code" != 'TOTAL'
GROUP BY trust
HAVING type1_attendances >= 12000
ORDER BY type1_attendances DESC;
