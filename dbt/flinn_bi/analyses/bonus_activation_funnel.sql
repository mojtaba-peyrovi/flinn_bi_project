-- Bonus insight: % of new users who run SearchExecuted within 7 days of UserCreated
--
-- Definitions:
-- - New user: first UserCreated event per user_id
-- - Activated: any SearchExecuted event within [user_created_ts, user_created_ts + 7 days] (inclusive)

with events as (
    select *
    from {{ ref('backend_events') }}
),

user_created as (
    select
        user_id,
        min(event_timestamp) as user_created_ts
    from events
    where event_name = 'UserCreated'
      and user_id is not null
      and event_timestamp is not null
    group by 1
),

activated as (
    select distinct uc.user_id
    from user_created uc
    join events e
      on e.user_id = uc.user_id
     and e.event_name = 'SearchExecuted'
     and e.event_timestamp is not null
     and e.event_timestamp >= uc.user_created_ts
     and e.event_timestamp <= uc.user_created_ts + interval 7 day
)

select
    (select count(*) from user_created) as new_users,
    (select count(*) from activated) as activated_users,
    round(
        100.0 * (select count(*) from activated) / nullif((select count(*) from user_created), 0),
        1
    ) as activation_rate_pct
;

