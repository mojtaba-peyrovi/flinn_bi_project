
    
    

with all_values as (

    select
        pipeline as value_field,
        count(*) as n_records

    from "flinn_bi"."analytics"."stg_hubspot_deals"
    group by pipeline

)

select *
from all_values
where value_field not in (
    'Sales Pipeline'
)


