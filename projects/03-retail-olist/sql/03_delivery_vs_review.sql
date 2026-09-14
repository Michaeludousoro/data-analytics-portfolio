-- 03_delivery_vs_review.sql
--
-- Question (Operations): does a late delivery actually hurt the review
-- score, and by how much?
--
-- "Late" is measured against Olist's own promise to the customer
-- (order_estimated_delivery_date), not some fixed number of days, since a
-- promise of 20 days kept is a different experience to a promise of 5 days
-- kept.

SELECT
    CASE
        WHEN o.order_delivered_customer_date IS NULL THEN 'Never delivered'
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Late'
        ELSE 'On time or early'
    END AS delivery_outcome,
    COUNT(DISTINCT o.order_id)     AS orders,
    ROUND(AVG(r.review_score), 2)  AS avg_review_score,
    ROUND(100.0 * SUM(CASE WHEN r.review_score <= 2 THEN 1 ELSE 0 END) / COUNT(r.review_score), 1) AS pct_1_or_2_star
FROM orders AS o
JOIN order_reviews AS r
    ON r.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY delivery_outcome
ORDER BY avg_review_score;
