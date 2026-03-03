
    
    

with all_values as (

    select
        currency as value_field,
        count(*) as n_records

    from "flinn_bi"."analytics"."stg_hubspot_deals"
    group by currency

)

select *
from all_values
where value_field not in (
    'EUR'
)


