-- 04_top_stations_and_routes.sql
--
-- Question: which stations see the most overall traffic, and what are the
-- most common single routes on the network?

SELECT start_station AS station, COUNT(*) AS departures
FROM trips
GROUP BY start_station
ORDER BY departures DESC
LIMIT 10;
