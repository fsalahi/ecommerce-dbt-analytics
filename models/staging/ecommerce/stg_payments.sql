SELECT
    payment_id,
    order_id,
    CAST(payment_date AS DATE) AS payment_date,
    CAST(amount AS NUMERIC(12,2)) AS amount,
    LOWER(TRIM(payment_method)) AS payment_method,
    LOWER(TRIM(payment_status)) AS payment_status

FROM {{ source('ecommerce', 'payments') }}