-- 05_gsearch_nonbrand_device_trend.sql
--
-- Question: is the desktop/mobile conversion gap for gsearch nonbrand stable
-- over time, or is mobile catching up?
--
-- One row per month. Desktop and mobile conversion sit in their own columns
-- so the trend is easy to read.

SELECT
    DATE_FORMAT(s.created_at, '%Y-%m') AS month,

    -- desktop conversion rate this month
    ROUND(100.0
        * COUNT(DISTINCT CASE WHEN s.device_type = 'desktop' THEN o.order_id END)
        / COUNT(DISTINCT CASE WHEN s.device_type = 'desktop' THEN s.website_session_id END)
    , 2) AS desktop_cvr_pct,

    -- mobile conversion rate this month
    ROUND(100.0
        * COUNT(DISTINCT CASE WHEN s.device_type = 'mobile' THEN o.order_id END)
        / COUNT(DISTINCT CASE WHEN s.device_type = 'mobile' THEN s.website_session_id END)
    , 2) AS mobile_cvr_pct,

    COUNT(DISTINCT s.website_session_id) AS new_sessions
FROM website_sessions AS s
LEFT JOIN orders AS o
    ON o.website_session_id = s.website_session_id
WHERE s.is_repeat_session = 0
  AND s.utm_source   = 'gsearch'
  AND s.utm_campaign = 'nonbrand'
GROUP BY
    DATE_FORMAT(s.created_at, '%Y-%m')
ORDER BY
    month;
