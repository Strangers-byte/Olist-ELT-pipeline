{{
  config(
    materialized = 'view',
    )
}}

SELECT
    order_id,
    order_item_id AS item_sequence,
    product_id,
    seller_id,
    shipping_limit_date AS shipping_limit_at,
    price,
    freight_value,
    current_timestamp AS _silver_loaded_at
FROM {{ ref('bronze_order_items') }}

{# CREATE TABLE IF NOT EXISTS bronze.order_items(
    order_id VARCHAR(100), -- Foreign key from orders table
    item_sequence INT,
    product_id VARCHAR(100), -- foreign key from product table
    seller_id VARCHAR(100), -- foreign key from seller table
    shipping_limit_at TIMESTAMP WITHOUT TIME ZONE,
    price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2),
    _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); #}

