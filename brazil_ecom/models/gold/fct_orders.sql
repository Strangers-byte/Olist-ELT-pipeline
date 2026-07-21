{{
  config(
    materialized = 'table',
    )
}}

SELECT 
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    LOWER(o.status) AS status,
    o.purchased_at,
    o.approved_at,
    o.delivered_carrier_at,
    o.delivered_customer_at,
    o.estimated_delivery_at,
FROM {{ ref('orders_cleaned') }} o
LEFT JOIN {{ ref('customers_cleaned') }} c
  ON o.customer_id = c.customer_id