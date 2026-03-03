with events as (
    select *
    from "flinn_bi"."analytics"."stg_backend_events"
),

activity_events as (
    select
        user_id,
        event_timestamp,
        date_trunc('month', event_timestamp) as activity_month
    from events
    where event_name not in (
        'TokenGenerated',
        'UserCreated',
        'UserUpdated',
        'OrganizationCreated',
        'OrganizationUpdated'
    )
)

select *
from activity_events