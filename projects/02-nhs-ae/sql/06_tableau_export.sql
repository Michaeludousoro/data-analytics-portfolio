-- 06_tableau_export.sql
--
-- Builds the data source for the future Power BI dashboard: one row per
-- (month, trust, region), with attendances, 4-hour and 12-hour breaches,
-- so the dashboard can slice by any of those three dimensions.

WITH parsed AS (
    SELECT
        *,
        STRPTIME(REPLACE(Period, 'MSitAE-', ''), '%B-%Y') AS period_date
    FROM ae_provider
    WHERE "Org Code" != 'TOTAL'
)
SELECT
    STRFTIME(period_date, '%Y-%m')        AS month,
    "Org name"                            AS trust,
    TRIM("Parent Org")                    AS region,
    "A&E attendances Type 1" + "A&E attendances Type 2" + "A&E attendances Other A&E Department" AS total_attendances,
    "A&E attendances Type 1"              AS type1_attendances,
    "Attendances over 4hrs Type 1" + "Attendances over 4hrs Type 2" + "Attendances over 4hrs Other Department" AS total_over_4hrs,
    "Attendances over 4hrs Type 1"        AS type1_over_4hrs,
    "Patients who have waited 4-12 hs from DTA to admission"  AS breaches_4_to_12hr,
    "Patients who have waited 12+ hrs from DTA to admission"  AS breaches_12hr_plus
FROM parsed
ORDER BY month, trust;
