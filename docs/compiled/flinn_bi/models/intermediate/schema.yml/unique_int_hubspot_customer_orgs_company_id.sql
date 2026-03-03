
    
    

select
    company_id as unique_field,
    count(*) as n_records

from "flinn_bi"."analytics"."int_hubspot_customer_orgs"
where company_id is not null
group by company_id
having count(*) > 1


