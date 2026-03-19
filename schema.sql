-- =========================================
-- E-COMMERCE DATABASE SCHEMA
-- =========================================

-- NOTE:
-- Run CREATE DATABASE separately if needed

-- =========================================
-- DROP EXISTING TABLES (SAFE RESET)
-- =========================================
DROP TABLE IF EXISTS olist_order_reviews_dataset;
DROP TABLE IF EXISTS olist_order_payments_dataset;
DROP TABLE IF EXISTS olist_order_items_dataset;
DROP TABLE IF EXISTS olist_orders_dataset;
DROP TABLE IF EXISTS olist_products_dataset;
DROP TABLE IF EXISTS olist_sellers_dataset;
DROP TABLE IF EXISTS olist_customers_dataset;
DROP TABLE IF EXISTS olist_geolocation_dataset;
DROP TABLE IF EXISTS product_category_name_translation;

-- =========================================
-- CUSTOMERS
-- =========================================
CREATE TABLE olist_customers_dataset (
    customer_id TEXT PRIMARY KEY,
    customer_unique_id TEXT NOT NULL,
    customer_zip_code_prefix INT,
    customer_city TEXT,
    customer_state TEXT
);

-- =========================================
-- GEOLOCATION
-- =========================================
CREATE TABLE olist_geolocation_dataset (
    geolocation_zip_code_prefix INT,
    geolocation_lat NUMERIC,
    geolocation_lng NUMERIC,
    geolocation_city TEXT,
    geolocation_state TEXT
);

-- =========================================
-- ORDERS
-- =========================================
CREATE TABLE olist_orders_dataset (
    order_id TEXT PRIMARY KEY,
    customer_id TEXT NOT NULL,
    order_status TEXT,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

-- =========================================
-- PRODUCTS
-- =========================================
CREATE TABLE olist_products_dataset (
    product_id TEXT PRIMARY KEY,
    product_category_name TEXT,
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- =========================================
-- SELLERS
-- =========================================
CREATE TABLE olist_sellers_dataset (
    seller_id TEXT PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city TEXT,
    seller_state TEXT
);

-- =========================================
-- ORDER ITEMS
-- =========================================
CREATE TABLE olist_order_items_dataset (
    order_id TEXT,
    order_item_id INT,
    product_id TEXT,
    seller_id TEXT,
    shipping_limit_date TIMESTAMP,
    price NUMERIC,
    freight_value NUMERIC,
    PRIMARY KEY (order_id, order_item_id)
);

-- =========================================
-- ORDER PAYMENTS
-- =========================================
CREATE TABLE olist_order_payments_dataset (
    order_id TEXT,
    payment_sequential INT,
    payment_type TEXT,
    payment_installments INT,
    payment_value NUMERIC,
    PRIMARY KEY (order_id, payment_sequential)
);

-- =========================================
-- ORDER REVIEWS
-- =========================================
CREATE TABLE olist_order_reviews_dataset (
    review_id TEXT PRIMARY KEY,
    order_id TEXT,
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

-- =========================================
-- CATEGORY TRANSLATION
-- =========================================
CREATE TABLE product_category_name_translation (
    product_category_name TEXT PRIMARY KEY,
    product_category_name_english TEXT
);

-- =========================================
-- FOREIGN KEYS
-- =========================================

ALTER TABLE olist_orders_dataset
ADD FOREIGN KEY (customer_id)
REFERENCES olist_customers_dataset(customer_id);

ALTER TABLE olist_order_items_dataset
ADD FOREIGN KEY (order_id)
REFERENCES olist_orders_dataset(order_id);

ALTER TABLE olist_order_items_dataset
ADD FOREIGN KEY (product_id)
REFERENCES olist_products_dataset(product_id);

ALTER TABLE olist_order_items_dataset
ADD FOREIGN KEY (seller_id)
REFERENCES olist_sellers_dataset(seller_id);

ALTER TABLE olist_order_payments_dataset
ADD FOREIGN KEY (order_id)
REFERENCES olist_orders_dataset(order_id);

ALTER TABLE olist_order_reviews_dataset
ADD FOREIGN KEY (order_id)
REFERENCES olist_orders_dataset(order_id);
