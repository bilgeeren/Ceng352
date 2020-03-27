/*create table if not exists bigTable (
	A varchar(100) not null,
	B varchar(100) not null,
	C int not null,
	D int not null,
	E varchar(100) not null,
	primary key (C,D)
);
*/
CREATE TABLE if not exists AE (
	A varchar(100) not null,
	E varchar(100) not null,
	primary key (A)
);
 
INSERT INTO AE
SELECT distinct A, E FROM bigTable;

CREATE TABLE if not exists CA (
	C int not null,
	A varchar(100) not null,
	primary key (C)
);
 
INSERT INTO CA
SELECT distinct C, A FROM bigTable;

CREATE TABLE if not exists CB (
	C int not null,
	B varchar(100) not null,
	primary key (C)
);
 
INSERT INTO CB
SELECT distinct C, B FROM bigTable;

CREATE TABLE if not exists CD (
	C int not null,
	D int not null
);
 
--INSERT INTO CD
--SELECT C, D FROM bigTable;