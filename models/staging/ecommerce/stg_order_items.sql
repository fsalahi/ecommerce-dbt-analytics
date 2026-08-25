SELECT
    order_item_id,
    order_id,
    product_id,
    quantity,
    CAST(unit_price AS NUMERIC(12,2)) AS unit_price

FROM {{ source('ecommerce', 'order_items') }}