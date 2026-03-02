with source as (
    select * from {{ ref('hubspot_org') }}
),

renamed as (
    select
        cast(company_id as bigint) as company_id,
        cast(company_name as varchar) as company_name,
        lower(trim(cast(domain as varchar))) as domain,
        cast(industry as varchar) as industry,
        cast(country as varchar) as country,
        cast(number_of_employees as varchar) as number_of_employees,
        cast(create_date as timestamp) as create_date
    from source
)

select *
from renamed
