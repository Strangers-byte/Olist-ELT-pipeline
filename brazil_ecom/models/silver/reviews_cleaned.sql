{{
  config(
    materialized = 'view',
    )
}}

{# SELECT
    review_id,
    order_id,
    review_score AS score,
    review_creation_date AS created_at,
    review_answer_timestamp AS answered_at,
    current_timestamp AS _silver_loaded_at
FROM {{ ref('bronze_order_reviews') }} #}


with dedup as (
    select
        review_id,
        order_id,
        review_score as score,
        review_creation_date as created_at,
        review_answer_timestamp as answered_at,
        row_number() over (
            partition by review_id
            order by order_id   -- picks the first order_id alphabetically
        ) as rn
    from {{ ref('bronze_order_reviews') }}
)
select
    review_id,
    order_id,
    score,
    created_at,
    answered_at,
    current_timestamp as _silver_loaded_at
from dedup
where rn = 1

{#
    Data Quality Note:
    Some review_id values appear with multiple order_id values in the source data.
    The review content (score, text, dates) is identical across the duplicates,
    indicating a source-level error where a single review was incorrectly linked
    to multiple orders. We deduplicate by keeping the row with the smallest
    order_id (lexicographically) to ensure a stable, unique mapping.
#}