WITH source AS (
    SELECT *
    FROM {{ ref('customers_snapshot') }}
), renamed as (
    SELECT id,
        firstname AS first_name,
        lastname AS last_name,
        gender,
        email,
        dateofbirth AS birth_date,
        currentaddressid AS address_id,
        created::TIMESTAMP AS created_at,
        updated::TIMESTAMP AS updated_at,
        dbt_valid_from,
        dbt_valid_to
    FROM source
)
SELECT *
FROM renamed