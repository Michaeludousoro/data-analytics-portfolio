-- 03_station_imbalance.sql
--
-- Question (Operations): which stations are chronically out of balance, and
-- so need bikes physically moved in or out by a rebalancing van rather than
-- relying on riders to balance them naturally?
--
-- Net flow = arrivals - departures for a station, averaged per day over the
-- window. Strongly negative = riders keep taking bikes away faster than
-- they return them (the station tends toward empty). Strongly positive =
-- bikes pile up faster than they leave (the station tends toward full).

WITH departures AS (
    SELECT start_station_id AS station_id, start_station AS station_name, COUNT(*) AS n
    FROM trips
    GROUP BY start_station_id, start_station
),
arrivals AS (
    SELECT end_station_id AS station_id, end_station AS station_name, COUNT(*) AS n
    FROM trips
    GROUP BY end_station_id, end_station
),
days AS (
    SELECT DATE_DIFF('day', MIN(start_time), MAX(start_time)) + 1 AS n_days FROM trips
)
SELECT
    COALESCE(d.station_name, a.station_name) AS station,
    COALESCE(d.n, 0)                         AS departures,
    COALESCE(a.n, 0)                         AS arrivals,
    COALESCE(a.n, 0) - COALESCE(d.n, 0)      AS net_flow,
    ROUND((COALESCE(a.n, 0) - COALESCE(d.n, 0)) / (SELECT n_days FROM days), 1) AS avg_net_flow_per_day,
    COALESCE(d.n, 0) + COALESCE(a.n, 0)      AS total_activity
FROM departures AS d
FULL OUTER JOIN arrivals AS a
    ON a.station_id = d.station_id
WHERE COALESCE(d.n, 0) + COALESCE(a.n, 0) >= 100   -- drop near-unused stations, they're not a rebalancing priority
ORDER BY ABS(net_flow) DESC
LIMIT 20;
