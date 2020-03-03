with bostonFlights_CTE(year, airline_code, flight_count)
as(select F.year, F.airline_code, Count(*)
from flight_reports F
where F.dest_city_name = 'Boston, MA' and F.is_cancelled = 0 
group by F.year, F.airline_code),
totalFlights_CTE(year,airline_code,flight_count)
as(select F.year, F.airline_code, Count(*)
from flight_reports F
where F.is_cancelled = 0 
group by F.year, F.airline_code)

select BF.year, BF.airline_code, BF.flight_count as boston_flight_count, ((100.0*BF.flight_count/TF.flight_count)) as boston_flight_percentage
from bostonFlights_CTE BF, totalFlights_CTE TF
where BF.airline_code = TF.airline_code and BF.year = TF.year and (100.0*BF.flight_count/TF.flight_count) > 1
order by year asc, airline_code asc;