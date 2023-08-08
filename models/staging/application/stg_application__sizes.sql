WITH source AS (
    SELECT *
    FROM {{ ref('sizes_snapshot') }}
), 
renamed as (
    SELECT id,
        gender,
        category,
        size,
        size_uk,
        size_us,
        size_eu,
        dbt_valid_from,
        dbt_valid_to
    FROM source
)

SELECT *
FROM renamed