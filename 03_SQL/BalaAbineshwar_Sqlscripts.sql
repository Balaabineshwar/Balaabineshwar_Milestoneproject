CREATE DATABASE olist_ecommerce;

USE olist_ecommerce;

CREATE TABLE customers (
    customer_id VARCHAR(100),
    customer_unique_id VARCHAR(100),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

CREATE TABLE orders (
    order_id VARCHAR(32),
    customer_id VARCHAR(32),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

CREATE TABLE order_items (
    order_id VARCHAR(32),
    order_item_id INT,
    product_id VARCHAR(32),
    seller_id VARCHAR(32),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);


CREATE TABLE products (
    product_id VARCHAR(32),
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

CREATE TABLE payments (
    order_id VARCHAR(32),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);

CREATE TABLE reviews (
    review_id VARCHAR(32),
    order_id VARCHAR(32),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

CREATE TABLE sellers (
    seller_id VARCHAR(32),
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);

SHOW TABLES;

select count(*) from customers
select count(*) from order_items
select count(*) from orders
select count(*) from payments 
select count(*) from products
select count(*) from reviews 
select count(*) from sellers 

-- 1 Order Status Distribution
SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

-- 2 Payment Type Distribution

SELECT
    payment_type,
    COUNT(*) AS payment_count,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;

-- 3 Overall Sales Performance

SELECT
    ROUND(SUM(price), 2) AS total_revenue,
    COUNT(DISTINCT order_id) AS unique_orders,
    ROUND(SUM(price) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM order_items;

-- 4 Customer Distribution by State

SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers
GROUP BY customer_state
ORDER BY unique_customers DESC;

-- 5 Revenue by Product Category

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY total_revenue DESC;


-- 6 Top 10 Sellers by Revenue

SELECT
    oi.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS unique_orders,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN sellers s
    ON oi.seller_id = s.seller_id
GROUP BY
    oi.seller_id,
    s.seller_city,
    s.seller_state
ORDER BY total_revenue DESC
LIMIT 10;

-- 7 Seller Distribution by State

SELECT
    seller_state,
    COUNT(DISTINCT seller_id) AS seller_count
FROM sellers
GROUP BY seller_state
ORDER BY seller_count DESC;

-- 8 Top 3 Products Within Each Category

WITH ranked_products AS (
    SELECT
        p.product_category_name,
        oi.product_id,
        SUM(oi.price) AS total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY p.product_category_name 
            ORDER BY SUM(oi.price) DESC
        ) AS product_rank
    FROM order_items oi
    JOIN products p 
        ON oi.product_id = p.product_id
    WHERE p.product_category_name IS NOT NULL
    GROUP BY 
        p.product_category_name, 
        oi.product_id
)
SELECT
    product_category_name,
    product_id,
    ROUND(total_revenue, 2) AS total_revenue,
    product_rank
FROM ranked_products
WHERE product_rank <= 3
ORDER BY 
    product_category_name, 
    product_rank;