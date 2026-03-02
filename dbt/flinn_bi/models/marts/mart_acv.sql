with closed_won_deals as (
    select *
    from {{ ref('stg_hubspot_deals') }}
    where is_closed_won
),

overall as (
    select
        'all_closed_won' as acv_definition,
        cast(null as varchar) as deal_type,
        count(*) as closed_won_deal_count,
        avg(amount) as mean_acv,
        median(amount) as median_acv,
        min(close_date) as first_close_date,
        max(close_date) as last_close_date
    from closed_won_deals
),

by_deal_type as (
    select
        'closed_won_by_deal_type' as acv_definition,
        deal_type,
        count(*) as closed_won_deal_count,
        avg(amount) as mean_acv,
        median(amount) as median_acv,
        min(close_date) as first_close_date,
        max(close_date) as last_close_date
    from closed_won_deals
    group by 1, 2
)

select
    current_date as as_of_date,
    acv_definition,
    deal_type,
    closed_won_deal_count,
    mean_acv,
    median_acv,
    first_close_date,
    last_close_date
from overall

union all

select
    current_date as as_of_date,
    acv_definition,
    deal_type,
    closed_won_deal_count,
    mean_acv,
    median_acv,
    first_close_date,
    last_close_date
from by_deal_type
