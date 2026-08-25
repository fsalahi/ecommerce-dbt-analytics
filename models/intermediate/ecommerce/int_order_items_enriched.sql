WITH order_items AS (

    SELECT *
    FROM {{ ref('stg_order_items') }}

),

products AS (

    SELECT *
    FROM {{ ref('stg_products') }}

)

SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,

    p.product_name,
    p.category,

    oi.quantity,
    oi.unit_price,
    p.cost,

    oi.quantity * oi.unit_price AS revenue,

    oi.quantity * p.cost AS product_cost,

    oi.quantity * (
        oi.unit_price - p.cost
    ) AS gross_profit

FROM order_items oi

LEFT JOIN products p
    ON oi.product_id = p.product_id