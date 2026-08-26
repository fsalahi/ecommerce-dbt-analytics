SELECT
    product_id,
    product_name,
    category,
    price,
    cost

FROM {{ ref('stg_products') }}