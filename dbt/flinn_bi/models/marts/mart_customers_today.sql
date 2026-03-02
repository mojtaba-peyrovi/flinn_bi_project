with customers as (
    select *
    from {{ ref('int_hubspot_customer_orgs') }}
)

select
    current_date as as_of_date,
    company_id,
    company_name,
    domain,
    industry,
    country,
    number_of_employees,
    create_date,
    first_closed_won_date,
    latest_closed_won_date,
    closed_won_deal_count,
    closed_won_amount_total,
    closed_won_amount_mean,
    closed_won_amount_median
from customers
