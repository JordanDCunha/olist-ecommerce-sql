-- =========================================
-- LOAD CSV DATA INTO TABLES
-- =========================================

-- NOTE:
-- Place all CSV files inside a /data folder in the project root

-- =========================================
-- CUSTOMERS
-- =========================================
COPY olist_customers_dataset
FROM 'data/olist_customers_dataset.csv'
DELIMITER ','
CSV HEADER;

-- =========================================
-- GEOLOCATION
-- =========================================
COPY olist_geolocation_dataset
FROM 'data/olist_geolocation_dataset.csv'
DELIMITER ','
CSV HEADER;

-- =========================================
-- ORDERS
-- =========================================
COPY olist_orders_dataset
FROM 'data/olist_orders_dataset.csv'
DELIMITER ','
CSV HEADER;

-- =========================================
-- PRODUCTS
-- =========================================
COPY olist_products_dataset
FROM 'data/olist_products_dataset.csv'
DELIMITER ','
CSV HEADER;

-- =========================================
-- SELLERS
-- =========================================
COPY olist_sellers_dataset
FROM 'data/olist_sellers_dataset.csv'
DELIMITER ','
CSV HEADER;

-- =========================================
-- ORDER ITEMS
-- =========================================
COPY olist_order_items_dataset
FROM 'data/olist_order_items_dataset.csv'
DELIMITER ','
CSV HEADER;

-- =========================================
-- PAYMENTS
-- =========================================
COPY olist_order_payments_dataset
FROM 'data/olist_order_payments_dataset.csv'
DELIMITER ','
CSV HEADER;

-- =========================================
-- REVIEWS
-- =========================================
COPY olist_order_reviews_dataset
FROM 'data/olist_order_reviews_dataset.csv'
DELIMITER ','
CSV HEADER;

-- =========================================
-- CATEGORY TRANSLATION
-- =========================================
COPY product_category_name_translation
FROM 'data/product_category_name_translation.csv'
DELIMITER ','
CSV HEADER;
