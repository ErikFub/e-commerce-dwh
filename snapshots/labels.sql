{% snapshot labels_snapshot %}

{{
    config(
      target_database='ecommerce_dwh',
      target_schema='snapshots',
      unique_key='id',

      strategy='check',
      check_cols='all',
    )
}}

select *
from {{ source('application', 'labels') }}

{% endsnapshot %}