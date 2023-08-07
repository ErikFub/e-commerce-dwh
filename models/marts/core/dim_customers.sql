WITH customers AS (
    SELECT *
    FROM {{ ref('stg_maindb__customers') }}
)
SELECT c.id,
    c.first_name,
    c.last_name,
    c.gender,
    c.email,
    c.birth_date,
    c.address_id,
    c.created_at,
    c.updated_at,
    c.dbt_valid_from::TIMESTAMP AS valid_from,
    CASE
        WHEN c.dbt_valid_to IS NULL THEN '9999-12-31'::TIMESTAMP
        ELSE c.dbt_valid_to::TIMESTAMP
    END AS valid_to
FROM customers c