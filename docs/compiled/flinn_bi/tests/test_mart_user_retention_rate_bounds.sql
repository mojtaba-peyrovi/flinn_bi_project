select *
from "flinn_bi"."analytics"."mart_user_retention"
where retention_rate < 0
   or retention_rate > 1