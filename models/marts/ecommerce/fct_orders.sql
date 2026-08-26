SELECT
    order_id,
    customer_id,
    order_date,

    order_status,

    order_revenue,
    order_cost,
    order_gross_profit,

    customer_order_number,
    order_type

FROM {{ ref('int_customer_orders') }}