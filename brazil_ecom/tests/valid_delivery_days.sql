SELECT
    *
FROM {{ ref('fct_sales') }}
WHERE delivery_days < 0