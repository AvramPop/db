create table Author (
	aid int primary key identity,
	name varchar(30),
	cnp int unique,
	yob int
)

create table Novel (
	nid int primary key identity,
	name varchar(30),
	pages int
)

create table Writes (
	wid int primary key identity,
	aid int foreign key references Author(aid),
	nid int foreign key references Novel(nid)
)
select * from Author
delete from Author
insert into Author(name, cnp, yob) values ('a', 9, 100)
select * from Novel
delete from Novel
insert into Novel(name, pages) values ('a', 10)
select * from Writes
delete from Writes
insert into Writes(aid, nid) values (10, 38)

--a
select aid from Author order by aid 
-- no index, no data: 0.003283 - clustered index scan
-- no index, data: 0.003283 - clustered index scan
-- index, no data: 0.003287 - clustered index scan
-- index, data: 0.003287 - clustered index scan
-- analysis: a nonclustered index delays clustered scan on primary key ordering, selecting primary key

select aid from Author where aid = 1 
-- no index, no data: 0.003283 - clustered index seek
-- no index, data: 0.003283 - clustered index seek
-- index, no data: 0.003283 - clustered index seek
-- index, data: 0.003283 - clustered index seek
-- analysis: a nonclustered index doesen't affect clustered seek on primary key search, selecting primary key

select cnp from Author order by cnp 
-- no index, no data: 0.003283 - nonclustered index scan
-- no index, data: 0.003287 - nonclustered index scan
-- index, no data: 0.003287 - nonclustered index scan
-- index, data: 0.003287 - nonclustered index scan
-- analysis: data delays execution on ordering on unique key, select unique key

select * from Author order by cnp 
-- no index, no data: 0.003283 (nonclustered index scan 50%) + 0.003283 (clustered key lookup 50%)
-- no index, data: 0.003283 (nonclustered index scan 46%) + 0.003915 (clustered key lookup 54%)
-- index, no data: 0.003287 (nonclustered index scan 46%) + 0.003915 (clustered key lookup 54%)
-- index, data: 0.003287 (nonclustered index scan 46%) + 0.003915 (clustered key lookup 54%)
-- analysis: a nonclustered index/data delays execution CONSIDERABLY on ordering by unique key, selecting *

select yob from Author where cnp = 154 
-- no index, no data: 0.003283 (nonclustered index seek 50%) + 0.003283 (clustered key lookup 50%)
-- no index, data: 0.003283 (nonclustered index seek 50%) + 0.003283 (clustered key lookup 50%)
-- index, no data: 0.003283 (nonclustered index seek 50%) + 0.003283 (clustered key lookup 50%)
-- index, data: 0.003283 (nonclustered index seek 50%) + 0.003283 (clustered key lookup 50%)
-- analysis: a nonclustered index doesn't affect execution, searching unique key, selecting non-unique key with nonclustered index on it

select * from Author order by yob
-- no index, no data: 0.003283 (clustered index scan)
-- no index, data: 0.003283 (clustered index scan)
-- index, no data: 0.003287 (nonclustered index scan 46%) + 0.003915 (clustered key lookup 54%)
-- index, data: 0.003287 (nonclustered index scan 46%) + 0.003915 (clustered key lookup 54%)
-- analysis: a nonclustered index delays execution of ordering by nonclustered index attribute, selecting *

select yob from Author where yob = 154
-- no index, no data: 0.003283 (clustered index scan)
-- no index, data: 0.003283 (clustered index scan)
-- index, no data: 0.003283 (nonclustered index seek)
-- index, data: 0.003283 (nonclustered index seek)
-- analysis: a nonclustered index doesn't affect execution on search by nonclustered index attribute, selecting it



--b
select pages from Novel where pages = 10
--clustered index scan estimated subtree cost: 0.0033216
--nonclustered index seek estimated subtree cost: 0.0032853
-- analysis: a nonclustered index speeds up execution of searching by nonclustered index attribute, selecting it

