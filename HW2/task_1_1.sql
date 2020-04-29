Select p.pub_type, count(*) as totalCount
from Pub p
group by p.pub_type
order by totalCount desc;