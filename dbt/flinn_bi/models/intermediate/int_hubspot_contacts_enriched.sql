with contacts as (
    select *
    from {{ ref('stg_hubspot_contacts') }}
),

orgs as (
    select *
    from {{ ref('stg_hubspot_org') }}
)

select
    contacts.*,
    orgs.company_name,
    orgs.domain,
    orgs.industry,
    orgs.country,
    orgs.number_of_employees,
    orgs.create_date as company_create_date
from contacts
left join orgs
    on contacts.hubspot_company_id = orgs.company_id
