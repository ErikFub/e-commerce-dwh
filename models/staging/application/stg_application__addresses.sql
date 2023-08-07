WITH source AS (
    SELECT *
    FROM {{ ref('addresses_snapshot') }}
), 
renamed as (
    SELECT id,
        firstname AS first_name,
        lastname AS last_name,
        CASE
            WHEN address1 IS NULL THEN NULL
            WHEN address2 IS NULL THEN address1
            ELSE CONCAT(address1, ', ', address2)
        END AS address,
        city,
        zip,
        created::TIMESTAMP AS created_at,
        updated::TIMESTAMP AS updated_at,
        dbt_valid_from,
        dbt_valid_to
    FROM source
)

SELECT *
FROM renamed