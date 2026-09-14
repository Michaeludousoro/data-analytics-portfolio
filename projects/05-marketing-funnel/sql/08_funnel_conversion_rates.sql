-- 08_funnel_conversion_rates.sql
--
-- Reshapes the funnel counts from 07 into a tidy, long-format table:
-- one row per step, with % of all sessions and step-to-step click-through.

WITH session_flags AS (
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
        MAX(CASE WHEN pageview_url IN ('/billing', '/billing-2') THEN 1 ELSE 0 END) AS reached_billing,
        MAX(CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END) AS reached_order
    FROM website_pageviews
    GROUP BY website_session_id
),
funnel_counts AS (
    SELECT
        COUNT(*)              AS total_sessions,
        SUM(reached_product)  AS reached_product,
        SUM(reached_cart)     AS reached_cart,
        SUM(reached_shipping) AS reached_shipping,
        SUM(reached_billing)  AS reached_billing,
        SUM(reached_order)    AS reached_order
    FROM session_flags
)
-- Each branch below is one funnel step: how many sessions got there,
-- how many were eligible to (the step before), % of the whole funnel,
-- and % of the prior step that continued ("click-through").
SELECT 'landing -> product' AS funnel_step,
       reached_product AS sessions_through, total_sessions AS sessions_prior,
       ROUND(100.0 * reached_product / total_sessions, 1) AS pct_of_total,
       ROUND(100.0 * reached_product / total_sessions, 1) AS step_click_through_pct
FROM funnel_counts
UNION ALL
SELECT 'product -> cart',
       reached_cart, reached_product,
       ROUND(100.0 * reached_cart / total_sessions, 1),
       ROUND(100.0 * reached_cart / reached_product, 1)
FROM funnel_counts
UNION ALL
SELECT 'cart -> shipping',
       reached_shipping, reached_cart,
       ROUND(100.0 * reached_shipping / total_sessions, 1),
       ROUND(100.0 * reached_shipping / reached_cart, 1)
FROM funnel_counts
UNION ALL
SELECT 'shipping -> billing',
       reached_billing, reached_shipping,
       ROUND(100.0 * reached_billing / total_sessions, 1),
       ROUND(100.0 * reached_billing / reached_shipping, 1)
FROM funnel_counts
UNION ALL
SELECT 'billing -> order',
       reached_order, reached_billing,
       ROUND(100.0 * reached_order / total_sessions, 1),
       ROUND(100.0 * reached_order / reached_billing, 1)
FROM funnel_counts;
