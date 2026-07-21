{{
  config(
    materialized = 'table',
    )
}}

SELECT
    o.order_id,
    o.customer_id,
    dc.customer_unique_id,
    o.status,
    o.purchased_at,
    o.delivered_customer_at,
    o.estimated_delivery_at,
    oi.item_sequence,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    p.payment_type,
    p.installments,
    p.payment_amount,
    r.score,
    -- Pre‑calculated convenience columns
    CAST(strftime(o.purchased_at, '%Y%m%d') AS INTEGER) AS purchase_date_key,
    DATEDIFF('day', o.purchased_at, o.delivered_customer_at) AS delivery_days,
    CASE WHEN o.delivered_customer_at <= o.estimated_delivery_at THEN 'On Time' ELSE 'Late' END AS delivery_status,
    oi.price + oi.freight_value AS total_item_value
FROM {{ ref('fct_orders') }} o
JOIN {{ ref('fct_order_items') }} oi ON o.order_id = oi.order_id
LEFT JOIN {{ ref('dim_customers') }} dc ON o.customer_unique_id = dc.customer_unique_id
LEFT JOIN {{ ref('fct_payments') }} p ON o.order_id = p.order_id AND p.sequential = 1 -- First payment row
LEFT JOIN (
  SELECT
    order_id,
    score,
    ROW_NUMBER() OVER (
      PARTITION BY order_id
      ORDER BY created_at ASC
    ) AS rn
  FROM {{ ref('fct_reviews') }}
) r ON o.order_id = r.order_id AND r.rn = 1


