/*Find the top 1000 most collaborative authors. 
That is, for each author determine the number of his/her collaborators, 
then find the top 1000. Even if author A and author B have worked on 
multiple publications together, they only count once as each other’s 
collaborator. Your query should return the names of the authors and 
the number of their collaborators. The result should be ordered in 
decreasing order of the number of collaborators and increasing author
 names when number of collaborators are equal. Write your query in a 
 file called ”task 3 5.sql”. You can also inspect query results in 
 mini project files to understand the problem better.
*/

with collaborators_CTE(author_id,countOfCollabrators )
as (
Select A.author_id, count( distinct A2.author_id ) as countOfCollabrators
from Authored A 
join Authored A2 on A2.pub_id = A.pub_id and A2.author_id <> A.author_id
group by A.author_id)
/*Used this to get count information so there will be no need to calculate it again again and again */

select A.name, c.countOfCollabrators as collab_count
from Author A,collaborators_CTE c
where A.author_id = c.author_id
order by countOfCollabrators desc, A.name asc
limit 1000;
