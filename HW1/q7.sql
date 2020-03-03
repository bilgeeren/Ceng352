select A.airline_name, (cancelledTable.cancelledCount*100.0/totalTable.totalCount) as percentage
from airline_codes A, (select F.airline_code, COUNT(*) as cancelledCount
						from flight_reports F
						where F.origin_city_name = 'Boston, MA' and F.is_cancelled = 1.00
						group by F.airline_code ) as cancelledTable ,
						(select F.airline_code, COUNT(*) as totalCount
						from flight_reports F
						where F.origin_city_name = 'Boston, MA' 
						group by F.airline_code) as totalTable
where cancelledTable.airline_code = A.airline_code and cancelledTable.airline_code = totalTable.airline_code 
	and (cancelledTable.cancelledCount*100.0/totalTable.totalCount) > 10
order by percentage desc;