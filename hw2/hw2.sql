--- inserts
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
 insert into Interest(theologian_id, topic_id) values (7, 2)

 insert into Publishing_contract(author_id, book_id) values (1, 1)
 insert into Publishing_contract(author_id, book_id) values (2, 3)
 insert into Publishing_contract(author_id, book_id) values (7, 3)
 insert into Publishing_contract(author_id, book_id) values (2, 2)
 insert into Publishing_contract(author_id, book_id) values (3, 2) --- violates a referential integrity constraints

update Conference set speaker = 1 where conference_id = 1
update Book set name = 'Arminian Theology. Abdridged edition' where book_id = 1
update Conference set conference_name = 'Revoice 2' where conference_id = 1
update Conference set conference_name = 'Revoice 3' where conference_id = 1 AND conference_name = 'Revoice 2'
update Theologian set name = 'Dallas Albert Willard' where year_of_birth < 1940
update Conference set conference_name = 'Revoice 4' where conference_name like 'Revoice'
update Theologian set name = 'Roger E. Olson' where year_of_birth between 1954 and 1956
update Church set name = 'Salem Black Church' where name = 'Salem' and address is not null
update Church set address = 'Brooklyn, NY' where name in('Salem Black Church', 'Smyrna')

delete from Topic where topic_id = 4
delete from Institution where institution_id = 4


select * from Theologian where year_of_birth < 1950 union select * from Theologian where alma_mater_id = 1
select * from Church where denomination_id = 1 union all select * from Church where denomination_id = 2

select * from Theologian where year_of_birth < 1950 intersect select * from Theologian where institution_id = 1
select * from Book where year_published between 2001 and 2009 intersect select * from Book where publisher_id = 2

select Theologian.name from Theologian where year_of_birth < 1958 except select Theologian.name from Theologian where alma_mater_id = 1
select Book.name from Book where publisher_id = 2 except select Book.name from Book where year_published < 2005

select Church.name, Theologian.name, Denomination.denomination_name from Church inner join Theologian on Church.church_id = Theologian.church_id
	inner join Denomination on Church.denomination_id = Denomination.denomination_id

select Book.name, Topic.topic_name from Book inner join Publishing_contract on Book.book_id = Publishing_contract.book_id 
inner join Interest on Publishing_contract.author_id = Interest.theologian_id
inner join Topic on Interest.topic_id = Topic.topic_id
where Book.year_published < 2010

select Denomination.denomination_name, Church.name from Denomination left join Church on Denomination.denomination_id = Church.church_id

select Theologian.name, Institution.institution_name from Theologian right join Institution on Institution.institution_id = Theologian.alma_mater_id

select Theologian.name 
from Theologian where Theologian.church_id in (
select church_id 
from Church inner join Denomination 
on Church.denomination_id = Denomination.denomination_id 
where Denomination.denomination_name = 'Lutheran')

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


select Theologian.name from Theologian where exists 
(select Theologian.name from Theologian inner join Institution 
on Theologian.alma_mater_id = Institution.institution_id
where Institution.institution_location = 'Illinois')

select Publisher.publisher_name from Publisher
where exists 
(select * from Publisher inner join Book 
on Publisher.publisher_id = Book.publisher_id 
where Book.year_published between 2005 and 2008)
  
select Theologian.name from (select avg(Book.year_published) as year_avg from Book) as Year, Theologian 
where Year.year_avg - Theologian.year_of_birth < 50

select Book.name from (select avg(Theologian.year_of_birth) as year_avg from Theologian) as Year, Book inner join Publishing_contract 
on Book.book_id = Publishing_contract.book_id inner join Theologian on Publishing_contract.author_id = Theologian.theologian_id 
where Theologian.year_of_birth > Year.year_avg

select Publisher.publisher_location from Publisher group by Publisher.publisher_location

select Theologian.theologian_id, max(Theologian.year_of_birth) from Theologian
group by Theologian.theologian_id
having Theologian.theologian_id in 
(select Theologian.theologian_id from Theologian inner join Institution 
on Theologian.alma_mater_id = Institution.institution_id 
where institution_name = 'Wheaton College')

select Book.book_id, max(Book.year_published) 
from Book 
group by Book.book_id
having Book.book_id in
(select Book.book_id from Book inner join Publishing_contract 
on Publishing_contract.book_id = Book.book_id inner join 
Theologian on Theologian.theologian_id = Publishing_contract.author_id where Theologian.year_of_birth < 1950)

select Book.book_id, avg(Book.year_published) 
from Book 
group by Book.book_id
having Book.book_id in
(select Book.book_id from Book inner join Publishing_contract 
on Publishing_contract.book_id = Book.book_id inner join 
Theologian on Theologian.theologian_id = Publishing_contract.author_id where Theologian.alma_mater_id in 
(select Institution.institution_id from Institution inner join Theologian on Theologian.alma_mater_id = Institution.institution_id
where Institution.institution_name = 'Wheaton College'))

--- i. 4 queries using ANY and ALL to introduce a subquery in the WHERE clause; 
--- 2 of them should be rewritten with aggregation operators, while the other 2 should also be expressed with [NOT] IN.

select Theologian.name 
from Theologian
where Theologian.alma_mater_id < any(
select Institution.institution_id from Institution where Institution.institution_location = 'California')

select Publisher.publisher_name 
from Publisher
where Publisher.publisher_id > any(
select Book.publisher_id from Book where Book.year_published > 2009)

select Publisher.publisher_name 
from Publisher
where Publisher.publisher_id = all(
select Book.publisher_id from Book where Book.book_id in (select Book.book_id 
from Book inner join Publishing_contract 
on Publishing_contract.book_id = Book.book_id inner join 
Theologian on Theologian.theologian_id = Publishing_contract.author_id where Theologian.year_of_birth > 1950))


select Publisher.publisher_location 
from Publisher
where Publisher.publisher_id = all(
select Book.publisher_id from Book where Book.book_id in (select Book.book_id 
from Book inner join Publishing_contract 
on Publishing_contract.book_id = Book.book_id inner join 
Theologian on Theologian.theologian_id = Publishing_contract.author_id where Theologian.alma_mater_id in 
(select Institution.institution_id from Institution where Institution.institution_name = 'Fuller Seminary')))