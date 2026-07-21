{{
  config(
    materialized = 'table',
    )
}}

SELECT
    *
FROM {{ ref('reviews_cleaned') }}