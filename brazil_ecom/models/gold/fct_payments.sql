{{
  config(
    materialized = 'table',
    )
}}

SELECT
    *
FROM {{ ref('payments_cleaned') }}