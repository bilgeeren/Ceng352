/*
Find the top 50 authors with the largest number of publications in IEEE-related journals. 
Your query should return the name of each author and the number of publications by that author 
n IEEE-related journal. Order the results by decreasing number of publications, 
increasing author names when publication counts are equal. For finding relatedness, 
use LIKE on journal field. Write your query in a file called ”task 3 2.sql”. 
You can also inspect query results in mini project files to understand the problem better.
*/
with journals_CTE(pub_id,field_value )
as (
Select pub.pub_id, f1.field_value
from Publication pub
Left outer join Field f1 on f1.field_name = 'journal' and f1.pub_key = pub.pub_key
),
/*Used this to create another CTE ease my job while lookin on journals */

IEEEjournals_CTE(pub_id)
as (
Select j.pub_id
from journals_CTE j
where j.field_value like '%IEEE%'
),
/*Used this to create another CTE to take IEEE from all journals  */
tempAuthors(author_id, countOfPub)
as (
Select A.author_id, count(*) as countOfPub
from Authored A, IEEEjournals_CTE ie
where A.pub_id = ie.pub_id
group by A.author_id
order by countOfPub desc)
/*Used this to get count information so there will be no need to calculate it again again and again */

select A.name as author_name, ta.countOfPub as pub_count
from tempAuthors ta, Author A
where ta.author_id = A.author_id
order by ta.countOfPub desc, A.name asc
limit 50;