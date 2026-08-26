WITH customers AS (

    SELECT *
    FROM {{ ref('stg_customers') }}

),

customer_orders AS (

    SELECT *
    FROM {{ ref('int_customer_orders') }}

),

customer_summary AS (

    SELECT
        customer_id,

        MIN(order_date) AS first_order_date,
        MAX(order_date) AS most_recent_order_date,
        COUNT(order_id) AS total_orders,
        SUM(order_revenue) AS total_revenue,
        SUM(order_gross_profit) AS total_profit

    FROM customer_orders

    GROUP BY customer_id

)

SELECT
    c.customer_id,

    c.first_name,
    c.last_name,
    c.email,
    c.country,
    c.signup_date,

    cs.first_order_date,
    cs.most_recent_order_date,
    COALESCE(cs.total_orders, 0) AS total_orders,
    COALESCE(cs.total_revenue, 0) AS total_revenue,
    COALESCE(cs.total_profit, 0) AS total_profit

FROM customers c

LEFT JOIN customer_summary cs
    ON c.customer_id = cs.customer_id