select
    cohort_month,
    period_number,
    count(*) as row_count
from "flinn_bi"."analytics"."mart_user_retention"
group by 1, 2
having count(*) > 1