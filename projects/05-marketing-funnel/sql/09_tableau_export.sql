-- 09_tableau_export.sql
--
-- Builds the data source for the Tableau dashboard: one row per
-- (month, channel, device, visitor type), with session/funnel/order counts
-- and revenue. Small enough to commit; granular enough for Tableau to slice
-- any way the dashboard needs.

WITH funnel_flags AS (
    SELECT
        website_session_id,
        MAX(CASE WHEN pageview_url IN (
                '/products',
                '/the-original-mr-fuzzy',
                '/the-forever-love-bear',
                '/the-birthday-sugar-panda',
                '/the-hudson-river-mini-bear'
            ) THEN 1 ELSE 0 END) AS reached_product,
        MAX(CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END) AS reached_cart,
        MAX(CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END) AS reached_shipping,
        MAX(CASE WHEN pageview_url IN ('/billing', '/billing-2') THEN 1 ELSE 0 END) AS reached_billing
    FROM website_pageviews
    GROUP BY website_session_id
)
SELECT
    DATE_FORMAT(s.created_at, '%Y-%m-01') AS month,     -- first-of-month as a real date, for Tableau's date hierarchy
    COALESCE(s.utm_source, '(none)')   AS utm_source,
    COALESCE(s.utm_campaign, '(none)') AS utm_campaign,
    s.device_type,
    CASE WHEN s.is_repeat_session = 1 THEN 'Returning' ELSE 'New' END AS visitor_type,

    COUNT(DISTINCT s.website_session_id) AS sessions,
    SUM(f.reached_product)               AS sessions_reached_product,
    SUM(f.reached_cart)                  AS sessions_reached_cart,
    SUM(f.reached_shipping)              AS sessions_reached_shipping,
    SUM(f.reached_billing)               AS sessions_reached_billing,
    COUNT(DISTINCT o.order_id)           AS orders,
    ROUND(SUM(o.price_usd), 2)           AS revenue_usd

FROM website_sessions AS s
JOIN funnel_flags AS f
    ON f.website_session_id = s.website_session_id
LEFT JOIN orders AS o
    ON o.website_session_id = s.website_session_id
GROUP BY
    DATE_FORMAT(s.created_at, '%Y-%m-01'),
    s.utm_source,
    s.utm_campaign,
    s.device_type,
    s.is_repeat_session
ORDER BY
    month;
