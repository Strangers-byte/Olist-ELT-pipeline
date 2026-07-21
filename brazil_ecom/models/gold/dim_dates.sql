{{
  config(
    materialized = 'table',
    )
}}

WITH date_range AS (
    SELECT 
        MIN(purchased_at) AS start_date,
        MAX(purchased_at) AS end_date
    FROM {{ ref('fct_orders') }}
),
date_series AS(
    SELECT unnest(generate_series(
        (SELECT start_date FROM date_range),
        (SELECT end_date FROM date_range),
        INTERVAL 1 day
    )) AS date_day
)
SELECT 
    CAST(strftime(date_day, '%Y%m%d') AS INTEGER) AS date_key,
    date_day,
    EXTRACT(year FROM date_day) AS year,
    EXTRACT(quarter FROM date_day) AS quarter,
    EXTRACT(month FROM date_day) AS month,
    EXTRACT(day FROM date_day) AS day,
    EXTRACT(DOW FROM date_day) AS day_of_week,
    EXTRACT(ISODOW FROM date_day) AS iso_day_of_week,
    CASE WHEN EXTRACT(DOW FROM date_day) IN (0, 6) THEN true ELSE false END AS is_weekend
FROM date_series