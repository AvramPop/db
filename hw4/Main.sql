create procedure MainTestAux @entries int, @t3 datetime output as
begin
	insert into TestTables(TestID, TableID, NoOfRows, Position) values (1, 1, 3, 1)
	insert into TestTables(TestID, TableID, NoOfRows, Position) values (2, 2, @entries, 1)
	insert into TestTables(TestID, TableID, NoOfRows, Position) values (3, 3, @entries, 1)
	execute Insert1 
	execute Insert2 
	execute Insert3 
	execute Delete3 
	execute Delete2
	execute Delete1
	execute RunView1
	execute RunView2
	execute RunView3
	set @t3 = getdate()

	delete from TestTables where TestId = 1
	delete from TestTables where TestId = 2
	delete from TestTables where TestId = 3
end

drop procedure MainTestAux
go

create procedure MainTest @values int as
begin
	declare @t1 datetime, @t3out datetime
	set @t1 = getdate()
	execute MainTestAux @entries = @values, @t3 = @t3out output
	declare @valuesChar varchar(100)
	set @valuesChar = convert(varchar(100), @values) + ' values'
	insert into TestRuns(Description, StartAt, EndAt) values (@valuesChar, @t1, @t3out)
end
go

drop procedure TestF
select * from TestRuns
execute MainTest @values = 100

select * from Tests
go

create procedure RunTestAux @entries int, @table int, @t2 datetime output as
begin
	insert into TestTables(TestID, TableID, NoOfRows, Position) values (1, @table, @entries, 1)
	declare @insertQuery varchar(50), @deleteQuery varchar(50)
	set @insertQuery = 'execute Insert' + convert(varchar(3), @table)
	set @deleteQuery = 'execute Delete' + convert(varchar(3), @table)
	exec (@insertQuery)
	exec (@deleteQuery)
	set @t2 = getdate()

	delete from TestTables where TestId = 1
end
go
create procedure RunTest @values int, @tableIn int as
begin
	declare @t1 datetime, @t2out datetime
	set @t1 = getdate()
	execute RunTestAux @entries = @values, @table = @tableIn, @t2 = @t2out output
	declare @maxId int
	insert into TestRunTables(TestRunID, TableID, StartAt, EndAt) values (@tableIn, @tableIn, @t1, @t2out)
end
go
execute RunTest @values = 300, @tableIn = 2
select * from TestRunTables

go
create procedure ViewTestAux @table int, @t2 datetime output as
begin
	insert into TestTables(TestID, TableID, NoOfRows, Position) values (1, @table, 0, 1)
	declare @query varchar(50)
	set @query = 'RunView' + convert(varchar(3), @table)
	exec (@query)
	set @t2 = getdate()

	delete from TestTables where TestId = 1
end
go
create procedure ViewTest @tableIn int as
begin
	declare @t1 datetime, @t2out datetime
	set @t1 = getdate()
	execute ViewTestAux @table = @tableIn, @t2 = @t2out output
--	declare @id int
--	select @id = coalesce(max(TestRunId), 0) from TestRunID
--	set @id = @id + 1 
	insert into TestRunViews(TestRunID, ViewID, StartAt, EndAt) values (@tableIn, @tableIn, @t1, @t2out)
end
go
delete from TestRunViews
select * from TestRunViews
execute ViewTest @tableIn = 3