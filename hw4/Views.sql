create view View1 as
	select Name 
	from Theologian
go

create view View2 as
	select Theologian.name as Theologian_name, Book.name as Book_name
	from Theologian inner join Publishing_contract 
	on Theologian.theologian_id = Publishing_contract.author_id
	inner join Book 
	on Publishing_contract.book_id = Book.book_id
	where Theologian.year_of_birth < 1950
go

create view View3 as
	select Denomination.denomination_name, count(Denomination.denomination_name) as Theologians_Count
	from Theologian inner join Church
	on Theologian.church_id = Church.church_id
	inner join Denomination
	on Church.church_id = Denomination.denomination_id
	group by Denomination.denomination_name
go


create procedure RunView1 as
begin
	select * from View1
end
go

create procedure RunView2 as
begin
	select * from View2
end
go

create procedure RunView3 as
begin
 select * from View3
end
go

execute RunView1