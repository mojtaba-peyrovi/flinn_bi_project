with source as (
    select * from "flinn_bi"."analytics"."hubspot_contacts"
),

renamed as (
    select
        cast(contact_id as bigint) as contact_id,
        cast(first_name as varchar) as first_name,
        cast(last_name as varchar) as last_name,
        lower(trim(cast(email as varchar))) as email,
        cast(job_title as varchar) as job_title,
        cast(hubspot_company_id as bigint) as hubspot_company_id,
        cast(lifecycle_stage as varchar) as lifecycle_stage,
        cast(create_date as timestamp) as create_date
    from source
)

select *
from renamed