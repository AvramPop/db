-- a. modify the type of a column;

go
create procedure P1
as
		alter table Theologian
		alter column monthly_income smallint
		print 'Procedure P1: updated type of column monthly income in Theologian to smallint'
go
exec P1
go
create procedure U1
as
		alter table Theologian
		alter column monthly_income int
		print 'Undo Procedure P1: monthly_income in Theologian is back to int'
go
exec U1

-- b. add / remove a column;
go
create procedure P2
as
	alter table Theologian
	add pet_name varchar(100)
	print 'Procedure P2: add column pet name to Theologian'
go
exec P2
go
create procedure U2
as
	alter table Theologian
	drop column pet_name
	print 'Undo Procedure 2: remove column pet_name in Theologian'
go
exec U2

-- c. add / remove a DEFAULT constraint;
go
create procedure P3
as
	ALTER TABLE Theologian
	ADD CONSTRAINT df_Gender
	DEFAULT 'M' FOR gender
	print 'Procedure P3: constraint default gender in theologian be M'
go
exec P3
go
create procedure U3
as
	ALTER TABLE Theologian
	drop constraint df_Gender
	print 'Undo Procedure P3: remove default constraint of gender in theologian be M'
go
exec U3


-- d. add / remove a primary key;

go 
create procedure P4
as
	ALTER TABLE Hobby
	ADD CONSTRAINT PK_Hobby PRIMARY KEY (hobby_id)
	print 'Procedure P4: add id as primary key to hobby'
go

exec P4

go 
create procedure U4
as
	ALTER TABLE Hobby
	DROP CONSTRAINT PK_Hobby
	print 'Undo Procedure P4: drop primary key of hobby'
go
exec U4


-- e. add / remove a candidate key;

go
create procedure P5
as
	ALTER TABLE Theological_area ADD CONSTRAINT TA_name_unique UNIQUE (name)
	print 'Procedure P5: add candidate key name to theological_area'
go
exec P5
go
create procedure U5
as
	ALTER TABLE Theological_area DROP CONSTRAINT TA_name_unique
	print 'Undo procedure P5: remove candidate key name in theological area'
go
exec U5

-- f. add / remove a foreign key;
go 
create procedure P6
as
	ALTER TABLE Parishoner
	ADD CONSTRAINT FK_Church_id
	FOREIGN KEY (church_id) REFERENCES Church(church_id)
	print 'Procedure P6: add foreign key church_id referencind Church(church_id) in Parishoner'
go
exec P6
go
create procedure U6
as
	ALTER TABLE Parishoner
	DROP CONSTRAINT FK_Church_id
	print 'Undo Procedure P6: remove foreign key church_id in Parishoner'
go
exec U6
-- g. create / remove a table.
go
create procedure P7
as
	create table Misc(
		misc_id int not null,
		misc_name varchar(100),
		primary key (misc_id)
	)
	print 'Procedure P7: create table Misc'
go
exec P7

go 

create procedure U7
as
	drop table Misc
	print 'Undo Procedure P7: drop table Misc'
go
exec U7

--version table
create table Version(
	version_id int identity,
	version int default 0,
	primary key(version_id) 
);
go

create procedure main @versionToReach int
as
	declare @currentVersion int
	declare @currentVersionToVarchar varchar(50)
	declare @versionToReachToVarchar varchar(50)
	declare @queryToExecute varchar(100)
	set @queryToExecute = ''
	select @versionToReachToVarchar = CONVERT(varchar(50), @versionToReach)
	select @currentVersion = version from Version
	IF @versionToReach >= 0 and @versionToReach < 8
	BEGIN
		select @currentVersionToVarchar = CONVERT(varchar(50), @currentVersion)
		print 'current version is: ' + @currentVersionToVarchar + '. reaching version:' + @versionToReachToVarchar 
		if @currentVersion < @versionToReach
		begin
			while @currentVersion < @versionToReach
			begin
				print 'was version:' + @currentVersionToVarchar
				set @currentVersion = @currentVersion + 1
				select @currentVersionToVarchar = CONVERT(varchar(50), @currentVersion)
				set @queryToExecute = 'P' + @currentVersionToVarchar
				exec @queryToExecute
				update Version set version = @currentVersion where version_id = 1
				print 'version is now: ' + @currentVersionToVarchar
			end
		end
		else
		begin
			while @currentVersion > @versionToReach
			begin
				print 'was version:' + @currentVersionToVarchar
				select @currentVersionToVarchar = CONVERT(varchar(50), @currentVersion)
				set @queryToExecute = 'U' + @currentVersionToVarchar
				set @currentVersion = @currentVersion - 1
				select @currentVersionToVarchar = CONVERT(varchar(50), @currentVersion)
				exec @queryToExecute
				update Version set version = @currentVersion where version_id = 1
				print 'version is now: ' + @currentVersionToVarchar
			end
		end
	print 'successfully reached version:' + @currentVersionToVarchar + '. Task done'
	END
	else
	begin
		print 'Version to reach is not valid. Should be in [0, 7]'
	end
go
select * from Version
exec main 2