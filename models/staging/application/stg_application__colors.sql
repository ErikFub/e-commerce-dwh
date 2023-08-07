WITH source AS (
    SELECT *
    FROM {{ ref('colors_snapshot') }}
), 
renamed as (
    SELECT id,
        name,
        rgb AS hex_code,
        dbt_valid_from,
        dbt_valid_to
    FROM source
)

SELECT *
FROM renamed