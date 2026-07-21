{{
  config(
    materialized = 'view',
    )
}}

WITH translated AS (
    SELECT
        p.product_id,
        t.product_category_name_english,
        p.product_weight_g,
        p.product_length_cm,
        p.product_height_cm,
        p.product_width_cm
    FROM {{ ref('bronze_products') }} p
    LEFT JOIN {{ ref('bronze_product_category_english') }} t
        ON p.product_category_name = t.product_category_name
)

SELECT
    product_id,
    LOWER(COALESCE(product_category_name_english, 'unknown')) AS category,
    product_weight_g AS weight_g,
    product_length_cm AS length_cm,
    product_height_cm AS height_cm,
    product_width_cm AS width_cm,
    current_timestamp AS _silver_loaded_at
FROM translated