-- 01_traffic_landscape.sql
--
-- Question (from the Marketing Director): what traffic channels are in the
-- data, and how much of our volume does each one represent?
--
-- Grain of the result: one row per distinct combination of
-- (utm_source, utm_campaign, http_referer), i.e. one row per "channel".

SELECT
    COALESCE(utm_source, '(none)')   AS utm_source,     -- paid channel tag; NULL = no UTM (direct / organic)
    COALESCE(utm_campaign, '(none)') AS utm_campaign,    -- campaign within that source
    COALESCE(http_referer, '(none)') AS http_referer,    -- the site the visitor came from
    COUNT(*)                          AS sessions,       -- how many visits this channel produced
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_sessions
FROM website_sessions
GROUP BY
    utm_source,
    utm_campaign,
    http_referer
ORDER BY
    sessions DESC;
