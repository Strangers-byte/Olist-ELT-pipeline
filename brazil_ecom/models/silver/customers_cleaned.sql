{{
  config(
    materialized = 'view',
    )
}}

SELECT 
  customer_id,
  customer_unique_id,
  customer_zip_code_prefix AS zip_code_prefix,
  LOWER(TRANSLATE(customer_state,
    'Ã£Ã¡Ã¢Ã©ÃªÃ­Ã³Ã´ÃµÃ§ÃºÃ¼',
    'aaaeeeioooocuu'
  )) AS state,
  current_timestamp AS _silver_loaded_at
FROM {{ ref('bronze_customers') }}