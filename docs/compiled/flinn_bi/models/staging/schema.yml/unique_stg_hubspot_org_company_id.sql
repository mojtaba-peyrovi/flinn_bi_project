
    
    

select
    company_id as unique_field,
    count(*) as n_records

from "flinn_bi"."analytics"."stg_hubspot_org"
where company_id is not null
group by company_id
having count(*) > 1


