--insert data – for at least 4 tables; at least one statement should violate referential integrity constraints; 144
insert into Denomination(denomination_name, headquartes) values ('Church of God', 'Cleveland')
insert into Denomination(denomination_name, headquartes) values ('Lutheran', 'Missouri')
insert into Denomination(denomination_name, headquartes) values ('Southern Baptist', 'Texas')

insert into Institution(institution_name, institution_location) values ('Wheaton College', 'Illinois')
insert into Institution(institution_name, institution_location) values ('Fuller Seminary', 'California')
insert into Institution(institution_name, institution_location) values ('Westminster Seminary', 'Pennsylvania')
insert into Institution(institution_name, institution_location) values ('Biola', 'California')


insert into Publisher(publisher_name, publisher_location) values ('Eerdmans', 'Grand Rapids, MI')
insert into Publisher(publisher_name, publisher_location) values ('Zondervan', 'Grand Rapids, MI')
insert into Publisher(publisher_name, publisher_location) values ('Baker', 'Grand Rapids, MI')


insert into Topic(topic_name) values ('soteriology')
insert into Topic(topic_name) values ('genders')
insert into Topic(topic_name) values ('theology proper')
insert into Topic(topic_name) values ('historical theology')

insert into Church(name, address, denomination_id) values ('Christ the Redeemer', 'Bel Air, Maryland', 1)
insert into Church(name, address, denomination_id) values ('King Church', 'London', 1)
insert into Church(name, address, denomination_id) values ('Christ the King', 'Cleveland', 2)
insert into Church(name, address, denomination_id) values ('New Hope Church', 'New York', 3)
insert into Church(name, address, denomination_id) values ('Salem', 'Houston', 3)

insert into Theologian(name, year_of_birth, gender, church_id, alma_mater_id, institution_id) values
	('Roger Olson', 1955, 'M', 1, 1, 1)
insert into Theologian(name, year_of_birth, gender, church_id, alma_mater_id, institution_id) values
	('Tim Keller', 1948, 'M', 2, 2, 3)
insert into Theologian(name, year_of_birth, gender, church_id, alma_mater_id, institution_id) values
	('Eugene Peterson', 1938, 'M', 3, 1, 3)
insert into Theologian(name, year_of_birth, gender, church_id, alma_mater_id, institution_id) values
	('Dallas Willard', 1935, 'M', 4, 1, 1)
insert into Theologian(name, year_of_birth, gender, church_id, alma_mater_id, institution_id) values
	('Mark Noll', 1958, 'M', 5, 2, 2)

ALTER TABLE Theologian
ALTER COLUMN gender char;
 delete from Theologian where theologian_id = 5

 insert into Conference (conference_name, speaker) values ('BMWC',  1)
 insert into Conference (conference_name, speaker) values ('Revoice',  1)
 insert into Conference (conference_name, speaker) values ('Be glad!',  2)

 insert into Book(name, year_published, publisher_id) values ('Arminian Theology', 2008, 1)
 insert into Book(name, year_published, publisher_id) values ('Reason for God', 2009, 2)
 insert into Book(name, year_published, publisher_id) values ('Tell It Slant', 2012, 3)
 insert into Book(name, year_published, publisher_id) values ('The Divine Cconspiracy', 2002, 3)

 insert into Interest(theologian_id, topic_id) values (1, 2)
 insert into Interest(theologian_id, topic_id) values (2, 3)
 insert into Interest(theologian_id, topic_id) values (3, 2)

 insert into Publishing_contract(author_id, book_id) values (1, 1)
 insert into Publishing_contract(author_id, book_id) values (2, 3)
 insert into Publishing_contract(author_id, book_id) values (1, 3)
 insert into Publishing_contract(author_id, book_id) values (2, 2)
 insert into Publishing_contract(author_id, book_id) values (88, 2) --- violates a referential integrity constraints
 --update data – for at least 3 tables;
update Conference set speaker = 1 where conference_id = 1
update Book set name = 'Arminian Theology. Abdridged edition' where book_id = 1
update Conference set conference_name = 'Revoice 2' where conference_id = 1
update Conference set conference_name = 'Revoice 3' where conference_id = 1 AND conference_name = 'Revoice 2'
update Theologian set name = 'Dallas Albert Willard' where year_of_birth < 1940
update Conference set conference_name = 'Revoice 4' where conference_name like 'Revoice'
update Theologian set name = 'Roger E. Olson' where year_of_birth between 1954 and 1956
update Church set name = 'Salem Black Church' where name = 'Salem' and address is not null
update Church set address = 'Brooklyn, NY' where name in('Salem Black Church', 'Smyrna')
--delete data – for at least 2 tables.
delete from Topic where topic_id = 4
delete from Institution where institution_id = 4

