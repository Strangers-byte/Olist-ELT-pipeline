{{
  config(
    materialized = 'table',
    )
}}

SELECT
    *,
    current_timestamp AS _bronze_loaded_at
FROM {{ source('bronze', 'olist_order_payments_dataset') }}