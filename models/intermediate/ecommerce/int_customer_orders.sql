
WITH orders AS (

    SELECT *
    FROM {{ ref('int_orders_enriched') }}

),

order_items AS (

    SELECT *
    FROM {{ ref('int_order_items_enriched') }}

),

order_totals AS (

    SELECT
        order_id,
        SUM(revenue) AS order_revenue,
        SUM(product_cost) AS order_cost,
        SUM(gross_profit) AS order_gross_profit

    FROM order_items

    GROUP BY order_id

),

customer_order_sequence AS (

    SELECT
        o.*,

        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id
            ORDER BY o.order_date, o.order_id
        ) AS customer_order_number

    FROM orders o

)

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status,

    o.first_name,
    o.last_name,
    o.email,
    o.country,
    o.signup_date,

    o.customer_order_number,

    COALESCE(ot.order_revenue, 0) AS order_revenue,
    COALESCE(ot.order_cost, 0) AS order_cost,
    COALESCE(ot.order_gross_profit, 0) AS order_gross_profit,
    CASE
    WHEN customer_order_number = 1
        THEN 'new_customer_order'

    ELSE 'repeat_customer_order'

END AS order_type

FROM customer_order_sequence o

LEFT JOIN order_totals ot
    ON o.order_id = ot.order_id