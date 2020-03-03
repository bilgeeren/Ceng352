select A.airport_code, A.airport_desc, totalTable.cancel_count
from airport_codes A, (select F.origin_airport_code, count(*) as cancel_count
						from flight_reports F, cancellation_reasons C
						where F.is_cancelled = 1.00 and F.cancellation_reason = C.reason_code and C.reason_desc = 'Security'
						group by F.origin_airport_code) as totalTable
where A.airport_code = totalTable.origin_airport_code 
order by totalTable.cancel_count desc, A.airport_code asc; 