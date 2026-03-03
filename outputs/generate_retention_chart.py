from __future__ import annotations

from pathlib import Path

import duckdb
import pandas as pd


def main() -> None:
    repo_root = Path(__file__).resolve().parents[1]
    duckdb_path = repo_root / "dbt" / "flinn_bi" / "flinn_bi.duckdb"
    output_month1_by_cohort_path = (
        repo_root / "outputs" / "retention_month1_by_cohort_month.png"
    )
    output_weighted_by_period_path = (
        repo_root / "outputs" / "retention_weighted_by_period.png"
    )

    if not duckdb_path.exists():
        raise FileNotFoundError(
            f"DuckDB file not found at {duckdb_path}. Run dbt first (dbt seed/build)."
        )

    try:
        con = duckdb.connect(str(duckdb_path), read_only=True)
    except Exception as exc:  # pragma: no cover
        raise RuntimeError(
            f"Failed to open DuckDB at {duckdb_path}. Close any running DuckDB/dbt "
            f"processes using the file and try again."
        ) from exc

    weighted_by_period = con.execute(
        """
        select
            period_number,
            sum(active_users)::double / sum(cohort_size) as retention_rate
        from analytics.mart_user_retention
        group by 1
        order by 1
        """
    ).df()
    weighted_by_period["retention_pct"] = weighted_by_period["retention_rate"] * 100.0

    month1_by_cohort = con.execute(
        """
        select
            cohort_month,
            retention_rate
        from analytics.mart_user_retention
        where period_number = 1
        order by cohort_month asc
        """
    ).df()

    month1_by_cohort["cohort_month"] = pd.to_datetime(month1_by_cohort["cohort_month"])
    month1_by_cohort["cohort_month_str"] = month1_by_cohort["cohort_month"].dt.strftime(
        "%Y-%m"
    )
    month1_by_cohort["retention_pct"] = month1_by_cohort["retention_rate"] * 100.0

    import matplotlib.pyplot as plt

    plt.style.use("seaborn-v0_8-whitegrid")

    plt.figure(figsize=(9, 4.5), dpi=200)
    plt.plot(
        weighted_by_period["period_number"],
        weighted_by_period["retention_pct"],
        marker="o",
        linewidth=2,
    )
    plt.ylim(0, 100)
    plt.xlabel("Months Since Cohort Start (period_number)")
    plt.ylabel("Retention (%)")
    plt.title("Retention (Weighted Across Cohorts)")
    plt.xticks(weighted_by_period["period_number"])

    highlight_periods = [0, 1, 3, 6, 12]
    for period in highlight_periods:
        row = weighted_by_period.loc[weighted_by_period["period_number"] == period]
        if row.empty:
            continue
        x = int(row["period_number"].iloc[0])
        y = float(row["retention_pct"].iloc[0])
        plt.scatter([x], [y], s=40)
        plt.annotate(
            f"{y:.1f}%",
            (x, y),
            textcoords="offset points",
            xytext=(0, 8),
            ha="center",
            fontsize=9,
        )

    plt.tight_layout()
    plt.savefig(output_weighted_by_period_path)

    plt.figure(figsize=(10, 4.5), dpi=200)
    plt.plot(
        month1_by_cohort["cohort_month_str"],
        month1_by_cohort["retention_pct"],
        marker="o",
        linewidth=2,
    )
    plt.ylim(0, 100)
    plt.xlabel("Cohort Month (YYYY-MM)")
    plt.ylabel("Retention (%)")
    plt.title("Month-1 Retention by Cohort Month")
    plt.xticks(rotation=45, ha="right")
    plt.tight_layout()
    plt.savefig(output_month1_by_cohort_path)

    print(f"Wrote {output_weighted_by_period_path}")
    print(f"Wrote {output_month1_by_cohort_path}")


if __name__ == "__main__":
    main()
