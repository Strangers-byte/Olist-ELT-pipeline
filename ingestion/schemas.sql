CREATE SCHEMA IF NOT EXISTS bronze;

CREATE TABLE IF NOT EXISTS bronze.olist_customers_dataset(
    customer_id VARCHAR(100), -- Primary Key
    customer_unique_id VARCHAR(100),
    customer_zip_code_prefix INTEGER,
    customer_city VARCHAR(50),
    customer_state CHAR(2),
    _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bronze.olist_geolocation_dataset(
    geolocation_zip_code_prefix INTEGER,
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(4),
    _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bronze.olist_order_items_dataset (
    order_id VARCHAR(100), -- Foreign key from orders table
    order_item_id INT,
    product_id VARCHAR(100), -- foreign key from product table
    seller_id VARCHAR(100), -- foreign key from seller table
    shipping_limit_date TIMESTAMP WITHOUT TIME ZONE,
    price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2),
    _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bronze.olist_order_payments_dataset (
    order_id VARCHAR(32),                -- Foreign key from orders table
    payment_sequential INTEGER,          
    payment_type VARCHAR(50),            
    payment_installments INTEGER,        
    payment_value DECIMAL(10, 2),        
    _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bronze.olist_order_reviews_dataset (
    review_id VARCHAR(32), -- Primary key
    order_id VARCHAR(32), -- Foreign key from orders table
    review_score INTEGER,                
    review_comment_title TEXT,           
    review_comment_message TEXT,         
    review_creation_date TIMESTAMP,      
    review_answer_timestamp TIMESTAMP,   
    _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bronze.olist_orders_dataset (
    order_id VARCHAR(32), -- Primary key
    customer_id VARCHAR(32), -- Foreign key from customers table
    order_status VARCHAR(50),            
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,         
    order_delivered_carrier_date TIMESTAMP, 
    order_delivered_customer_date TIMESTAMP, 
    order_estimated_delivery_date TIMESTAMP,
    _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bronze.olist_products_dataset (
    product_id VARCHAR(32), -- Primary Key
    product_category_name VARCHAR(100),
    product_name_length INTEGER,          
    product_description_length INTEGER,   
    product_photos_qty INTEGER,
    product_weight_g INTEGER,             
    product_length_cm DECIMAL(8, 2),      
    product_height_cm DECIMAL(8, 2),      
    product_width_cm DECIMAL(8, 2),       
    _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bronze.olist_sellers_dataset (
    seller_id VARCHAR(32), -- Primary Key
    seller_zip_code_prefix VARCHAR(10),   
    seller_city VARCHAR(100),
    seller_state CHAR(2),                 
    _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bronze.product_category_name_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100),
    _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);