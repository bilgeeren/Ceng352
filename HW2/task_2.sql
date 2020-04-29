insert into Author(name)
select distinct f.field_value
from Field f
where f.field_name = 'author'; 

insert into Publication(pub_key,title,year)
select distinct f1.pub_key, f1.field_value, cast (f2.field_value  AS INTEGER)
from Field f1, Field F2
where f1.pub_key = f2.pub_key and f1.field_name = 'title' 
		and f2.field_name = 'year'; 

insert into Article(pub_id, journal, month, volume, number)
select pub.pub_id, f1.field_value, f2.field_value , f3.field_value, f4.field_value
from Publication pub
join Pub p on p.pub_type = 'article' and p.pub_key = pub.pub_key 
Left outer join Field f1 on f1.field_name = 'journal' and  f1.pub_key = pub.pub_key 
Left outer join Field f2 on f2.field_name = 'month' and f2.pub_key = pub.pub_key 
Left outer join Field f3 on f3.field_name = 'volume' and f3.pub_key = pub.pub_key 
Left outer join Field f4 on f4.field_name = 'number' and f4.pub_key = pub.pub_key ;

insert into Book(pub_id, publisher, isbn)
select DISTINCT ON (pub.pub_id) pub_id , f1.field_value, max(f2.field_value) as isbn
from Publication pub 
join Pub p on p.pub_type = 'book'and p.pub_key = pub.pub_key
Left outer join Field f1 on f1.field_name = 'publisher' and f1.pub_key = pub.pub_key 
Left outer join Field f2 on f2.field_name = 'isbn' and f2.pub_key = pub.pub_key 
group by pub_id, f1.field_value ;

insert into Incollection(pub_id, book_title, publisher, isbn)
select DISTINCT ON (pub.pub_id) pub_id , f1.field_value, f2.field_value, f3.field_value
from Publication pub
join Pub p on p.pub_type = 'incollection' and p.pub_key = pub.pub_key 
Left outer join Field f1 on f1.field_name = 'booktitle' and  f1.pub_key = pub.pub_key 
Left outer join Field f2 on f2.field_name = 'publisher' and f2.pub_key = pub.pub_key  
Left outer join Field f3 on f3.field_name = 'isbn' and f3.pub_key = pub.pub_key;

insert into Inproceedings(pub_id, book_title, editor)
select DISTINCT ON (pub.pub_id) pub_id , f1.field_value, f2.field_value
from Publication pub
join Pub p on p.pub_type = 'inproceedings' and p.pub_key = pub.pub_key 
Left outer join Field f1 on f1.field_name = 'booktitle' and  f1.pub_key = pub.pub_key 
Left outer join Field f2 on f2.field_name = 'editor' and f2.pub_key = pub.pub_key;

insert into Authored(author_id, pub_id)
select A.author_id, P.pub_id
from Author A, Publication P, Field F
where P.pub_key = F.pub_key and F.field_name = 'author' 
	and A.name = F.field_value; 
