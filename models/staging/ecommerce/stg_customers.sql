

SELECT
    customer_id,
    first_name,
    last_name,
    {{ clean_text('email') }} AS email,
    INITCAP(TRIM(country)) AS country,
    signup_date

FROM {{ source('ecommerce', 'customers') }} /* instead of FROM raw.customers*/
