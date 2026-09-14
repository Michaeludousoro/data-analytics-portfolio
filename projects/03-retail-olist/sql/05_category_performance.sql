-- 05_category_performance.sql
--
-- Question (Category Manager): which product categories actually drive
-- revenue, and do any big categories have a quality problem (low review
-- scores despite high sales)?

SELECT
    COALESCE(t.product_category_name_english, p.product_category_name, '(unknown)') AS category,
    COUNT(DISTINCT oi.order_id)                 AS orders,
    ROUND(SUM(oi.price), 0)                      AS revenue_brl,
    ROUND(AVG(r.review_score), 2)                AS avg_review_score
FROM order_items AS oi
JOIN products AS p
    ON p.product_id = oi.product_id
LEFT JOIN product_category_translation AS t
    ON t.product_category_name = p.product_category_name
JOIN orders AS o
    ON o.order_id = oi.order_id AND o.order_status = 'delivered'
LEFT JOIN order_reviews AS r
    ON r.order_id = oi.order_id
GROUP BY category
HAVING orders >= 100
ORDER BY revenue_brl DESC
LIMIT 15;
