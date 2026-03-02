# Assumptions log

Timestamped definitions + modeling decisions.

- **2026-03-02 — Sources:** raw CSVs are committed as dbt seeds under `dbt/flinn_bi/seeds/` (the `data/` folder is ignored).
- **2026-03-02 — Customer definition (Q1):** a “customer” is a HubSpot **company** with **≥ 1 Closed Won deal** (`is_closed_won = true`). Implemented in `analytics.mart_customers_today`.
- **2026-03-02 — Deal stage logic:** deal outcome is taken directly from the provided boolean fields (`is_closed`, `is_closed_won`) in HubSpot deals (no additional stage mapping applied).
- **2026-03-02 — ACV interpretation (Q2):** HubSpot `amount` is treated as **ACV** (annual) and aggregated across **Closed Won** deals (mean + median). Currency in the provided data is **EUR** (verified on Closed Won deals). Implemented in `analytics.mart_acv`.
- **2026-03-02 — Retention definition (Q3):** monthly cohort “activity rate” for backend users.
  - Cohort = month of earliest `UserCreated` per `user_id`.
  - Active in month N = user has **any** backend event excluding: `TokenGenerated`, `UserCreated`, `UserUpdated`, `OrganizationCreated`, `OrganizationUpdated`.
  - Note: under this definition, month 1 can be higher than month 0 (users may have no qualifying activity in their creation month).
  - Implemented in `analytics.mart_user_retention`.
- **2026-03-02 — Backend ↔ HubSpot mapping (join limitations):**
  - Mapping uses `UserCreated` events by extracting `event_properties.user.email` and joining to `hubspot_contacts.email` (normalized to lowercase/trimmed in staging).
  - `event_properties.user.email` is missing for most other event types, so `UserCreated` is treated as the reliable email source and other events are linked via `user_id` / `organization_id`.
  - Backend events cover **37 orgs**, so any product-usage analysis reflects a subset of HubSpot companies.
- **2026-03-02 — Activation funnel (bonus insight):**
  - New user = earliest `UserCreated` per `user_id`.
  - Activated = any `SearchExecuted` within `[user_created_ts, user_created_ts + 7 days]` (inclusive).
  - Repro in `dbt/flinn_bi/analyses/bonus_activation_funnel.sql` and `notebooks/01_eda.ipynb`.
