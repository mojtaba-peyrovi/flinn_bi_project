with users as (
    select
        user_id,
        date_trunc('month', user_created_ts) as cohort_month
    from {{ ref('int_backend_users') }}
),

activity as (
    select distinct
        user_id,
        activity_month
    from {{ ref('int_backend_user_activity') }}
),

cohort_sizes as (
    select
        cohort_month,
        count(*) as cohort_size
    from users
    group by 1
),

active_by_period as (
    select
        u.cohort_month,
        date_diff('month', u.cohort_month, a.activity_month) as period_number,
        count(distinct a.user_id) as active_users
    from users u
    inner join activity a
        on u.user_id = a.user_id
    where a.activity_month >= u.cohort_month
    group by 1, 2
),

max_month as (
    select
        greatest(
            (select max(cohort_month) from users),
            (select max(activity_month) from activity)
        ) as max_month
),

cohorts as (
    select
        c.cohort_month,
        c.cohort_size,
        date_diff('month', c.cohort_month, m.max_month) as max_period
    from cohort_sizes c
    cross join max_month m
),

spine as (
    select
        c.cohort_month,
        c.cohort_size,
        gs.period_number
    from cohorts c
    inner join generate_series(0, c.max_period) as gs(period_number)
        on true
)

select
    spine.cohort_month,
    spine.period_number,
    spine.cohort_size,
    coalesce(active_by_period.active_users, 0) as active_users,
    case
        when spine.cohort_size = 0 then null
        else cast(coalesce(active_by_period.active_users, 0) as double) / spine.cohort_size
    end as retention_rate
from spine
left join active_by_period
    on spine.cohort_month = active_by_period.cohort_month
    and spine.period_number = active_by_period.period_number
order by 1, 2
