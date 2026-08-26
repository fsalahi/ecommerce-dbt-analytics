{% snapshot customers_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='customer_id',
        strategy='check',
        check_cols=[
            'first_name',
            'last_name',
            'email',
            'country'
        ]
    )
}}

SELECT
    customer_id,
    first_name,
    last_name,
    email,
    country,
    signup_date

FROM {{ source('ecommerce', 'customers') }}

{% endsnapshot %}