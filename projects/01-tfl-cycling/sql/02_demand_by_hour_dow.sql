-- 02_demand_by_hour_dow.sql
--
-- Question (Network Planning): when does demand actually happen, by hour
-- of day and day of week? This is what any rebalancing schedule has to be
-- built around.

SELECT
    DAYNAME(start_time)      AS day_of_week,
    EXTRACT(DOW FROM start_time) AS dow_num,   -- kept only to sort Mon-Sun correctly
    EXTRACT(HOUR FROM start_time) AS hour_of_day,
    COUNT(*)                 AS trips
FROM trips
GROUP BY day_of_week, dow_num, hour_of_day
ORDER BY dow_num, hour_of_day;
