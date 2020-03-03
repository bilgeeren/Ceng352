select texasTable.airline_name, SUM(texasTable.flight_count) as flight_count
from (select A.airline_name ,F.plane_tail_number, count(*) as flight_count
							from flight_reports F, world_area_codes W, airline_codes A
							where W.wac_name = 'Texas' and W.wac_id = F.dest_wac_id and A.airline_code = F.airline_code	
							group by A.airline_name, F.plane_tail_number) as texasTable
where texasTable.plane_tail_number in (select distinct F.plane_tail_number
										from flight_reports F, world_area_codes W
										where W.wac_name = 'Texas' and W.wac_id = F.dest_wac_id 													
										except
										select distinct F.plane_tail_number
										from flight_reports F, world_area_codes W
										where W.wac_name <> 'Texas' and W.wac_id = F.dest_wac_id
										)
group by airline_name
order by texasTable.airline_name asc; 