with dailyCounts(plane_tail_number, year, month, day, total_count)
as(select F.plane_tail_number, F.year, F.month, F.day, count(*) as total_count
	from flight_reports F
	where F.is_cancelled = 0
	group by F.plane_tail_number, F.year, F.month, F.day),
yearlyAvg(plane_tail_number, year, avg_count)
as(select DC.plane_tail_number, DC.year, AVG(DC.total_count) as avg_count
	from dailyCounts DC
	group by DC.plane_tail_number, DC.year)

Select YA.plane_tail_number, YA.year, YA.avg_count as daily_avg
from yearlyAvg YA
where YA.avg_count > 5
order by YA.plane_tail_number asc, YA.year asc;