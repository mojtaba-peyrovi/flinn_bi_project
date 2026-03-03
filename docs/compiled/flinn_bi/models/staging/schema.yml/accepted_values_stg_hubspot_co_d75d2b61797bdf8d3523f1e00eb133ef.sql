
    
    

with all_values as (

    select
        lifecycle_stage as value_field,
        count(*) as n_records

    from "flinn_bi"."analytics"."stg_hubspot_contacts"
    group by lifecycle_stage

)

select *
from all_values
where value_field not in (
    'lead','opportunity','customer'
)


