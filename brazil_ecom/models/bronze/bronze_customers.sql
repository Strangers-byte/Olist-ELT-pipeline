{{
  config(
    materialized = 'table'
    )
}}

SELECT 
    *,
    current_timestamp AS _bronze_loaded_at
FROM {{source('bronze', 'olist_customers_dataset')}}
