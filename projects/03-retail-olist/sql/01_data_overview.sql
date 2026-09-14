-- 01_data_overview.sql
--
-- Question: what does the order book actually look like before we trust
-- any downstream number? Row counts, order status mix, and date range.

SELECT
    order_status,
    COUNT(*) AS orders,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_orders,
    MIN(order_purchase_timestamp) AS first_order,
    MAX(order_purchase_timestamp) AS last_order
FROM orders
GROUP BY order_status
ORDER BY orders DESC;
