-- 01_data_overview.sql
--
-- Question: what does the provider-level data actually cover, and how many
-- distinct trusts and months are in it, before trusting any downstream
-- number.
--
-- Excludes the embedded national "TOTAL" row each monthly file includes,
-- since that is a summary row, not a real provider.

SELECT
    COUNT(DISTINCT Period)      AS months,
    COUNT(DISTINCT "Org Code")  AS distinct_providers,
    COUNT(*)                    AS provider_month_rows,
    SUM("A&E attendances Type 1" + "A&E attendances Type 2" + "A&E attendances Other A&E Department") AS total_attendances
FROM ae_provider
WHERE "Org Code" != 'TOTAL';
