
SELECT
    product_id,
    TRIM(product_name) AS product_name,
    INITCAP(TRIM(category)) AS category,
    CAST(price AS NUMERIC(12,2)) AS price,
    CAST(cost AS NUMERIC(12,2)) AS cost

FROM {{ source('ecommerce', 'products') }}