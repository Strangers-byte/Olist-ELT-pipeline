{{
  config(
    materialized = 'table',
    )
}}

SELECT
    *
FROM {{ ref('order_items_cleaned') }}