--2 queries with the union operation; use UNION [ALL] and OR;
-- All theologians that were born before 1950 or have the alma mater 1 oder by year of birth
select * from Theologian where year_of_birth < 1950 union select * from Theologian where alma_mater_id = 1 order by Theologian.year_of_birth
--- All theologians from denominations with id 1 or 2
select * from Church where denomination_id = 1 union all select * from Church where denomination_id = 2 

--2 queries with the intersection operation; use INTERSECT and IN;
-- All theologians that were born before 1950 and have the alma mater 1
select * from Theologian where year_of_birth < 1950 intersect select * from Theologian where institution_id = 1
-- All books published between 2001 and 2009 by publisher with id 2 ordered ascending
select * from Book where year_published between 2001 and 2009 intersect select * from Book where publisher_id = 2 order by Book.year_published asc

--2 queries with the difference operation; use EXCEPT and NOT IN;
-- All theologians born before 1958 but don't have alma mater id = 1
select distinct Theologian.name from Theologian where year_of_birth < 1958 except select Theologian.name from Theologian where alma_mater_id = 1
-- All books published by publisher with id 2 after 2005
select distinct Book.name from Book where publisher_id = 2 except select Book.name from Book where year_published < 2005

--4 queries with INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN; one query will join at least 3 tables,
--while another one will join at least two many-to-many relationships;
-- Show church and denomination for each theologian
select Church.name, Theologian.name, Denomination.denomination_name from Church inner join Theologian on Church.church_id = Theologian.church_id
	inner join Denomination on Church.denomination_id = Denomination.denomination_id
-- Show distinct book and topic for all books published before 2010
select distinct Book.name, Topic.topic_name from Book inner join Publishing_contract on Book.book_id = Publishing_contract.book_id 
inner join Interest on Publishing_contract.author_id = Interest.theologian_id
inner join Topic on Interest.topic_id = Topic.topic_id
where Book.year_published < 2010

select top 1 Denomination.denomination_name, Church.name from Denomination left join Church on Denomination.denomination_id = Church.church_id

select Theologian.name, Institution.institution_name from Theologian right join Institution on Institution.institution_id = Theologian.alma_mater_id

--2 queries using the IN operator to introduce a subquery in the WHERE clause; 
--in at least one query, the subquery should include a subquery in its own WHERE clause;
--Show all Lutheran theologians
select top 2 Theologian.name 
from Theologian where Theologian.church_id in (
select church_id 
from Church inner join Denomination 
on Church.denomination_id = Denomination.denomination_id 
where Denomination.denomination_name = 'Lutheran')
--Show all publishers that have published books by Lutheran authors
select Publisher.publisher_name 
from Publisher inner join Book 
on Publisher.publisher_id = Book.publisher_id 
where Book.book_id in 
(select Book.book_id from Book inner join Publishing_contract 
on Book.book_id = Publishing_contract.author_id 
inner join Theologian on Publishing_contract.author_id = Theologian.theologian_id 
where Theologian.church_id in 
(select Church.church_id 
from Church inner join Denomination 
on Church.church_id = Denomination.denomination_id 
where Denomination.denomination_name = 'Lutheran'))

--2 queries using the EXISTS operator to introduce a subquery in the WHERE clause;
--All theologians that have alma mater location = 'Illinois'
select Theologian.name from Theologian where exists 
(select * from  Institution 
where Theologian.alma_mater_id = Institution.institution_id
and Institution.institution_location = 'Illinois')
--All Publishers that have books published between 2005 and 2009
select Publisher.publisher_name from Publisher
where exists 
(select * from  Book 
where Publisher.publisher_id = Book.publisher_id 
and Book.year_published between 2005 and 2009)

--2 queries with a subquery in the FROM clause;         
--All theologians that were younger than 50 when their first book was published
select Theologian.name from (select min(Book.year_published) as year --?
from Book inner join Publishing_contract on Book.book_id = Publishing_contract.book_id inner join Theologian 
on Publishing_contract.author_id = Theologian.theologian_id group by Theologian.theologian_id) 
as Year, Theologian 
where Year.year - Theologian.year_of_birth < 50
--All books written by theologians older three quarters of their lives than the average
select Book.name from (select avg(Theologian.year_of_birth) as year_avg from Theologian) as Year, Book inner join Publishing_contract 
on Book.book_id = Publishing_contract.book_id inner join Theologian on Publishing_contract.author_id = Theologian.theologian_id 
where Theologian.year_of_birth * 0.75 > Year.year_avg

