WITH date_range AS (

    SELECT
        MIN(order_date) AS min_date,
        MAX(order_date) AS max_date

    FROM {{ ref('stg_orders') }}

),

dates AS (

    SELECT
        generate_series(
            min_date,
            max_date,
            interval '1 day'
        )::date AS date_day

    FROM date_range

)

SELECT
    date_day AS date,

    EXTRACT(YEAR FROM date_day)::int AS year,

    EXTRACT(QUARTER FROM date_day)::int AS quarter,

    EXTRACT(MONTH FROM date_day)::int AS month,

    TO_CHAR(date_day, 'Month') AS month_name,

    EXTRACT(WEEK FROM date_day)::int AS week_of_year,

    EXTRACT(DOW FROM date_day)::int AS day_of_week,

    TO_CHAR(date_day, 'Day') AS day_name,

    CASE
        WHEN EXTRACT(DOW FROM date_day) IN (0, 6)
            THEN TRUE
        ELSE FALSE
    END AS is_weekend

FROM dates