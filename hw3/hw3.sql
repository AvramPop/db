-- a. modify the type of a column;
alter table Theologian add monthly_income int;
select * from Theologian;
update Theologian set monthly_income = 70 where theologian_id = 7;
go
create procedure modifyColumnType
as
		alter table Theologian
		alter column monthly_income  smallint;
go

alter procedure modifyColumnType
as
		alter table Theologian
		alter column monthly_income  smallint;
go

exec modifyColumnType
go
create procedure modifyColumnType_undo
as
		alter table Theologian
		alter column monthly_income  int;
go
exec modifyColumnType_undo

-- b. add / remove a column;
alter table Theologian add removable int;
select * from Theologian;
go
create procedure removeColumn
as
	alter table Theologian
	drop column removable
go
exec removeColumn
go
create procedure removeColumn_undo
as
	alter table Theologian
	add removable int
go
exec removeColumn_undo

-- c. add / remove a DEFAULT constraint;
go
create procedure addDefaultConstraint
as
	ALTER TABLE Theologian
	ADD CONSTRAINT df_Gender
	DEFAULT 'M' FOR gender;
go
exec addDefaultConstraint
go
create procedure addDefaultConstraint_undo
as
	ALTER TABLE Theologian
	drop constraint df_Gender
go
exec addDefaultConstraint_undo
insert into Theologian(name, year_of_birth, church_id, alma_mater_id, institution_id, monthly_income) values ('Karl Barth', 1886, 3, 3, 3, 40);
update Theologian set institution_id = 1 where theologian_id = 9;
select * from Theologian;

-- d. add / remove a primary key;

create table Hobby(
	hobby_id int not null,
	hobby_name varchar(100)
);

drop table Hobby;

go 
create procedure primaryKey
as
	ALTER TABLE Hobby
	ADD PRIMARY KEY (hobby_id);
go
exec primaryKey

go 

go
create procedure primary_undo @SQL varchar(4000) output
as
	SET @SQL = 'ALTER TABLE dbo.Hobby DROP CONSTRAINT hobby_id '

	SET @SQL = REPLACE(@SQL, 'hobby_id', ( SELECT   name
												   FROM     sysobjects
												   WHERE    xtype = 'PK'
															AND parent_obj =        OBJECT_ID('Hobby')))
go
declare @SQL varchar(4000)
EXEC (@SQL)

-- e. add / remove a candidate key;
-- f. add / remove a foreign key;
-- g. create / remove a table.
go
create procedure createMiscTable
as
	create table Misc(
		misc_id int not null,
		misc_name varchar(100),
		primary key (misc_id)
	);
go
exec createMiscTable

go 

create procedure createMiscTable_undo
as
	drop table Misc
go
exec createMiscTable_undo