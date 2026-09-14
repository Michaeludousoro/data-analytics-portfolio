-- 07_funnel_step_reach.sql
--
-- Question (Website Manager): of everyone who lands on the site, how many
-- make it to each step of checkout?
--
-- Step 1: for each SESSION, did it ever reach each funnel step (a flag).
-- Step 2: sum those flags to get how many sessions reached each step.

WITH session_flags AS (
    SELECT
        website_session_id,

        -- "product" step = the listing page OR any individual product page
        MAX(CASE WHEN pageview_url IN (
                '/products',
                '/the-original-mr-fuzzy',
                '/the-forever-love-bear',
                '/the-birthday-sugar-panda',
                '/the-hudson-river-mini-bear'
            ) THEN 1 ELSE 0 END) AS reached_product,

        MAX(CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END) AS reached_cart,

        MAX(CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END) AS reached_shipping,

        -- either version of the billing page counts as "reached billing"
        MAX(CASE WHEN pageview_url IN ('/billing', '/billing-2') THEN 1 ELSE 0 END) AS reached_billing,

        MAX(CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END) AS reached_order

    FROM website_pageviews
    GROUP BY website_session_id
)
SELECT
    COUNT(*)              AS total_sessions,
    SUM(reached_product)  AS reached_product,
    SUM(reached_cart)     AS reached_cart,
    SUM(reached_shipping) AS reached_shipping,
    SUM(reached_billing)  AS reached_billing,
    SUM(reached_order)    AS reached_order
FROM session_flags;
