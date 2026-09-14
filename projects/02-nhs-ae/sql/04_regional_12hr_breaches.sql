-- 04_regional_12hr_breaches.sql
--
-- Question (NHS England leadership): a 12+ hour wait from the decision to
-- admit is the most severe breach tracked, and a well known patient safety
-- concern. Which NHS England regions carry the most of them, relative to
-- their volume?

SELECT
    TRIM("Parent Org")            AS region,
    SUM("A&E attendances Type 1" + "A&E attendances Type 2" + "A&E attendances Other A&E Department") AS total_attendances,
    SUM("Patients who have waited 12+ hrs from DTA to admission") AS total_12hr_plus_breaches,
    ROUND(
        1000.0 * SUM("Patients who have waited 12+ hrs from DTA to admission")
                / SUM("A&E attendances Type 1" + "A&E attendances Type 2" + "A&E attendances Other A&E Department"),
        2
    ) AS breaches_per_1000_attendances
FROM ae_provider
WHERE "Org Code" != 'TOTAL' AND "Parent Org" IS NOT NULL AND TRIM("Parent Org") != ''
GROUP BY region
ORDER BY breaches_per_1000_attendances DESC;
