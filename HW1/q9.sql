with onlyWeekendPlanes_CTE(plane_tail_number)
as (Select F.plane_tail_number
	from flight_reports F
	where F.year = 2016 and F.month = 1 
	and (F.weekday_id = 6 or F.weekday_id = 7) 
	and F.is_cancelled = 0.00
	except
	Select F.plane_tail_number
	from flight_reports F
	where F.year = 2016 and F.month = 1
	and (F.weekday_id = 1 or F.weekday_id = 2 or F.weekday_id = 3 or F.weekday_id = 4 or F.weekday_id = 5) 
	and F.is_cancelled = 0.00)

Select OWP.plane_tail_number, AVG(F.flight_distance / F.flight_time) as avg_speed
from onlyWeekendPlanes_CTE OWP, flight_reports F
where OWP.plane_tail_number = F.plane_tail_number and F.is_cancelled = 0 and F.year = 2016 and F.month = 1 and (F.weekday_id = 6 or F.weekday_id =7)
group by OWP.plane_tail_number
order by avg_speed desc;