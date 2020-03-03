select format(('%s/%s/%s') ,F1.day, F1.month, F1.year) flight_date, F1.plane_tail_number, F1.arrival_time as flight1_arrival_time,
				F2.departure_time as flight2_departure_time, F1.origin_city_name, 
				F1.dest_city_name as stop_city_name,F2.dest_city_name, 
				(F1.flight_time + F1.taxi_out_time + F2.flight_time + F2.taxi_in_time) as total_time, (F1.flight_distance + F2.flight_distance) as total_distance

from flight_reports F1, flight_reports F2
where F1.origin_city_name = 'Seattle, WA' and F1.dest_city_name = F2.origin_city_name and F2.dest_city_name = 'Boston, MA'
	and F1.airline_code = F2.airline_code and F1.plane_tail_number = F2.plane_tail_number
	and F1.year = F2.year and F1.month = F2.month and F1.day = F2.day
	and F1.arrival_time < F2.departure_time and F1.is_cancelled = 0 and F2.is_cancelled = 0
order by total_time, total_distance, plane_tail_number, stop_city_name;