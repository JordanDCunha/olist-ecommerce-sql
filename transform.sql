-- =========================================
-- DATA TRANSFORMATION & FEATURE ENGINEERING
-- =========================================

-- This file prepares raw data for analytics
-- Includes cleaning, derived columns, and views


-- =========================================
-- 1. CLEAN ORDERS TABLE (REMOVE NULL DATES)
-- =========================================
CREATE OR REPLACE VIEW clean_orders AS
SELECT *
FROM olist_orders_dataset
WHERE order_purchase_timestamp IS NOT NULL;


-- =========================================
-- 2. ADD DELIVERY TIME (IN DAYS)
-- =========================================
CREATE OR REPLACE VIEW orders_with_delivery_time AS
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_delivered_customer_date,
    
    -- Delivery time in days
    (order_delivered_customer_date - order_purchase_timestamp) AS delivery_time
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL;


-- =========================================
-- 3. ORDER VALUE (TOTAL SPENT PER ORDER)
-- =========================================
CREATE OR REPLACE VIEW order_value AS
SELECT
    order_id,
    SUM(payment_value) AS total_order_value
FROM olist_order_payments_dataset
GROUP BY order_id;


-- =========================================
-- 4. ENRICHED ORDER DATA (JOIN EVERYTHING)
-- =========================================
CREATE OR REPLACE VIEW enriched_orders AS
SELECT
    o.order_id,
    o.customer_id,
    c.customer_state,
    o.order_purchase_timestamp,
    ov.total_order_value
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
JOIN order_value ov
    ON o.order_id = ov.order_id;


-- =========================================
-- 5. PRODUCT CATEGORY (TRANSLATED)
-- =========================================
CREATE OR REPLACE VIEW products_enriched AS
SELECT
    p.product_id,
    t.product_category_name_english AS category
FROM olist_products_dataset p
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name;


-- =========================================
-- 6. DAILY REVENUE TABLE
-- =========================================
CREATE OR REPLACE VIEW daily_revenue AS
SELECT
    DATE(o.order_purchase_timestamp) AS order_date,
    SUM(p.payment_value) AS revenue
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p
    ON o.order_id = p.order_id
GROUP BY order_date
ORDER BY order_date;


-- =========================================
-- 7. CUSTOMER LIFETIME VALUE (CLV TABLE)
-- =========================================
CREATE OR REPLACE VIEW customer_ltv AS
SELECT
    c.customer_unique_id,
    COUNT(o.order_id) AS total_orders,
    SUM(p.payment_value) AS total_spent,
    AVG(p.payment_value) AS avg_order_value
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
    ON c.customer_id = o.customer_id
JOIN olist_order_payments_dataset p
    ON o.order_id = p.order_id
GROUP BY c.customer_unique_id;


-- =========================================
-- 8. RETENTION / COHORT PREP (MONTHLY)
-- =========================================
CREATE OR REPLACE VIEW customer_cohorts AS
SELECT
    c.customer_unique_id,
    DATE_TRUNC('month', MIN(o.order_purchase_timestamp)) AS cohort_month,
    DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id, order_month;
