{% set table_pairs = [
    ('bronze_customers', 'olist_customers_dataset'),
    ('bronze_orders', 'olist_orders_dataset'),
    ('bronze_order_items', 'olist_order_items_dataset'),
    ('bronze_order_payments', 'olist_order_payments_dataset'),
    ('bronze_order_reviews', 'olist_order_reviews_dataset'),
    ('bronze_products', 'olist_products_dataset'),
    ('bronze_sellers', 'olist_sellers_dataset'),
    ('bronze_geolocation', 'olist_geolocation_dataset')
]%}

with counts as (
    {% for bronze, src_table in table_pairs %}
    select
        '{{ bronze }}' as table_name,
        (select count(*) from {{ ref(bronze) }}) as bronze_count,
        (select count(*) from {{ source('bronze', src_table) }}) as source_count
    {% if not loop.last %} union all {% endif %}
    {% endfor %}
)

SELECT
    *
FROM counts
WHERE bronze_count != source_count