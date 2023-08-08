WITH source AS (
    SELECT *
    FROM {{ ref('labels_snapshot') }}
), 
renamed as (
    SELECT id,
        name,
        slugname AS slug,
        icon,
        dbt_valid_from,
        dbt_valid_to
    FROM source
)

SELECT *
FROM renamed