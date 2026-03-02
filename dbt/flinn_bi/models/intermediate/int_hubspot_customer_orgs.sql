with closed_won_deals as (
    select *
    from {{ ref('stg_hubspot_deals') }}
    where is_closed_won
),

by_company as (
    select
        hubspot_company_id as company_id,
        min(close_date) as first_closed_won_date,
        max(close_date) as latest_closed_won_date,
        count(*) as closed_won_deal_count,
        sum(amount) as closed_won_amount_total,
        avg(amount) as closed_won_amount_mean,
        median(amount) as closed_won_amount_median
    from closed_won_deals
    group by 1
),

orgs as (
    select *
    from {{ ref('stg_hubspot_org') }}
)

select
    orgs.*,
    by_company.first_closed_won_date,
    by_company.latest_closed_won_date,
    by_company.closed_won_deal_count,
    by_company.closed_won_amount_total,
    by_company.closed_won_amount_mean,
    by_company.closed_won_amount_median
from by_company
inner join orgs
    on by_company.company_id = orgs.company_id
