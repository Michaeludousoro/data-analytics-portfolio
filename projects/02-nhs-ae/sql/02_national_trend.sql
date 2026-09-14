-- 02_national_trend.sql
--
-- Question (NHS England leadership): how has national A&E performance
-- against the 4-hour standard moved over the last 12 months?
--
-- Period arrives as text like "MSitAE-APRIL-2025", which does not sort
-- chronologically as a string. STRPTIME parses it into a real date so
-- ORDER BY actually runs April 2025 to March 2026, not alphabetically.

WITH parsed AS (
    SELECT
        *,
        STRPTIME(REPLACE(Period, 'MSitAE-', ''), '%B-%Y') AS period_date
    FROM ae_provider
    WHERE "Org Code" != 'TOTAL'
)
SELECT
    STRFTIME(period_date, '%Y-%m') AS month,
    SUM("A&E attendances Type 1" + "A&E attendances Type 2" + "A&E attendances Other A&E Department") AS total_attendances,
    SUM("Attendances over 4hrs Type 1" + "Attendances over 4hrs Type 2" + "Attendances over 4hrs Other Department") AS total_over_4hrs,
    ROUND(
        100.0 * (1 - SUM("Attendances over 4hrs Type 1" + "Attendances over 4hrs Type 2" + "Attendances over 4hrs Other Department")
                    / SUM("A&E attendances Type 1" + "A&E attendances Type 2" + "A&E attendances Other A&E Department")),
        1
    ) AS pct_within_4hrs,
    SUM("Patients who have waited 12+ hrs from DTA to admission") AS total_12hr_plus_breaches
FROM parsed
GROUP BY month
ORDER BY month;
