{{
  config(
    materialized = 'view',
    )
}}


SELECT DISTINCT
  geolocation_zip_code_prefix AS zip_code_prefix,
  LOWER(TRANSLATE(geolocation_state,
    'Ã£Ã¡Ã¢Ã©ÃªÃ­Ã³Ã´ÃµÃ§ÃºÃ¼',
    'aaaeeeioooocuu'
  )) AS state
FROM {{ ref('bronze_geolocation') }}