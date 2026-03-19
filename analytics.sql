-- =========================================
-- E-COMMERCE ANALYTICS QUERIES
-- =========================================

-- This file contains business-focused SQL analysis
-- using transformed / enriched datasets


-- =========================================
-- 1. MONTHLY REVENUE TREND
-- =========================================
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM daily_revenue
GROUP BY month
ORDER BY month;


-- =========================================
-- 2. TOP 10 PRODUCT CATEGORIES BY SALES
-- =========================================
SELECT 
    pe.category,
    COUNT(*) AS total_sales
FROM olist_order_items_dataset oi
JOIN products_enriched pe
    ON oi.product_id = pe.product_id
GROUP BY pe.category
ORDER BY total_sales DESC
LIMIT 10;


-- =========================================
-- 3. AVERAGE DELIVERY TIME (DAYS)
-- =========================================
SELECT 
    ROUND(AVG(delivery_time), 2) AS avg_delivery_days
FROM orders_with_delivery_time;


-- =========================================
-- 4. TOP 10 CUSTOMERS BY LIFETIME VALUE
-- =========================================
SELECT 
    customer_unique_id,
    ROUND(total_spent, 2) AS total_spent
FROM customer_ltv
ORDER BY total_spent DESC
LIMIT 10;


-- =========================================
-- 5. REVENUE BY STATE
-- =========================================
SELECT 
    customer_state,
    ROUND(SUM(total_order_value), 2) AS revenue
FROM enriched_orders
GROUP BY customer_state
ORDER BY revenue DESC;


-- =========================================
-- 6. AVERAGE ORDER VALUE (AOV)
-- =========================================
SELECT 
    ROUND(AVG(total_order_value), 2) AS avg_order_value
FROM order_value;


-- =========================================
-- 7. ORDERS BY HOUR (PEAK TIMES)
-- =========================================
SELECT 
    EXTRACT(HOUR FROM order_purchase_timestamp) AS hour,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY hour
ORDER BY hour;


-- =========================================
-- 8. REPEAT VS ONE-TIME CUSTOMERS
-- =========================================
SELECT
    CASE 
        WHEN total_orders = 1 THEN 'One-time'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(*) AS num_customers
FROM customer_ltv
GROUP BY customer_type;


-- =========================================
-- 9. TOP SELLERS BY REVENUE
-- =========================================
SELECT 
    oi.seller_id,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS seller_revenue
FROM olist_order_items_dataset oi
GROUP BY oi.seller_id
ORDER BY seller_revenue DESC
LIMIT 10;


-- =========================================
-- 10. COHORT RETENTION (BASIC)
-- =========================================
SELECT
    cohort_month,
    order_month,
    COUNT(DISTINCT customer_unique_id) AS active_customers
FROM customer_cohorts
GROUP BY cohort_month, order_month
ORDER BY cohort_month, order_month;


-- =========================================
-- 11. RANK TOP PRODUCTS (WINDOW FUNCTION)
-- =========================================
SELECT
    p.product_id,
    COUNT(*) AS total_orders,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY rank
LIMIT 10;


-- =========================================
-- 12. RUNNING TOTAL REVENUE (WINDOW FUNCTION)
-- =========================================
SELECT
    order_date,
    SUM(revenue) AS daily_revenue,
    SUM(SUM(revenue)) OVER (ORDER BY order_date) AS cumulative_revenue
FROM daily_revenue
GROUP BY order_date
ORDER BY order_date;
