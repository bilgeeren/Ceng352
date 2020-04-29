/*
Find authors who have more than 150, less than 200 publications ( [150, 200) ). 
Your query should return the name of each author and the number of 
publications by that author. Order the results by increasing number of 
publications, increasing author names when publication counts are equal. 
Write your query in a file called ”task 3 1.sql”. 
You can also inspect query results in mini project files to understand 
the problem better.
*/

with countOfPubByAyuthor_CTE(author_id, countOfPub)
as (
Select A.author_id, count(distinct A.pub_id) as countOfPub
from Authored A
Group by A.author_id)
/*Used this to create another CTE ease my job while searching on counts */

select A.name as author_name, CPA.countOfPub as pub_count
from Author A,countOfPubByAyuthor_CTE CPA
where A.author_id = CPA.author_id and CPA.countOfPub >= 150 and CPA.countOfPub < 200
order by countOfPub, name;  