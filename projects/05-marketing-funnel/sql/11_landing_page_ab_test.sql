-- 11_landing_page_ab_test.sql
--
-- Question (Website Manager): which landing page converts best?
--
-- "Landing page" means the FIRST page of a session - not just any page that
-- happened to appear in it. That needs a window function: rank each session's
-- pageviews by time, keep only rank 1.

WITH ranked_pageviews AS (
    SELECT
        website_session_id,
        pageview_url,
        created_at,
        ROW_NUMBER() OVER (
            PARTITION BY website_session_id   -- restart the count for each session
            ORDER BY created_at               -- earliest pageview first
        ) AS pageview_rank
    FROM website_pageviews
),
landing_pages AS (
    SELECT website_session_id, pageview_url AS landing_page
    FROM ranked_pageviews
    WHERE pageview_rank = 1                   -- only the first pageview of each session
)
SELECT
    lp.landing_page,
    COUNT(DISTINCT lp.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id)            AS orders,
    ROUND(
        100.0 * COUNT(DISTINCT o.order_id)
              / COUNT(DISTINCT lp.website_session_id),
        2
    ) AS conversion_rate_pct,
    MIN(s.created_at) AS first_seen,
    MAX(s.created_at) AS last_seen
FROM landing_pages AS lp
JOIN website_sessions AS s
    ON s.website_session_id = lp.website_session_id
LEFT JOIN orders AS o
    ON o.website_session_id = lp.website_session_id
WHERE lp.landing_page IN ('/home', '/lander-1', '/lander-2', '/lander-3', '/lander-4', '/lander-5')
GROUP BY lp.landing_page
ORDER BY sessions DESC;
