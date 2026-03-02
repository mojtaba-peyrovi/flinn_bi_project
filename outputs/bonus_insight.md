# Bonus insight — activation funnel (backend events)

- **Activation metric:** a “new user” is a distinct `user_id` with a `UserCreated` event (using the earliest `event_timestamp` per user).
- **Activated definition:** a user is “activated” if they have **any** `SearchExecuted` event with `event_timestamp` between `user_created_ts` and `user_created_ts + 7 days` (inclusive).
- **Result:** **62.0% (93 / 150)** of new users execute `SearchExecuted` within 7 days of `UserCreated`.
- **Why it matters:** `SearchExecuted` is a strong early product-usage signal; this is a clean top-of-funnel KPI to track over time and segment by company/customer status later.
- **Repro:** notebook `notebooks/01_eda.ipynb` and dbt analysis query `dbt/flinn_bi/analyses/bonus_activation_funnel.sql`.

