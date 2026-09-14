-- 03_conversion_new_visitors.sql
--
-- Same as 02, but restricted to FIRST-TIME sessions (is_repeat_session = 0).
--
-- Why: returning visitors convert much more often, and some channels (brand,
-- direct) attract a lot of them. Mixing new + returning visitors flatters
-- those channels. To judge a channel on how well it ACQUIRES customers,
-- compare only the sessions where the visitor is seeing the site for the
-- first time.

SELECT
    COALESCE(s.utm_source, '(none)')   AS utm_source,
    COALESCE(s.utm_campaign, '(none)') AS utm_campaign,
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
WHERE s.is_repeat_session = 0          -- first visit only
GROUP BY
    s.utm_source,
    s.utm_campaign
ORDER BY
    new_sessions DESC;
