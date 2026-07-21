{{
  config(
    materialized = 'view',
    )
}}

SELECT
    seller_id,
    seller_zip_code_prefix AS zip_code_prefix,
    LOWER(TRANSLATE(
        seller_state,
        'Ã£Ã¡Ã¢Ã©ÃªÃ­Ã³Ã´ÃµÃ§ÃºÃ¼',
        'aaaeeeioooocuu'
    )) AS state,
    current_timestamp AS _silver_loaded_at
FROM {{ ref('bronze_sellers') }}
{# 
CREATE TABLE IF NOT EXISTS bronze.sellers (
    seller_id VARCHAR(32), -- Primary Key
    zip_code_prefix VARCHAR(10), -- foreign key from geolocation  
    city VARCHAR(100), -- foreign key from geolocation
    state CHAR(2), -- foreign key from geolocation
    _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); #}