select pages from Novel order by pages
--clustered index scan estimated subtree cost: 0.0033216
--nonclustered index scan estimated subtree cost: 0.0033216
-- analysis: a nonclustered index doesn't affect execution on ordering by nonclustered attribute, selecting it

select * from Novel order by pages
--clustered index scan estimated subtree cost: 0.0033216 (operator cost: 22%)
--nonclustered index scan estimated subtree cost: 0.0033216 (operator cost: 27%) + clustered key lookup estimated subtree cost: 0.0088 (operator cost: 72%)
-- analysis: a nonclustered index delays execution CONSIDERABLY due to key lookup on ordering by nonclustered index attribute, selecting *

select * from Novel where pages between 80 and 90
--clustered index scan estimated subtree cost: 0.0033216 (same with/ without index on 'pages'), searhing rage on nonclustered index attribute, selecting *

select nid, pages from Novel where pages = 100
--clustered index scan estimated subtree cost: 0.0033216
--nonclustered index seek estimated subtree cost: 0.0033183
-- analysis: a nonclustered index speeds up execution on searching by nonclustered index attribute, selecting it and PK

--c
go
create view TestJoin1
as
select a.name as AuthorName, a.yob, n.name as NovelName, n.pages
from Author a INNER JOIN Writes w ON a.aid = w.wid
INNER JOIN Novel n ON w.wid = n.nid
Where pages BETWEEN 50 and 150 and yob > 12 
go
select * from TestJoin1

-- no index, no data: 0.003283 (clustered index seek 33%) + 0.003283 (clustered index scan 33%) + 0.003283 (clustered index seek 33%)
-- no index, data: 0.003283 (clustered index seek 33%) + 0.003287 (clustered index scan 33%) + 0.003294 (clustered index seek 33%)
-- index, no data: 0.003283 (clustered index seek 33%) + 0.003283 (clustered index scan 33%) + 0.003283 (clustered index seek 33%)
-- index, data: 0.003355 (clustered index seek 33%) + 0.003287 (clustered index scan 33%) + 0.003915 (clustered index seek 33%)
-- analysis: data and nonclustered index slow down join in view, searching on values with nonclustered index

go
create view TestJoin2
as
select a.aid, n.nid, wid
from Author a INNER JOIN Writes w ON a.aid = w.wid
INNER JOIN Novel n ON w.wid = n.nid
Where pages BETWEEN 50 and 150 and yob > 12 
go
select * from TestJoin2

-- no index, no data: 0.003283 (clustered index seek 33%) + 0.003283 (clustered index scan 33%) + 0.003283 (clustered index seek 33%)
-- no index, data: 0.003283 (clustered index seek 33%) + 0.003287 (clustered index scan 33%) + 0.003294 (clustered index seek 33%)
-- index, no data: 0.003283 (clustered index seek 33%) + 0.003283 (clustered index scan 33%) + 0.003283 (clustered index seek 33%)
-- index, data: 0.003355 (clustered index seek 32%) + 0.003287(nonclustered index seek 31%) + 0.003915 (clustered index seek 37%)
-- analysis: a nonclustered index slows down CONSIDERABLY on join when selecting * on searching values with nonclustered index

go
create view TestJoin3
as
select a.aid, n.nid, wid
from Author a INNER JOIN Writes w ON a.aid = w.wid
INNER JOIN Novel n ON w.wid = n.nid
Where a.aid BETWEEN 50 and 150 
go
select * from TestJoin3

-- no index, no data: 0.003283 (clustered index seek 33%) + 0.003283 (clustered index seek 33%) + 0.003283 (clustered index seek 33%)
-- no index, data: 0.003283 (clustered index seek 33%) + 0.003286 (clustered index seek 33%) + 0.003757 (clustered index seek 33%)
-- index, no data: 0.003283 (clustered index seek 33%) + 0.003283 (clustered index seek 33%) + 0.003283 (clustered index seek 33%)
-- index, data: 0.003283 (clustered index seek 32%) + 0.003286 (clustered index seek 32%) + 0.003757 (clustered index seek 36%)
-- analysis: a nonclustered index slows down CONSIDERABLY on join when selecting PKs on searching values with clustered index

