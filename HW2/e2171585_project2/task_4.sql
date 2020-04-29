create table if not exists ActiveAuthors (name text);

/*delete from ActiveAuthors;
drop trigger activeAuthorInsertion on authored;
drop function triggerFunc;*/

insert into ActiveAuthors(name)
select distinct A.name
from Author A, Authored A2, Publication P
where A.author_id = A2.author_id and A2.pub_id = P.pub_id
	and P.year >= 2018 and P.year <= 2020; 
	

create function triggerFunc()
returns trigger as 
$$
begin 
	if (select Count(*)
		  from Publication P
		  where New.pub_id = P.pub_id
		  	and P.year >= 2018 
		  	and P.year <= 2020) > 0
	then 
		insert into ActiveAuthors(name)
			select A.name
			from Author A
			where New.author_id=A.author_id;
	end if;
	return new;
end
$$
LANGUAGE 'plpgsql';

create trigger activeAuthorInsertion 
after insert on Authored
FOR EACH ROW execute procedure triggerFunc();


/*INSERT INTO Authored(author_id, pub_id)
VALUES
   (940804, 1000195); 

  select count(*) from ActiveAuthors; */