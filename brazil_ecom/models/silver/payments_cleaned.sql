{{
  config(
    materialized = 'view',
    )
}}


SELECT
    order_id,
    payment_sequential AS sequential,
    LOWER(TRANSLATE(
        payment_type,
        'Ã£Ã¡Ã¢Ã©ÃªÃ­Ã³Ã´ÃµÃ§ÃºÃ¼',
        'aaaeeeioooocuu'
    )) AS payment_type,
    payment_installments AS installments,
    payment_value AS payment_amount,
    current_timestamp AS _silver_loaded_at
FROM {{ ref('bronze_order_payments') }}
