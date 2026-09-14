-- 02_conversion_by_channel.sql
--
-- Question (Marketing Director): which channels actually produce buyers,
-- not just clicks?
--
-- For each channel: session volume, orders placed, and the conversion rate
-- (orders / sessions). Grain: one row per (utm_source, utm_campaign).

SELECT
    COALESCE(s.utm_source, '(none)')   AS utm_source,
    COALESCE(s.utm_campaign, '(none)') AS utm_campaign,
    COUNT(DISTINCT s.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id)           AS orders,
    ROUND(
        100.0 * COUNT(DISTINCT o.order_id)
              / COUNT(DISTINCT s.website_session_id),
        2
    ) AS conversion_rate_pct
FROM website_sessions AS s
LEFT JOIN orders AS o
    ON o.website_session_id = s.website_session_id
GROUP BY
    s.utm_source,
    s.utm_campaign
ORDER BY
    sessions DESC;
