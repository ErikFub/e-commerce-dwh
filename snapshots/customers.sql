{% snapshot customers_snapshot %}

{{
    config(
      target_database='ecommerce_dwh',
      target_schema='snapshots',
      unique_key='id',

      strategy='timestamp',
      updated_at='updated',
    )
}}

select * from {{ source('landing', 'customer') }}

{% endsnapshot %}