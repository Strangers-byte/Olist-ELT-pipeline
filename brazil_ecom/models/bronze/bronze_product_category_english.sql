{{
  config(
    materialized = 'table',
    )
}}

SELECT
    *,
    current_timestamp AS _bronze_loaded_at
FROM {{ source('bronze', 'product_category_name_translation') }}