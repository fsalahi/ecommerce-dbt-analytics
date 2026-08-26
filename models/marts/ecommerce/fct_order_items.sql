SELECT
    order_item_id,
    order_id,
    product_id,

    quantity,
    unit_price,
    cost,

    revenue,
    product_cost,
    gross_profit

FROM {{ ref('int_order_items_enriched') }}