{{
  config(
    materialized = 'table',
    )
}}

SELECT
    *,
    current_timestamp as _bronze_loaded_at
FROM {{ source('bronze', 'olist_geolocation_dataset') }}