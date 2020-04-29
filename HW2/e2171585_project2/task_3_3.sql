/*
Find authors who has publications in ’IEEE Trans. Wireless Communications’ journal 
more than 10 times ( [10,∞) ) but has no publications for ’IEEE Wireless Commun. 
Letters’ journal. Order the results by decreasing number of publications, 
increasing author names when publication counts are equal. 
Write your query in a file called ”task 3 3.sql”. You can also inspect query 
results in mini project files to understand the problem better.
*/

with journals_CTE(pub_id,field_value )
as (
Select pub.pub_id, f1.field_value
from Publication pub
Left outer join Field f1 on f1.field_name = 'journal' and f1.pub_key = pub.pub_key
),
/*Used this to create another CTE ease my job while lookin on journals */

IEEETransjournals_CTE(pub_id)
as (
Select j.pub_id
from journals_CTE j
where j.field_value = 'IEEE Trans. Wireless Communications'
),
/*Used this to create another CTE to take IEEE Trans. Wireless Communications from all journals  */

IEEELettersjournals_CTE(pub_id)
as (
Select j.pub_id
from journals_CTE j
where j.field_value = 'IEEE Wireless Commun. Letters'
),
/*Used this to create another CTE to take IEEE Wireless Commun. Letters from all journals  */

TransAuthors(author_id, countOfPub)
as (
Select A.author_id, count(*) as countOfPub
from Authored A, IEEETransjournals_CTE ie
where A.pub_id = ie.pub_id
group by A.author_id),
/*Used this to get count information for IEEE Trans. Wireless Communications authers so there will be no need to calculate it again again and again */

LetterAuthors(author_id)
as (
Select A.author_id
from Authored A, IEEELettersjournals_CTE ie
where A.pub_id = ie.pub_id
group by A.author_id)
/*Used this to create another CTE to take IEEE Wireless Commun. Letters authors ids*/

select A.name as author_name, ta.countOfPub as pub_count
from TransAuthors ta ,Author A
where ta.author_id = A.author_id and ta.author_id = A.author_id
		and ta.countOfPub >= 10 
		and ta.author_id not in (select la.author_id from LetterAuthors la)
order by ta.countOfPub desc, A.name ;