-- 03_trust_type1_performance.sql
--
-- Question (NHS England leadership): which trusts are the clearest
-- outliers on Type 1 (major A&E) 4-hour performance, best and worst,
-- over the last 12 months?
--
-- Restricted to providers who actually run a Type 1 department with
-- meaningful volume, so a walk-in minor injuries unit with zero Type 1
-- attendances is not compared against a major trauma centre.

SELECT
    "Org name"                    AS trust,
    TRIM("Parent Org")            AS region,
    SUM("A&E attendances Type 1") AS type1_attendances,
    SUM("Attendances over 4hrs Type 1") AS type1_over_4hrs,
    ROUND(
        100.0 * (1 - SUM("Attendances over 4hrs Type 1") / SUM("A&E attendances Type 1")),
        1
    ) AS pct_within_4hrs,
    SUM("Patients who have waited 12+ hrs from DTA to admission") AS total_12hr_plus_breaches
FROM ae_provider
WHERE "Org Code" != 'TOTAL'
GROUP BY trust, region
HAVING type1_attendances >= 12000   -- at least ~1,000/month on average: a real, active Type 1 department
ORDER BY pct_within_4hrs DESC;
