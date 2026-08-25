SELECT
    event_id,
    customer_id,
    CAST(event_timestamp AS TIMESTAMP) AS event_timestamp,
    LOWER(TRIM(event_type)) AS event_type,
    product_id

FROM {{ source('ecommerce', 'events') }}