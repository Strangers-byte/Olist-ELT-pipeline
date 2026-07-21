{{
  config(
    materialized = 'view',
    )
}}

SELECT
    order_id,
    customer_id,
    LOWER(order_status) AS status,
    order_purchase_timestamp AS purchased_at,
    order_approved_at AS approved_at,
    order_delivered_carrier_date AS delivered_carrier_at,
    order_delivered_customer_date AS delivered_customer_at,
    order_estimated_delivery_date AS estimated_delivery_at,
    current_timestamp AS _silver_loaded_at
FROM {{ ref('bronze_orders') }}



{# 
CREATE TABLE IF NOT EXISTS bronze.orders (
    order_id VARCHAR(32), -- Primary key
    customer_id VARCHAR(32), -- Foreign key from customers table
    status VARCHAR(50),            
    purchase_at TIMESTAMP,
    approved_at TIMESTAMP,         
    delivered_carrier_at TIMESTAMP, 
    delivered_customer_at TIMESTAMP, 
    estimated_delivery_at TIMESTAMP,
    _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); #}

