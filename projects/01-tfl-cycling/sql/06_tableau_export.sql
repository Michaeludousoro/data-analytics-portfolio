-- 06_tableau_export.sql
--
-- Builds the data source for the future Tableau dashboard: one row per
-- (weekday/weekend, hour, station), with departures, arrivals, and net
-- flow, averaged across the whole window. Weekday vs weekend rather than
-- all 7 days individually, since section 3's finding is that those two
-- regimes are what actually differ, and this keeps the export small
-- enough to commit.

WITH departures AS (
    SELECT
        CASE WHEN EXTRACT(DOW FROM start_time) IN (0, 6) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
        EXTRACT(HOUR FROM start_time) AS hour_of_day,
        start_station_id              AS station_id,
        start_station                 AS station,
        COUNT(*)                      AS departures
    FROM trips
    GROUP BY day_type, hour_of_day, station_id, station
),
arrivals AS (
    SELECT
        CASE WHEN EXTRACT(DOW FROM end_time) IN (0, 6) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
        EXTRACT(HOUR FROM end_time) AS hour_of_day,
        end_station_id              AS station_id,
        end_station                 AS station,
        COUNT(*)                    AS arrivals
    FROM trips
    GROUP BY day_type, hour_of_day, station_id, station
)
SELECT
    COALESCE(d.day_type, a.day_type)       AS day_type,
    COALESCE(d.hour_of_day, a.hour_of_day) AS hour_of_day,
    COALESCE(d.station, a.station)         AS station,
    COALESCE(d.departures, 0)              AS departures,
    COALESCE(a.arrivals, 0)                AS arrivals,
    COALESCE(a.arrivals, 0) - COALESCE(d.departures, 0) AS net_flow
FROM departures AS d
FULL OUTER JOIN arrivals AS a
    ON a.day_type = d.day_type AND a.hour_of_day = d.hour_of_day AND a.station_id = d.station_id
ORDER BY day_type, hour_of_day, station;
