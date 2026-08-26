SELECT
    customer_id,

    MAX(first_name) AS first_name,
    MAX(last_name) AS last_name,
    MAX(email) AS email,
    MAX(country) AS country,

    MIN(order_date) AS first_order_date,
    MAX(order_date) AS most_recent_order_date,

    COUNT(order_id) AS total_orders,

    SUM(order_revenue) AS total_revenue,

    SUM(order_gross_profit) AS total_gross_profit,

    AVG(order_revenue) AS average_order_value,

    SUM(
        CASE
            WHEN order_type = 'repeat_customer_order'
            THEN 1
            ELSE 0
        END
    ) AS repeat_orders

FROM {{ ref('int_customer_orders') }}

GROUP BY customer_id