/*
 For each year from 1940 to 1990 ([1940, 1990]), find the most productive author
  in that year. Your query should return the year, the name of the author who is 
  he most productive in that year, and the number of publications of the author 
  in that year. There may be more than one author who published most number of 
  publications in that year, so they can share the place #1.
   The results should be given in the increasing order of the years, 
   and increasing author names when number of publications are equal. 
   Write your query in a file called ”task 3 6.sql”. 
   You can also inspect query results in mini project files to 
   understand the problem better.
*/

with porductivity_CTE(year,author_id,countOfPub )
as (
Select pub.year, A.author_id ,count( * ) as countOfPub
from Authored A, Publication pub
where A.pub_id = pub.pub_id and pub.year >= 1940 and pub.year <= 1990
group by pub.year, A.author_id
order by pub.year),
/*Used this to get count information so there will be no need to calculate it again again and again */

max_porductivity_CTE(year,countOfPub )
as (
Select p.year, max( p.countOfPub ) as countOfPub
from porductivity_CTE p
group by p.year
order by p.year),
/*Used this to get max information so there will be no need to calculate it again again and again */

max_porductive_author_CTE(year,author_id,countOfPub )
as (
Select  p.year, p.author_id , p.countOfPub
from max_porductivity_CTE v,porductivity_CTE p
where v.year = p.year and v.countOfPub = p.countOfPub)
/*Used this to create another CTE to get max productive author in a year for all years without calculate it again again and again */

select m.year,A.name,m.countOfPub as count
from Author A,max_porductive_author_CTE m
where A.author_id = m.author_id
order by m.year,A.name;