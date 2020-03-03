select distinct A.airline_name
from airline_codes A, (select F.airline_code
						from flight_reports F
						where F.dest_city_name = 'Boston, MA' and F.is_cancelled = 0.00 and F.year > 2017
						intersect 
						select F.airline_code
						from flight_reports F
						where F.dest_city_name = 'New York, NY' and F.is_cancelled = 0.00 and F.year > 2017
						intersect
						select F.airline_code
						from flight_reports F
						where F.dest_city_name = 'Portland, ME' and F.is_cancelled = 0.00 and F.year > 2017
						intersect
						select F.airline_code
						from flight_reports F
						where F.dest_city_name = 'Washington, DC' and F.is_cancelled = 0.00 and F.year > 2017
						intersect
						select F.airline_code
						from flight_reports F
						where F.dest_city_name = 'Philadelphia, PA'	and F.is_cancelled = 0.00 and F.year > 2017
						) as intersectTable
where A.airline_code = intersectTable.airline_code 
except
select distinct A2.airline_name 
from airline_codes A2 , (select F.airline_code
		from flight_reports F
		where F.dest_city_name = 'Boston, MA' and F.is_cancelled = 0.00 and F.year < 2018
		intersect
		select F.airline_code
		from flight_reports F
		where F.dest_city_name = 'New York, NY'  and F.is_cancelled = 0.00 and F.year < 2018
		intersect
		select F.airline_code
		from flight_reports F
		where F.dest_city_name = 'Portland, ME' and F.is_cancelled = 0.00 and F.year < 2018
		intersect
		select F.airline_code
		from flight_reports F
		where F.dest_city_name = 'Washington, DC' and F.is_cancelled = 0.00 and F.year < 2018
		intersect
		select F.airline_code
		from flight_reports F
		where F.dest_city_name = 'Philadelphia, PA' and F.is_cancelled = 0.00 and F.year < 2018
		) as unionTable
where A2.airline_code = unionTable.airline_code 
order by airline_name asc; 
