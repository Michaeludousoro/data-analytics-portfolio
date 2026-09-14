-- 02_data_quality_issues.sql
--
-- Question: are there data entry errors that would distort a risk model if
-- left in as-is. This dataset is known to have a handful of them, this
-- checks their actual size in this copy of the data.

-- A. Age recorded as 0. One borrower cannot be zero years old, this is a
-- data entry error, not a real young borrower.
SELECT COUNT(*) AS age_zero_rows
FROM borrowers
WHERE age = 0;

-- B. The late-payment columns use 96 and 98 as sentinel values rather than
-- real counts, most likely a coding error upstream. A borrower genuinely
-- late 96 or 98 separate times is not plausible.
SELECT
    COUNT(*) FILTER (WHERE late_30_59_days IN (96, 98)) AS late_30_59_sentinel_rows,
    COUNT(*) FILTER (WHERE late_60_89_days IN (96, 98)) AS late_60_89_sentinel_rows,
    COUNT(*) FILTER (WHERE late_90_plus_days IN (96, 98)) AS late_90_plus_sentinel_rows,
    COUNT(DISTINCT borrower_id) FILTER (
        WHERE late_30_59_days IN (96, 98)
           OR late_60_89_days IN (96, 98)
           OR late_90_plus_days IN (96, 98)
    ) AS borrowers_affected
FROM borrowers;

-- C. Revolving utilization should sit roughly between 0 and 1 (the share of
-- available credit in use). Values far above 1 are possible in theory
-- (a card over its limit) but values in the thousands are not real.
SELECT
    COUNT(*) FILTER (WHERE revolving_utilization > 2) AS utilization_over_2,
    MAX(revolving_utilization) AS max_utilization
FROM borrowers;

-- D. Debt ratio is monthly debt payments divided by monthly income, so a
-- ratio above roughly 5 to 10 is already implausible for anyone the lender
-- would extend more credit to, and the maximum here is far beyond that.
SELECT
    COUNT(*) FILTER (WHERE debt_ratio > 10) AS debt_ratio_over_10,
    MAX(debt_ratio) AS max_debt_ratio
FROM borrowers;
