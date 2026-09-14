-- 02_rfm_and_repeat_customers.sql
--
-- Question: who are the highest-value customers, and how common is a
-- repeat customer on this platform in the first place?
--
-- customer_id is one per ORDER; customer_unique_id is one per real PERSON
-- (the same shopper gets a new customer_id every time they check out).
-- So "repeat customer" has to be measured on customer_unique_id, not
-- customer_id, or every customer would look like a one-time buyer by
-- definition.

WITH order_value AS (
    SELECT
        o.order_id,
        c.customer_unique_id,
        o.order_purchase_timestamp,
        SUM(oi.price + oi.freight_value) AS order_total
    FROM orders AS o
    JOIN customers AS c
        ON c.customer_id = o.customer_id
    JOIN order_items AS oi
        ON oi.order_id = o.order_id
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
    GROUP BY o.order_id, c.customer_unique_id, o.order_purchase_timestamp
),
rfm AS (
    SELECT
        customer_unique_id,
        COUNT(DISTINCT order_id)                          AS frequency,
        SUM(order_total)                                   AS monetary,
        DATEDIFF(
            (SELECT MAX(order_purchase_timestamp) FROM order_value),
            MAX(order_purchase_timestamp)
        ) AS recency_days
    FROM order_value
    GROUP BY customer_unique_id
)
SELECT
    CASE WHEN frequency = 1 THEN 'One-time (1 order)' ELSE 'Repeat (2+ orders)' END AS customer_type,
    COUNT(*)                                    AS customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_customers,
    ROUND(AVG(monetary), 2)                     AS avg_lifetime_value_brl,
    ROUND(SUM(monetary), 0)                     AS total_revenue_brl,
    ROUND(100.0 * SUM(monetary) / SUM(SUM(monetary)) OVER (), 1) AS pct_of_revenue
FROM rfm
GROUP BY customer_type;
