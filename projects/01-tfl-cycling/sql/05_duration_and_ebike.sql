-- 05_duration_and_ebike.sql
--
-- Question (Fleet Planning): do e-bikes get used differently from classic
-- bikes? This matters for how many of each to buy and where to place them.

SELECT
    bike_model,
    COUNT(*)                        AS trips,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_trips,
    ROUND(AVG(duration_min), 1)     AS avg_duration_min,
    ROUND(MEDIAN(duration_min), 1)  AS median_duration_min,
    SUM(CASE WHEN start_station_id = end_station_id THEN 1 ELSE 0 END) AS round_trips,
    ROUND(100.0 * SUM(CASE WHEN start_station_id = end_station_id THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_round_trips
FROM trips
WHERE duration_min BETWEEN 1 AND 180   -- drop clearly broken/unrealistic durations (docking errors, etc.)
GROUP BY bike_model;
