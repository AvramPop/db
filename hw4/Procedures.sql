create procedure Insert1 as
begin
	declare @n int, @i int
	declare @denomination_name varchar(50), @headquarters varchar(50)
	declare @firstId int
	--select @firstId = max(denomination_id) from Denomination
	--set @firstId = @firstId + 1
	set @i = 1
	set @n = (select NoOfRows from TestTables where TableID = 1 and TestID = 1)


	while @i < @n
	begin
		set @denomination_name = 'DenominationName' + convert(varchar(3), @i)
		set @headquarters = 'Headquarters' + convert(varchar(3), @i)
		insert into Denomination(denomination_name, headquartes) values (@denomination_name, @headquarters)
		set @i = @i + 1
		--set @firstId = @firstId + 1
	end

end
go
drop procedure Insert1
execute Insert1 
select * from Denomination
go
create procedure Delete1 as
begin
	declare @n int, @i int
	declare @firstId int
	select @firstId = max(denomination_id) from Denomination
	set @i = 1
	set @n = (select NoOfRows from TestTables where TableID = 1 and TestID = 1)
	set @firstId = @firstId - @n + 2

	while @i < @n
	begin
		delete from Denomination where denomination_id = @firstId
		set @i = @i + 1
		set @firstId = @firstId + 1
	end

end
go
drop procedure Delete1
execute Delete1
go
create procedure Insert2 as
begin
	declare @n int, @i int
	set @i = 1
	set @n = (select NoOfRows from TestTables where TableID = 2 and TestID = 2)
	declare @book_name varchar(50), @year_published int
	declare @publisherKey int
	set @publisherKey = (select max(publisher_id) from Publisher)
	declare @firstId int
	--select @firstId = max(book_id) from Book
	--set @firstId = @firstId + 1

	while @i < @n
	begin
		set @book_name = 'Name' + convert(varchar(3), @i)
		set @year_published = 2000 + @i
		insert into Book(name, year_published, publisher_id) values (@book_name, @year_published, @publisherKey)

		set @i = @i + 1
		--set @firstId = @firstId + 1
	end

end
go 
drop procedure Insert2
execute Insert2
select * from Book
go
create procedure Delete2 as
begin
	declare @n int, @i int
	set @i = 1
	set @n = (select NoOfRows from TestTables where TableID = 2 and TestID = 2)
	declare @firstId int
	select @firstId = max(book_id) from Book
	set @firstId = @firstId - @n + 2

	while @i < @n
	begin
		delete from Book where book_id = @firstId

		set @i = @i + 1
		set @firstId = @firstId + 1
	end

end
go 
drop procedure Delete2
execute Delete2
go
create procedure Insert3 as
begin
	declare @n int, @i int
	set @i = 1
	set @n = (select NoOfRows from TestTables where TableID = 3 and TestID = 3)
	declare @book_id int, @author_id int
	declare @valuesCount int
	set @valuesCount = (select count(Theologian.theologian_id) from Theologian cross join Book)

	if @n > @valuesCount 
	begin 
		set @n = @valuesCount
	end

	while @i < @n
	begin
		select @book_id = book_id from (select Theologian.theologian_id, Book.book_id, id = ROW_NUMBER() over (order by Book.book_id) from Theologian cross join Book) sub where id = @i
		select @author_id = theologian_id from (select Theologian.theologian_id, Book.book_id, id = ROW_NUMBER() over (order by Book.book_id) from Theologian cross join Book) sub where id = @i
		insert into Publishing_contract(author_id, book_id) values (@author_id, @book_id)

		set @i = @i + 1
	end

end
drop procedure Insert3
select * from Publishing_contract
execute Insert3
go
create procedure Delete3 as
begin
	declare @n int, @i int
	set @i = 1
	set @n = (select NoOfRows from TestTables where TableID = 3 and TestID = 3)
	declare @book_id int, @author_id int
	declare @maxContractId int

	while @i < @n
	begin
		select @book_id = book_id from (select Theologian.theologian_id, Book.book_id, id = ROW_NUMBER() over (order by Book.book_id) from Theologian cross join Book) sub where id = @i
		select @author_id = theologian_id from (select Theologian.theologian_id, Book.book_id, id = ROW_NUMBER() over (order by Book.book_id) from Theologian cross join Book) sub where id = @i
		delete from Publishing_contract where author_id = @author_id and book_id = @book_id
		set @i = @i + 1
	end

end
go
execute Delete3
go

execute Delete3
execute Delete2
execute Delete1
execute Insert1
execute Insert2
execute Insert3


select * from Denomination
select * from Book
select * from Publishing_contract


