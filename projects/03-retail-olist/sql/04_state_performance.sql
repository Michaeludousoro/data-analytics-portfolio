-- 04_state_performance.sql
--
-- Question (Ops / Expansion): which Brazilian states have the best and
-- worst delivery and satisfaction experience, and where is the revenue
-- actually coming from?

SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id)                                   AS orders,
    ROUND(SUM(oi.price + oi.freight_value), 0)                   AS revenue_brl,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 1) AS avg_delivery_days,
    ROUND(AVG(r.review_score), 2)                                AS avg_review_score
FROM orders AS o
JOIN customers AS c
    ON c.customer_id = o.customer_id
JOIN order_items AS oi
    ON oi.order_id = o.order_id
LEFT JOIN order_reviews AS r
    ON r.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
HAVING orders >= 30            -- drop states with too few orders to read the average meaningfully
ORDER BY orders DESC;
