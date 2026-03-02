# Assumptions log

Keep definitions and modeling decisions here as they become clear.

## Placeholders (to be finalized)
- **Customer definition:** TBD (e.g., org with at least one Closed Won deal).
- **ACV definition:** TBD (e.g., deal `amount` interpreted as annual contract value).
- **Retention definition:** TBD (cohort granularity + “active” event definition).

## Initial notes (2026-03-02)
- HubSpot “org” source file provided as `hubspot_companies.csv`; loaded as seed `hubspot_org`.
- Raw source CSVs live in `./data` (ignored); dbt seeds are committed under `dbt/flinn_bi/seeds/`.

