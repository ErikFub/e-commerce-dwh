{% snapshot products_snapshot %}

{{
    config(
      target_database='ecommerce_dwh',
      target_schema='snapshots',
      unique_key='id',

      strategy='timestamp',
      updated_at='updated_at_for_snapshot',
    )
}}

select 
  *,
  coalesce(updated, created) as updated_at_for_snapshot 
from {{ source('landing', 'products') }}

{% endsnapshot %}