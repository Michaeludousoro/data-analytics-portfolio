-- 12_product_launches.sql
--
-- Question (CEO): how has each product performed since its launch?

SELECT
    p.product_name,
    MIN(o.created_at)          AS first_order_date,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(o.price_usd), 2) AS revenue_usd
FROM orders AS o
JOIN products AS p
    ON p.product_id = o.primary_product_id
GROUP BY
    p.product_name
ORDER BY
    first_order_date;
