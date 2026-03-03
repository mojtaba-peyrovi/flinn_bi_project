
    
    

with all_values as (

    select
        event_name as value_field,
        count(*) as n_records

    from "flinn_bi"."analytics"."stg_backend_events"
    group by event_name

)

select *
from all_values
where value_field not in (
    'TokenGenerated','SearchExecuted','SearchResultAppraised','SearchUpdated','SearchResultFullTextAppraised','SearchCreated','SearchExported','LabelCreated','LabelUpdated','LabelDeleted','UserCreated','OrganizationUpdated','UserUpdated','OrganizationCreated'
)


