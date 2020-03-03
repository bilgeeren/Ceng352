Select A.airline_name, mondayTable.count as monday_flights, sundayTable.count as sunday_flights
from airline_codes A, (Select F.airline_code, Count(*) as count
						from flight_reports F, weekdays W
						where W.weekday_name = 'Monday' and W.weekday_id = F.weekday_id
						and F.is_cancelled = 0.00
						group by F.airline_code) as mondayTable,
						(Select F.airline_code, Count(*) as count
						from flight_reports F, weekdays W
						where W.weekday_name = 'Sunday' and W.weekday_id = F.weekday_id
						and F.is_cancelled = 0.00
						group by F.airline_code) as sundayTable
where A.airline_code = mondayTable.airline_code and A.airline_code = sundayTable.airline_code
order by A.airline_name asc; 