-- 13_monthly_seasonality.sql
--
-- Question (CEO): is there a seasonal pattern to demand?

SELECT
    DATE_FORMAT(created_at, '%Y-%m') AS month,
    COUNT(*)                          AS orders,
    ROUND(SUM(price_usd), 2)          AS revenue_usd
FROM orders
GROUP BY
    DATE_FORMAT(created_at, '%Y-%m')
ORDER BY
    month;
