-- Lightweight profiling of the seed datasets (row counts, candidate IDs, date ranges)

with profiles as (
    select
        'backend_events' as table_name,
        count(*) as row_count,
        count(distinct event_id) as distinct_id_count,
        (count(*) - count(distinct event_id)) as duplicate_id_rows,
        min(event_timestamp) as min_date,
        max(event_timestamp) as max_date
    from {{ ref('backend_events') }}

    union all

    select
        'hubspot_contacts' as table_name,
        count(*) as row_count,
        count(distinct contact_id) as distinct_id_count,
        (count(*) - count(distinct contact_id)) as duplicate_id_rows,
        min(create_date) as min_date,
        max(create_date) as max_date
    from {{ ref('hubspot_contacts') }}

    union all

    select
        'hubspot_org' as table_name,
        count(*) as row_count,
        count(distinct company_id) as distinct_id_count,
        (count(*) - count(distinct company_id)) as duplicate_id_rows,
        min(create_date) as min_date,
        max(create_date) as max_date
    from {{ ref('hubspot_org') }}

    union all

    select
        'hubspot_deals' as table_name,
        count(*) as row_count,
        count(distinct deal_id) as distinct_id_count,
        (count(*) - count(distinct deal_id)) as duplicate_id_rows,
        min(create_date) as min_date,
        max(create_date) as max_date
    from {{ ref('hubspot_deals') }}
)

select *
from profiles
order by table_name
;

