SELECT
    order_id,
    customer_id,
    CAST(order_date AS DATE) AS order_date,
    LOWER(TRIM(status)) AS order_status

FROM {{ source('ecommerce', 'orders') }}