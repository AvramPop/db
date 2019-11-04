create database Theologians_database
GO
use Theologians_database
GO
create table Topic(
topic_id INT PRIMARY KEY identity,
topic_name varchar(20) not null)

create table Institution(
institution_id INT PRIMARY KEY identity,
institution_name varchar(50) not null,
institution_location varchar(50))

create table Denomination(
denomination_id INT PRIMARY KEY identity,
denomination_name varchar(50) not null,
headquartes varchar(50))

create table Publisher(
publisher_id INT PRIMARY KEY identity,
publisher_name varchar(20) not null,
publisher_location varchar(30) not null)


create table Book(
book_id int primary key identity,
name varchar(50) not null,
year_published int not null,
publisher_id int foreign key references Publisher(publisher_id)
)

create table Church(
church_id int primary key identity,
name varchar(50) not null,
address varchar(50),
denomination_id int foreign key references Denomination(denomination_id)
)

create table Theologian(
theologian_id int primary key identity,
name varchar(30) not null,
year_of_birth int,
gender varchar(1),
church_id int foreign key references Church(church_id),
alma_mater_id int foreign key references Institution(institution_id),
institution_id int foreign key references Institution(institution_id)
)
create table Publishing_contract(
author_id int foreign key references Theologian(theologian_id),
book_id int foreign key references Book(book_id)
constraint contract_id PRIMARY KEY(author_id, book_id)
)
create table Conference(
conference_id int primary key identity,
conference_name varchar(50) not null,
speaker int foreign key references Theologian(theologian_id)
)

create table Interest(
theologian_id int foreign key references Theologian(theologian_id),
topic_id int foreign key references Topic(topic_id),
constraint interest_id Primary key(theologian_id, topic_id)
)

