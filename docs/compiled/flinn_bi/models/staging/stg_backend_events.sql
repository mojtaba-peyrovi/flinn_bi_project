with source as (
    select * from "flinn_bi"."analytics"."backend_events"
),

renamed as (
    select
        cast(event_id as varchar) as event_id,
        cast(event_name as varchar) as event_name,
        cast(event_timestamp as timestamp) as event_timestamp,
        cast(user_id as varchar) as user_id,
        cast(organization_id as varchar) as backend_organization_id,
        cast(event_properties as varchar) as event_properties
    from source
)

select *
from renamed