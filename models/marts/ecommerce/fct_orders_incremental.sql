{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

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

{% if is_incremental() %}

WHERE order_date >= (
    SELECT MAX(order_date)
    FROM {{ this }} --Look at the version of this model that already exists in the database.
)

{% endif %}