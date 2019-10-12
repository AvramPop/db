create database Hospital
GO
use Hospital
GO
create table Room(
Rid INT PRIMARY KEY,
Capacity INT DEFAULT 8)
create table Pacient(
Pid int primary key identity,
Name varchar(50) not null,
Gender varchar(10),
Age int check(Age > 0 and Age <= 18),
Rid int foreign key references Room(Rid)
)
create table Doctor(
Did int primary key identity,
Name varchar(50) not null,
Specialisation varchar(100) not null
)
create table Medical_Record(
Pid int foreign key references Pacient(Pid),
Did int foreign key references Doctor(Did),
Disease varchar(70),
Solved bit, 
constraint pk_Medical_Record PRIMARY KEY(Pid, Did)
)
create table Pay_bill(
Payid int foreign key references Pacient(Pid),
Amount float,
constraint pk_Pay_bill primary key(Payid)
)