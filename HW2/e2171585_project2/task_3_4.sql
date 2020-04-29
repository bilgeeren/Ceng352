/*
 For each decade starting from 1940, compute the total number of publications 
 in DBLP in that decade. The output of your query should have 
 2 columns: the decade string which is a concatenation of the start year, 
 followed by a dash, and then the end year, and the total number of publications 
 for that decade. The output should be ordered based on the decades 
 and should include a row for each decade, starting from 1940, 
 up to the latest publication year in the data. E.g., 
 if the latest publication year is 2020, the last row of your result 
 should be the decade 2020-2030. If the decade is 1940-1950, 
 years will be 1940, 1941, . . . , 1949; 1950 shouldn’t be considered in that 
 decade. Write your query in a file called ”task 3 4.sql”.
  You can also inspect query results in mini project files to understand the
   problem better.
*/

with yearTable_CTE(year, coutOfPub) as (
	select pub.year, count(*) as coutOfPub
	from Publication pub
	where pub.year >=1940
	group by pub.year
	order by pub.year)
/*Used this to get count information so there will be no need to calculate it again again and again */

select concat(y.year, '-', (y.year+10)) as decade, sum(y.coutOfPub) over w as total
from yearTable_CTE y
WINDOW w as (ORDER BY y.year ROWS BETWEEN current row AND 9 FOLLOWING);