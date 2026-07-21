SELECT
    o.order_id
FROM {{ ref('fct_orders') }} o
LEFT JOIN {{ ref('dim_customers') }} c
    ON o.customer_unique_id = c.customer_unique_id
WHERE c.customer_unique_id IS NULL