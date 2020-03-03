with totalFlights_CTE(airport_desc,flight_count)
as(select A.airport_desc, count(*) as flight_count
from flight_reports F, airport_codes A
where F.dest_airport_code = A.airport_code or F.origin_airport_code = A.airport_code
group by A.airport_desc
order by flight_count desc
limit 5)
select TF.airport_desc 
	from totalFlights_CTE TF
	order by TF.airport_desc;