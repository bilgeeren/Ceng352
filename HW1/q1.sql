select A.airline_name, A.airline_code, delayTable.avg_delay
from airline_codes A, (select F.airline_code, avg(F.departure_delay) as avg_delay
						from  flight_reports F
						where F.year = 2018 and F.is_cancelled = 0.00
						Group by F.airline_code) as delayTable
where delayTable.airline_code = A.airline_code
order by delayTable.avg_delay asc, A.airline_name asc; 