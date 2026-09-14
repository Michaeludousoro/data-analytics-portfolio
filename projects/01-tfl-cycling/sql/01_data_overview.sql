-- 01_data_overview.sql
--
-- Question: what does the trip data actually cover before trusting any
-- downstream number.

SELECT
    COUNT(*) AS trips,
    MIN(start_time) AS first_trip,
    MAX(start_time) AS last_trip,
    COUNT(DISTINCT start_station_id) AS distinct_start_stations,
    COUNT(DISTINCT bike_id) AS distinct_bikes,
    ROUND(AVG(duration_min), 1) AS avg_duration_min,
    ROUND(MEDIAN(duration_min), 1) AS median_duration_min
FROM trips;
