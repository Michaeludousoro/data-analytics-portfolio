-- 06_tableau_export.sql
--
-- Builds the data source for the future Tableau dashboard: one row per
-- (month, state, category), with order counts, revenue, delivery days,
-- and review score, small enough to commit and rich enough to slice by
-- any of those three dimensions in Tableau.

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01') AS month,
    c.customer_state                                     AS state,
    COALESCE(t.product_category_name_english, p.product_category_name, '(unknown)') AS category,

    COUNT(DISTINCT o.order_id)                           AS orders,
    ROUND(SUM(oi.price + oi.freight_value), 2)           AS revenue_brl,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 1) AS avg_delivery_days,
    ROUND(AVG(r.review_score), 2)                        AS avg_review_score

FROM orders AS o
JOIN customers AS c
    ON c.customer_id = o.customer_id
JOIN order_items AS oi
    ON oi.order_id = o.order_id
JOIN products AS p
    ON p.product_id = oi.product_id
LEFT JOIN product_category_translation AS t
    ON t.product_category_name = p.product_category_name
LEFT JOIN order_reviews AS r
    ON r.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01'),
    c.customer_state,
    category
ORDER BY
    month;
