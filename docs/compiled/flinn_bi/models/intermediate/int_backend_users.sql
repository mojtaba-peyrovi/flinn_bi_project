with events as (
    select *
    from "flinn_bi"."analytics"."stg_backend_events"
),

user_created as (
    select
        user_id,
        min(event_timestamp) as user_created_ts,
        any_value(backend_organization_id) as backend_organization_id
    from events
    where event_name = 'UserCreated'
    group by 1
)

select *
from user_created