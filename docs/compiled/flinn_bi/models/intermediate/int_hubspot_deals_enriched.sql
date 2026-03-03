with deals as (
    select *
    from "flinn_bi"."analytics"."stg_hubspot_deals"
),

orgs as (
    select *
    from "flinn_bi"."analytics"."stg_hubspot_org"
)

select
    deals.*,
    orgs.company_name,
    orgs.domain,
    orgs.industry,
    orgs.country,
    orgs.number_of_employees,
    orgs.create_date as company_create_date
from deals
left join orgs
    on deals.hubspot_company_id = orgs.company_id