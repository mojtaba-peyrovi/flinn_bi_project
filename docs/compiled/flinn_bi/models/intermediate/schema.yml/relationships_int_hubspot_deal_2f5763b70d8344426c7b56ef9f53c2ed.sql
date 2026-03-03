
    
    

with child as (
    select hubspot_company_id as from_field
    from "flinn_bi"."analytics"."int_hubspot_deals_enriched"
    where hubspot_company_id is not null
),

parent as (
    select company_id as to_field
    from "flinn_bi"."analytics"."stg_hubspot_org"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


