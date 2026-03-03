
    
    

select
    deal_id as unique_field,
    count(*) as n_records

from "flinn_bi"."analytics"."int_hubspot_deals_enriched"
where deal_id is not null
group by deal_id
having count(*) > 1


