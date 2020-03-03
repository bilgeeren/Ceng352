select W.weekday_id, W.weekday_name, avgTable1.avg as avg_delay
from weekdays w, (select F.weekday_id, AVG(F.departure_delay+F.arrival_delay) as avg
					from flight_reports F
					where F.origin_city_name = 'San Francisco, CA' and F.dest_city_name = 'Boston, MA' and F.is_cancelled = 0.00
					group by F.weekday_id) as avgTable1
where W.weekday_id = avgTable1.weekday_id and avgTable1.avg = (select MIN(avg) from (select F.weekday_id, AVG(F.departure_delay+F.arrival_delay) as avg
																		from flight_reports F
																		where F.origin_city_name = 'San Francisco, CA' and F.dest_city_name = 'Boston, MA' 
																		and F.is_cancelled = 0.00
																		group by F.weekday_id) as avgTable1);