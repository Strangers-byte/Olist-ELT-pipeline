{{
  config(
    materialized = 'table',
    )
}}

SELECT
    md5(product_id) AS product_sk,
    *
FROM {{ ref('products_cleaned') }}