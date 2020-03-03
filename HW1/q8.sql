with groupedFlights_CTE(plane_tail_number, airline_code, year, month,day)
as(select F1.plane_tail_number, F1.airline_code, F1.year, F1.month,F1.day
from flight_reports F1
group by F1.plane_tail_number, F1.airline_code, F1.year, F1.month,F1.day)

select distinct F1.plane_tail_number, F1.airline_code as first_owner, F2.airline_code as second_owner
from groupedFlights_CTE F1 , groupedFlights_CTE F2
where F1.plane_tail_number = F2.plane_tail_number and F1.airline_code <> F2.airline_code
	and (F1.year < F2.year or (F1.year = F2.year and (F1.month < F2.month or (F1.month = F2.month and F1.day < F2.day)))) 
order by F1.plane_tail_number; 