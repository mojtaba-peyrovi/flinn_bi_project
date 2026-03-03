
    
    

select
    contact_id as unique_field,
    count(*) as n_records

from "flinn_bi"."analytics"."int_hubspot_contacts_enriched"
where contact_id is not null
group by contact_id
having count(*) > 1


