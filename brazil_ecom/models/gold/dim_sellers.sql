{{
  config(
    materialized = 'table',
    )
}}

SELECT
    s.seller_id AS seller_id_nk,
    md5(s.seller_id) AS seller_sk,
    s.zip_code_prefix,
    s.state,
FROM {{ ref('sellers_cleaned') }} s
LEFT JOIN {{ ref('geolocation_cleaned') }} g
ON s.zip_code_prefix = g.zip_code_prefix
AND s.state = g.state