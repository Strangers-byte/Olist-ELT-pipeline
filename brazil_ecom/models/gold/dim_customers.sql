{{
  config(
    materialized = 'table',
    )
}}

SELECT
    md5(c.customer_unique_id) AS customer_sk,
    c.customer_unique_id,
    c.zip_code_prefix,
    c.state
FROM {{ ref('only_customers') }} c
LEFT JOIN {{ ref('geolocation_cleaned') }} g
ON c.zip_code_prefix = g.zip_code_prefix 
AND c.state = g.state
