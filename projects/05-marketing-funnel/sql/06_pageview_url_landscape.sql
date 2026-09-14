-- 06_pageview_url_landscape.sql
--
-- Question: what pages exist on the site, and how much traffic does each get?
-- This grounds the funnel step definitions in the next query in real data,
-- rather than guessing page names.

SELECT
    pageview_url,
    COUNT(*)                            AS pageviews,
    COUNT(DISTINCT website_session_id)  AS sessions
FROM website_pageviews
GROUP BY
    pageview_url
ORDER BY
    pageviews DESC;
