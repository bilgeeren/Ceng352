with dailyCounts(airline_code, year, month, day, total_count)
as(select F.airline_code, F.year, F.month, F.day, count(*) as total_count
	from flight_reports F
	group by F.airline_code, F.year, F.month, F.day),
yearlyAvg(airline_code, year, avg_count)
as(select DC.airline_code, DC.year, AVG(DC.total_count) as avg_count
	from dailyCounts DC
	group by DC.airline_code, DC.year),
yearlyCount(airline_code, year, total_count)
as(select DC.airline_code, DC.year, SUM(DC.total_count) as total_count
	from dailyCounts DC
	group by DC.airline_code, DC.year),
cancelledCounts(airline_code, year,cancelled_count)
as(select F.airline_code,F.year, count(*) as cancelled_count
	from flight_reports F
	where F.is_cancelled = 1
	group by F.airline_code,F.year)

Select A.airline_name, YC.year, YC.total_count as total_num_flights, CC.cancelled_count as cancelled_flights
from airline_codes A, yearlyCount YC, cancelledCounts CC
where A.airline_code = YC.airline_code and YC.airline_code = CC.airline_code and YC.year = CC.year
	and YC.airline_code not in (select YA.airline_code
										from yearlyAvg YA 
										where YA.avg_count < 2000)
order by A.airline_name asc;