--4 queries with the GROUP BY clause, 3 of which also contain the HAVING clause; 
--2 of the latter will also have a subquery in the HAVING clause;
--use the aggregation operators: COUNT, SUM, AVG, MIN, MAX;
--Publishers grouped by publisher location
select Publisher.publisher_location from Publisher group by Publisher.publisher_location
--The youngest theologian that has graduated from Wheaton College
select Theologian.theologian_id, max(Theologian.year_of_birth) from Theologian --?
group by Theologian.theologian_id
having Theologian.theologian_id in 
(select Theologian.theologian_id from Theologian inner join Institution 
on Theologian.alma_mater_id = Institution.institution_id 
where institution_name = 'Wheaton College')
--Books published by theologians born before 1950
select Book.book_id, max(Book.year_published) as year --?
from Book 
group by Book.book_id
having Book.book_id in
(select Book.book_id from Book inner join Publishing_contract 
on Publishing_contract.book_id = Book.book_id inner join 
Theologian on Theologian.theologian_id = Publishing_contract.author_id where Theologian.year_of_birth < 1950)
--Average year published by alumni of Wheaton College
select Book.book_id, avg(Book.year_published) 
from Book 
group by Book.book_id
having Book.book_id in
(select Book.book_id from Book inner join Publishing_contract 
on Publishing_contract.book_id = Book.book_id inner join 
Theologian on Theologian.theologian_id = Publishing_contract.author_id where Theologian.alma_mater_id in 
(select Institution.institution_id from Institution inner join Theologian on Theologian.alma_mater_id = Institution.institution_id
where Institution.institution_name = 'Wheaton College'))

--4 queries using ANY and ALL to introduce a subquery in the WHERE clause; 
--2 of them should be rewritten with aggregation operators, 
--while the other 2 should also be expressed with [NOT] IN.
--Theologians half older than all that graduated from Fuller Seminary
select Theologian.name
from Theologian
where Theologian.year_of_birth < all
(select Theologian.year_of_birth from Theologian inner join Institution 
on Theologian.alma_mater_id = Institution.institution_id where Institution.institution_name = 'Fuller Seminary')
---rewritten with not in
select T.name
from Theologian T
where T.year_of_birth not in
(select T.year_of_birth from Theologian inner join Institution 
on T.alma_mater_id = Institution.institution_id where (Institution.institution_name = 'Fuller Seminary'
and T.year_of_birth > (select min(Theologian.year_of_birth) * 0.5 from Theologian inner join Institution 
on Theologian.alma_mater_id = Institution.institution_id and Institution.institution_name = 'Fuller Seminary')))
--Theologians younger than any that graduated from institution located in California
select Theologian.name 
from Theologian
where Theologian.year_of_birth > any(
select Institution.institution_id from Institution where Institution.institution_location = 'California')
---rewrite with in
select T.name
from Theologian T
where T.year_of_birth not in
(select T.year_of_birth from Theologian inner join Institution 
on T.alma_mater_id = Institution.institution_id where (Institution.institution_location = 'California'
and T.year_of_birth < (select min(Theologian.year_of_birth) from Theologian inner join Institution 
on Theologian.alma_mater_id = Institution.institution_id and Institution.institution_location = 'California')))
--Books published before all written by theologian born after 1950
select Book.name 
from Book
where Book.year_published < all(
select Book.year_published from Book where Book.book_id in (select Book.book_id 
from Book inner join Publishing_contract 
on Publishing_contract.book_id = Book.book_id inner join 
Theologian on Theologian.theologian_id = Publishing_contract.author_id where Theologian.year_of_birth > 1950))
--- rewritten using min
select Book.name 
from Book
where Book.year_published < (
select min(Book.year_published) from Book where Book.book_id in (select Book.book_id 
from Book inner join Publishing_contract 
on Publishing_contract.book_id = Book.book_id inner join 
Theologian on Theologian.theologian_id = Publishing_contract.author_id where Theologian.year_of_birth > 1950))
--Books published before any written by authors from Fuller Seminary
select Book.name 
from Book
where Book.year_published < any(
select Book.year_published from Book where Book.book_id in (select Book.book_id 
from Book inner join Publishing_contract 
on Publishing_contract.book_id = Book.book_id inner join 
Theologian on Theologian.theologian_id = Publishing_contract.author_id where Theologian.alma_mater_id in 
(select Institution.institution_id from Institution where Institution.institution_name = 'Fuller Seminary')))
--- rewritten using max
select Book.name 
from Book
where Book.year_published < (select max(Book.year_published) from Book where Book.book_id in 
(select Book.book_id 
from Book inner join Publishing_contract 
on Publishing_contract.book_id = Book.book_id inner join 
Theologian on Theologian.theologian_id = Publishing_contract.author_id where Theologian.alma_mater_id in 
(select Institution.institution_id from Institution where Institution.institution_name = 'Fuller Seminary')))
