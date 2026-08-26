SELECT
    order_id,
    customer_id,
    CAST(order_date AS DATE) AS order_date,
    {{ clean_text('status') }} AS order_status

FROM {{ source('ecommerce', 'orders') }}