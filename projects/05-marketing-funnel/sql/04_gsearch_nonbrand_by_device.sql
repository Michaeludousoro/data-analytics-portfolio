-- 04_gsearch_nonbrand_by_device.sql
--
-- Question (Marketing Director): we spend most of our budget on gsearch
-- nonbrand. Should we bid the same on mobile and desktop?
--
-- Google lets you set a separate bid adjustment per device. The right
-- adjustment depends on how well each device converts. So: for gsearch
-- nonbrand, first-time sessions, split conversion by device_type.

SELECT
    s.device_type,
    COUNT(DISTINCT s.website_session_id) AS new_sessions,
    COUNT(DISTINCT o.order_id)           AS orders,
    ROUND(
        100.0 * COUNT(DISTINCT o.order_id)
              / COUNT(DISTINCT s.website_session_id),
        2
    ) AS conversion_rate_pct
FROM website_sessions AS s
LEFT JOIN orders AS o
    ON o.website_session_id = s.website_session_id
WHERE s.is_repeat_session = 0
  AND s.utm_source   = 'gsearch'
  AND s.utm_campaign = 'nonbrand'
GROUP BY
    s.device_type
ORDER BY
    new_sessions DESC;
