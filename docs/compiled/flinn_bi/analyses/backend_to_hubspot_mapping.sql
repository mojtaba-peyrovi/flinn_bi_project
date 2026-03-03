-- Backend ↔ HubSpot linking
--
-- Backend organization_id is a UUID and does not match hubspot_org.company_id (bigint).
-- However, for UserCreated events we can extract user email from event_properties and join to HubSpot contacts,
-- which yields a stable mapping from backend organization_id → hubspot_company_id.

with user_created as (
    select
        organization_id as backend_org_id,
        lower(json_extract_string(event_properties, '$.user.email')) as email
    from "flinn_bi"."analytics"."backend_events"
    where event_name = 'UserCreated'
),

email_to_company as (
    select
        lower(email) as email,
        hubspot_company_id as hubspot_company_id
    from "flinn_bi"."analytics"."hubspot_contacts"
),

backend_org_to_company as (
    select
        uc.backend_org_id,
        count(distinct etc.hubspot_company_id) as mapped_company_ids,
        min(etc.hubspot_company_id) as hubspot_company_id_example
    from user_created uc
    left join email_to_company etc
        on etc.email = uc.email
    group by 1
)

select
    count(*) as backend_orgs,
    count(case when mapped_company_ids = 1 then 1 end) as orgs_map_to_one_company,
    count(case when mapped_company_ids > 1 then 1 end) as orgs_map_to_multiple_companies,
    count(case when mapped_company_ids = 0 then 1 end) as orgs_unmapped
from backend_org_to_company
;