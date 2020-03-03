with resonsTable_CTE(year, weekday_id, reason, total_count)
as (Select F.year, F.weekday_id, F.cancellation_reason, count(*) as total_count
	from flight_reports F 
	where F.is_cancelled = 1.0
	group by F.year, F.weekday_id, F.cancellation_reason),

minTable_CTE(year, weekday_id, total_count)
as(	select rt.year, rt.weekday_id, MAX(rt.total_count)
	from resonsTable_CTE rt
	group by  rt.year, rt.weekday_id)

select rt.year, W.weekday_name, R.reason_desc as reason, mt.total_count as number_of_cancellations
from cancellation_reasons R, resonsTable_CTE rt, minTable_CTE mt, weekdays W
where R.reason_code = rt.reason and rt.year = mt.year and rt.weekday_id = mt.weekday_id
	and rt.total_count = mt.total_count and W.weekday_id = rt.weekday_id
order by rt.year, rt.weekday_id; 