-- 10_billing_ab_test.sql
--
-- Question (Website Manager): did the billing page redesign (/billing -> /billing-2)
-- actually improve checkout completion?
--
-- Not a true concurrent A/B test - /billing-2 replaced /billing rather than running
-- alongside it - so we compare each version's own billing-to-order conversion, and
-- report the date range each was live so the reader can judge whether anything else
-- changed in that window too.

WITH billing_flags AS (
    SELECT
        website_session_id,
        MAX(CASE WHEN pageview_url = '/billing'   THEN 1 ELSE 0 END) AS saw_old_billing,
        MAX(CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END) AS saw_new_billing
    FROM website_pageviews
    WHERE pageview_url IN ('/billing', '/billing-2')
    GROUP BY website_session_id
)
SELECT
    CASE
        WHEN b.saw_old_billing = 1 THEN '/billing (original)'
        WHEN b.saw_new_billing = 1 THEN '/billing-2 (redesign)'
    END AS billing_version,
    COUNT(DISTINCT b.website_session_id) AS sessions_reached_billing,
    COUNT(DISTINCT o.order_id)           AS orders,
    ROUND(
        100.0 * COUNT(DISTINCT o.order_id)
              / COUNT(DISTINCT b.website_session_id),
        2
    ) AS billing_to_order_pct,
    MIN(s.created_at) AS first_seen,
    MAX(s.created_at) AS last_seen
FROM billing_flags AS b
JOIN website_sessions AS s
    ON s.website_session_id = b.website_session_id
LEFT JOIN orders AS o
    ON o.website_session_id = b.website_session_id
WHERE b.saw_old_billing = 1 OR b.saw_new_billing = 1   -- exclude sessions that saw neither
GROUP BY billing_version
ORDER BY first_seen;
