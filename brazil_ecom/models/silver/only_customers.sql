{{
  config(
    materialized = 'view',
    )
}}


WITH dedup AS (
  SELECT
    customer_unique_id,
    customer_zip_code_prefix AS zip_code_prefix,
    customer_state AS state,
    ROW_NUMBER() OVER(
      PARTITION BY customer_unique_id
      ORDER BY customer_id
    ) AS rn
  FROM {{ ref('bronze_customers') }}
)
SELECT
  customer_unique_id,
  zip_code_prefix,
  state,
FROM dedup
WHERE rn = 1