with minimizeFieldTable(pub_key, field_index, field_name)
as (
Select f.pub_key,f.field_index,f.field_name
from Field f),

field_pub_join(field_index, field_name, countOfTypes)
as(	Select m.field_index ,m.field_name, count(distinct p.pub_type)
	from Pub p , minimizeFieldTable m
	where m.pub_key = p.pub_key
	group by m.field_index ,m.field_name)

Select j.field_name
from field_pub_join j
where j.countOfTypes = 7
order by j.field_name asc;
