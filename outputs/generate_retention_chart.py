from __future__ import annotations

from pathlib import Path

import duckdb
import pandas as pd


def main() -> None:
    repo_root = Path(__file__).resolve().parents[1]
    duckdb_path = repo_root / "dbt" / "flinn_bi" / "flinn_bi.duckdb"
    output_path = repo_root / "outputs" / "retention_month1_by_cohort_month.png"

    if not duckdb_path.exists():
        raise FileNotFoundError(
            f"DuckDB file not found at {duckdb_path}. Run dbt first (dbt seed/build)."
        )

    con = duckdb.connect(str(duckdb_path))
    df = con.execute(
        """
        select
            cohort_month,
            retention_rate
        from analytics.mart_user_retention
        where period_number = 1
        order by cohort_month asc
        """
    ).df()

    df["cohort_month"] = pd.to_datetime(df["cohort_month"])
    df["cohort_month_str"] = df["cohort_month"].dt.strftime("%Y-%m")
    df["retention_pct"] = df["retention_rate"] * 100.0

    import matplotlib.pyplot as plt

    plt.style.use("seaborn-v0_8-whitegrid")
    plt.figure(figsize=(10, 4.5), dpi=200)
    plt.plot(df["cohort_month_str"], df["retention_pct"], marker="o", linewidth=2)
    plt.ylim(0, 100)
    plt.xlabel("Cohort Month (YYYY-MM)")
    plt.ylabel("Retention (%)")
    plt.title("Month-1 Retention by Cohort Month")
    plt.xticks(rotation=45, ha="right")
    plt.tight_layout()
    plt.savefig(output_path)

    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
