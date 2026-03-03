
    
    

with all_values as (

    select
        deal_type as value_field,
        count(*) as n_records

    from "flinn_bi"."analytics"."stg_hubspot_deals"
    group by deal_type

)

select *
from all_values
where value_field not in (
    'newbusiness','existing_business'
)


