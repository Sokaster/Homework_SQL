create database Library;
go
use Library;
go

create table Authors
(
Id int not null identity(1,1) primary key,
FirstName nvarchar(20) not null,
LastName nvarchar(20) not null,
Country nvarchar(20) not null,
BirthDate date not null,
);

create table Books
(
Id int not null identity(1,1) primary key,
Name nvarchar(20) not null,
AuthorId int not null,
Year int not null,
constraint FK_AuthorId foreign key (AuthorId) references Authors(Id) on delete cascade
);

create table Users
(
Id int not null identity(1,1) primary key,
FirstName nvarchar(20) not null,
LastName nvarchar(20) not null,
Email nvarchar(20) not null unique,
BirthDate date not null,
Age int not null,
Address nvarchar(50) not null,
ExpiredDate date not null
);

create table UserBooks
(
Id int not null identity(1,1) primary key,
UserId int not null,
BookId int not null default 0,
CreatedDate date not null,
constraint FK_UserId foreign key (UserId) references Users(Id) on delete cascade,
constraint FK_BookId foreign key (BookId) references Books(Id) on delete cascade
);
