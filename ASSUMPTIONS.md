# Assumptions log

Keep definitions and modeling decisions here as they become clear.

## Placeholders (to be finalized)
- **Customer definition:** TBD (e.g., org with at least one Closed Won deal).
- **ACV definition:** TBD (e.g., deal `amount` interpreted as annual contract value).
- **Retention definition:** TBD (cohort granularity + “active” event definition).

## Initial notes (2026-03-02)
- HubSpot “org” source file provided as `hubspot_companies.csv`; loaded as seed `hubspot_org`.
- Raw source CSVs live in `./data` (ignored); dbt seeds are committed under `dbt/flinn_bi/seeds/`.

## EDA-driven notes (2026-03-02)
- **Backend ↔ HubSpot mapping:** backend `organization_id` (UUID) can be mapped to HubSpot `company_id` via `UserCreated` events by extracting `event_properties.user.email` and joining to `hubspot_contacts.email`. In this dataset it’s 1:1 for all backend orgs (37 orgs).
- **Email availability:** `event_properties.user.email` is missing for most backend event types; treat `UserCreated` as the reliable source for email-based linking and then join other backend events via `user_id` / `organization_id` to the mapping.
- **Activation funnel definition (bonus insight):**\n  - New user = earliest `UserCreated` per `user_id`.\n  - Activated = any `SearchExecuted` within `[user_created_ts, user_created_ts + 7 days]` (inclusive).\n  - Exclude rows with missing `user_id` or `event_timestamp` (none observed in this dataset).
