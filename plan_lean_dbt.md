# plan.md — Flinn BI Technical Challenge (Lean, dbt-first)

Goal: Answer Q1–Q3 with **clear dbt modeling** + **strong but simple EDA**, and submit a repo that’s easy to review.
Scope: **No app / no GCP / no over-engineering.** Focus on dbt, assumptions, and a concise write-up.

Deliverables required by Flinn:
- dbt models / SQL (show your work)
- short write-up (README): answers + assumptions + data quality notes
- assumptions log (ASSUMPTIONS.md)
- optional bonus insight (EDA-driven)

---

## Task 1 — Repo + dbt project skeleton (seeds-based) (Commit 1)

### What to do
1) Create a dbt project (dbt-duckdb recommended for zero-setup review).
2) Put the provided CSVs into **dbt seeds**:
   - `dbt/flinn_bi/seeds/backend_events.csv`
   - `dbt/flinn_bi/seeds/hubspot_deals.csv`
   - `dbt/flinn_bi/seeds/hubspot_org.csv`
   - `dbt/flinn_bi/seeds/hubspot_contacts.csv`
3) Configure seeds in `dbt_project.yml` (column types if needed).
4) Add `profiles.yml.example` and README instructions to run locally.
5) Add minimal docs stubs:
   - `README.md` (structure only for now)
   - `ASSUMPTIONS.md` (start logging immediately)

### Tests
- `dbt debug`
- `dbt seed`

### Docs update
- README: “How to run” section (seed + build)
- ASSUMPTIONS: initial definitions placeholders (Customer / ACV / Retention)

### Commit
- `chore: init dbt project and seeds`

---

## Task 2 — EDA notebook + bonus insight (Commit 2)

### What to do
Create **one** notebook: `notebooks/01_eda.ipynb` with:
1) Quick profiling per file:
   - row counts, missingness, duplicates
   - date ranges
   - key fields (candidate IDs)
2) Relationship exploration:
   - how contacts map to orgs
   - how deals map to orgs
   - whether backend org_id/user_id can be linked to hubspot entities (if possible)
3) Data quality findings:
   - highlight the top 2–5 issues that could affect metrics (e.g., missing IDs, duplicate associations, inconsistent stages)
4) Bonus insight (explicit):
   - **Activation funnel**: “62.0% of new users (93/150) run SearchExecuted within 7 days of UserCreated.”
   - Show the exact computation steps and define:
     - what counts as “new user” (UserCreated event)
     - the 7-day window logic
     - how you handle missing timestamps / duplicates

### Output artifacts
- Save a short markdown summary in `outputs/bonus_insight.md`:
  - 3–6 bullets: what you found + why it matters

### Tests
- (Lightweight) run notebook top-to-bottom once locally
- Optional: add 1 smoke test that CSVs exist and notebook file exists

### Docs update
- README: “EDA highlights” section + link to bonus_insight.md
- ASSUMPTIONS: record any EDA-driven decisions

### Commit
- `feat: add EDA notebook and bonus insight`

---

## Task 3 — dbt modeling for Q1–Q3 + dbt tests + docs + ERD (Commit 3)

### Modeling approach (keep it simple and explainable)
Use 3 layers:

**1) Staging (stg_)**
- Clean column names, cast types, parse timestamps
- Standardize IDs and relationships

**2) Intermediate (int_)**
- Relationship helpers (e.g., contacts-to-org, deals-to-org)
- Optional mapping tables if needed for joins

**3) Marts (mart_)**
- Final tables that answer Q1–Q3

### Required dbt models
**Staging**
- `stg_backend_events`
- `stg_hubspot_deals`
- `stg_hubspot_org`
- `stg_hubspot_contacts`

**Marts / metrics tables**
- `mart_customers_today`
  - customer definition based on HubSpot (e.g., orgs with at least one Closed Won deal)
- `mart_acv`
  - ACV from closed-won deals (mean + median; document assumptions)
- `mart_user_retention`
  - cohort retention (weekly OR monthly—choose based on data span)
  - define “active” event logic (exclude TokenGenerated-only if you choose; document)

### dbt tests (must-have)
- `not_null` + `unique` where appropriate (IDs)
- relationship tests:
  - deals → orgs
  - contacts → orgs
- accepted values for deal stages (if available)
- basic “grain” test for marts (e.g., one row per org in customers table)

### ERD / lineage
- Add a Mermaid ERD (or dbt docs lineage screenshot if you prefer) in README:
  - seeds → staging → marts
- Also run:
  - `dbt docs generate`
  - optional: include `target/` in .gitignore (keep repo clean)

### Tests
- `dbt seed`
- `dbt build` (must pass)

### Docs update
- README: add a “Data model” section:
  - explain each layer (stg/int/mart) in plain language
  - why this structure makes metrics trustworthy
- ASSUMPTIONS: lock final definitions for customer/ACV/retention
- Add a short “Data quality issues” section (from EDA) and how you mitigated them in dbt

### Commit
- `feat: dbt models for q1-q3 with tests and docs`

---

## Task 4 — Final write-up polish (10-minute standup style) (Commit 4)

### README must include
1) **How to run**
   - dbt seed/build commands
   - how to view dbt docs locally
2) **Answers**
   - Q1: number of customers today (value + definition)
   - Q2: ACV (value + definition + caveats)
   - Q3: retention (definition + headline numbers + how computed)
3) **Assumptions + data quality**
   - link to ASSUMPTIONS.md
   - top issues found + impact
4) **Bonus insight**
   - activation funnel (with the provided number) + why it matters
5) **Next 6 months roadmap (product-minded)**
   - 5–8 bullets (MVP → iterate → scale), kept concise

### Assumptions log (ASSUMPTIONS.md)
- bullet list, timestamped
- include:
  - customer definition
  - deal stage logic
  - ACV interpretation
  - retention definition + “active” events
  - join limitations (if backend↔hubspot mapping is partial)

### Tests
- `dbt build`
- quick sanity: models exist and docs generate

### Commit
- `docs: finalize README and assumptions`

---

## Global rules (apply to all tasks)
- Keep logic and wording **simple and review-friendly**.
- If something is ambiguous and blocks progress: **stop and ask**.
- Otherwise: pick a reasonable approach and write it in ASSUMPTIONS.md.
- Commit after each task (no WIP).

