create database homework_SQL;
go
USE homework_SQL
go
Create table Authors
(
Id INT  PRIMARY KEY IDENTITY(1,1) NOT NULL,
FirstName NVARCHAR(100) NOT NULL,
LastName NVARCHAR(100) NOT NULL,
Country NVARCHAR(100) NOT NULL,
BirthDate Date NOT NULL
)
go
Create table Books
(
Id INT PRIMARY KEY not null,
Name NVARCHAR(100) NOT NULL,
AuthorId INT NOT NULL,
Year DATE NOT NULL
Foreign Key (AuthorId) References Authors (Id)
)
go
Create table Users
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
FirstName NVARCHAR(100) NOT NULL,
LastName NVARCHAR(100) NOT NULL,
Email NVARCHAR(100) NOT NULL UNIQUE,
BirthDate Date NOT NULL,
Age INT NOT NULL,
Address NVARCHAR(100) NOT NULL,
ExpiredDate Date NOT NULL
)
go
Create table UserBooks
(
Id INT NOT NULL,
UserId INT NOT NULL ,
BookId INT NOT NULL ,
CreatedDate Date NOT NULL
Foreign Key (UserId) References Users(Id) ON DELETE CASCADE,
Foreign Key (BookId) References Books(Id) ON DELETE CASCADE
);
CREATE or alter trigger UserBooks_UPD
ON UserBooks
AFTER INSERT, UPDATE
AS 
UPDATE UserBooks
SET CreatedDate=GETDATE()
WHERE ID = (SELECT Id From Inserted);
go
CREATE or alter trigger UsersDate_UPD
On Users
AFTER INSERT, UPDATE
AS
begin
UPDATE Users
Set ExpiredDate=DATEADD(year, 2, ExpiredDate)
WHERE ID = (SELECT Id From Inserted)
UPDATE Users
Set Age = DATEDIFF(year, BirthDate, GETDATE())
WHERE ID = (SELECT Id From Inserted);
end
go
CREATE UNIQUE NONCLUSTERED INDEX BOOKUSERINDEXES
    ON UserBooks (UserId asc ,BookId asc);
GO 
CREATE UNIQUE NONCLUSTERED INDEX NAMEANDAUTHID
    ON Books (Name asc,AuthorId asc);
GO
CREATE UNIQUE NONCLUSTERED INDEX FIRSTLASTCOUNTRY
    ON Authors (FirstName asc,LastName asc,Country asc);
GO
insert into Authors values
(N'Yanka',N'Kupala',N'Belarus',N'1841-09-23'),
(N'Yakub',N'Kolas',N'Belarus',N'1821-03-04'),
(N'Stiven',N'King',N'England',N'1921-01-01'),
(N'Dobrinya',N'Novikov',N'Russia',N'1999-01-03'),
(N'Kolya',N'Lykvinov',N'Ukraine',N'2001-12-12')
go
insert into Books
values 
(N'KNIGA PRO SULTANA',(select Id from Authors where Authors.FirstName = N'Kolya' and Authors.LastName = N'Lykinov'),2012),
(N'MAUGLI',(select Id from Authors where Authors.FirstName = N'Dobrinya' and Authors.LastName = N'Novikov'),2014),
(N'VECHERA NA HUTORE BLIZ DIKANKI',(select Id from Authors where Authors.FirstName = N'Yakub' and Authors.LastName = N'Kolas'),1876),
(N'DROP IT NOW',(select Id from Authors where Authors.FirstName = N'Yanka' and Authors.LastName = N'Kupala'),1863),
(N'TRI BOGATIRYA',(select Id from Authors where Authors.FirstName = N'Dobrinya' and Authors.LastName = N'Novikov'),2013),
(N'ONO',(select Id from Authors where Authors.FirstName = N'Stiven' and Authors.LastName = N'King'), 2001)
Go
insert into Users(FirstName, LastName, Email, BirthDate, Address)
values
(N'Dmitriy',N'Danenkov',N'dmitriy.danenkov@mail.ru',N'1999-03-09',N'Plehanova 2'),
(N'Nikita',N'Ivanov',N'IvanovNik@mail.ru',N'2004-05-24',N'Dostoevskogo 4'),
(N'Dasha',N'Aleksandrova',N'Dashakaramel@gmail.com',N'2000-04-04',N'Pritickogo 5'),
(N'Ivan',N'Nikitich',N'Ivan2@drot.com',N'2003-01-01',N'Pushkina 12'),
(N'Olya',N'Drobisch',N'Olya@net.com',N'2009-02-17',N'Novodvorskogo 7')
go
insert into UserBooks (UserId, BookId)
values
((select Id from Users where Users.FirstName = N'Dmitriy'),(select Id from Books where Books.Name = N'KNIGA PRO SULTANA')),
((select Id from Users where Users.FirstName = N'Nikita'),(select Id from Books where Books.Name = N'MAUGLI')),
((select Id from Users where Users.FirstName = N'Dasha'),(select Id from Books where Books.Name = N'VECHERA NA HUTORE BLIZ DEKANKI')),
((select Id from Users where Users.FirstName = N'Ivan'),(select Id from Books where Books.Name = N'DROP IT NOW')),
((select Id from Users where Users.FirstName = N'Olya'),(select Id from Books where Books.Name = N'TRI BOGATIRYA')),
((select Id from Users where Users.FirstName = N'Dmitriy'),(select Id from Books where Books.Name = N'ONO'))
go
create or alter view UsersInfo as 
	select 
	Users.Id as UserId, 
	concat(Users.FirstName,'  ', Users.LastName) as UserFullName,
	Users.Age as UserAge,
	concat(Authors.FirstName,'  ', Authors.LastName) as AuthorFullName,
	Books.Name as BookName,
	Books.Year as BookYear
	from 
	UserBooks 
		right join Users on Users.Id = UserBooks.UserId
		left join Books on Books.Id = UserBooks.BookId
		left join Authors on Authors.Id = Books.AuthorId;
go
create procedure GiveBookToUser(@Email NVARCHAR(100),@AuthorFirstName NVARCHAR(100),@AuthorLastName NVARCHAR(100),@BookName(100))
as
begin
	declare @EmailStatus int ==iif(@Email in (Select Email from Users),1,0)
	if @EmailStatus = 0
	begin
		print N'NEKORREKTNIY EMAIL,TRY AGAIN';
		return;
	end
declare @AuthorStatus int ==iif (CONCAT(@AuthorFirstName + '  '+@AuthorLastName) IN (Select CONCAT(FirstName,'  ',LastName) from Authors),1,0)
if @AuthorStatus = 0
begin
	print N'Takogo avtora netu =(';
	return;
end
declare @BookId int = (select Id from Books where @BookName = Books.Name)
  if ISNUMERIC(@BookId) = 0
   begin
		print N'neverno vveden ID Knigi'
		return;
	end
declare @AuthorFullName nvarchar(100) = Concat(@AuthorFirstName,'  ', @AuthorLastName)
declare @IdAuthorOfTheBook int = (select AuthorId from Books where @BookId = Books.Id)
if  @IdAuthorOfTheBook <> (select Id from Authors where @AuthorFullName = Concat(FirstName,'  ', LastName)) 
  begin
        declare @AuthorOfThisBook nvarchar(100) = (Select Concat(FirstName,'  ', LastName) from Authors where @IdAuthorOfTheBook = Authors.Id)
		print N'You choose Author - ' + @AuthorOfThisBook
		return;
	end

 declare @IsBookTaken int = iif(@BookId in (Select BookId from UserBooks), 1, 0)
 if @IsBookTaken = 1
	begin
		print N'This book is taken to another guy'
		return;
	end

 insert into UserBooks (UserId, BookId)
 values
 ((select Id from Users where Users.Email = @Email), @BookId)
 print N'name of Book' + @BookName + N'Author' + @AuthorFullName
end
--------
go
alter table UserBooks
 add ToCharge money null
 go
create or alter function GetCharge(@CreationDate date, @BookHoldingDuration int)
    returns money
begin
    declare @Res money, @Status int
	set @Status = DATEDIFF(day, @CreationDate, CONVERT(date, GETDATE()))
    select @Res= iif(@Status > @BookHoldingDuration , (@Status - @BookHoldingDuration) * 2.7, 0)  
    return @Res;
end
go
create or alter procedure ChargeUser @Email nvarchar(100)
as
begin
	declare @Sum int = (select sum(dbo.GetCharge(CreatedDate, 60)) from UserBooks where UserId = (select Id from Users where @Email = Email))
	update UserBooks set ToCharge = @Sum where UserId = (select Id from Users where Email = @Email)
end
go
-----
Create or alter procedure ReturnBook (@Email nvarchar(100),@AuthorFirstName nvarchar(100), @AuthorLastName nvarchar(100), @BookName nvarchar(100))
as
begin
 declare @EmailStatus int = iif(@Email IN (SELECT Email FROM Users), 1, 0)
 if @EmailStatus = 0
	begin
		print N'неверная почта'
		return;
	end

 declare @AuthorStatus int = iif(Concat(@AuthorFirstName, ' ', @AuthorLastName)  IN (Select Concat(FirstName, ' ', LastName) from Authors) ,1,0)
  if @AuthorStatus = 0
	begin
		print N'Такого автора нету'
		return;
	end

 declare @BookId int = (select Id from Books where @BookName = Books.Name)
  if ISNUMERIC(@BookId) = 0
   begin
		print N'Книги нету с данным ид'
		return;
	end

  declare @AuthorFullName nvarchar(100) = Concat(@AuthorFirstName, ' ', @AuthorLastName)
  declare @IdAuthorOfTheBook int = (select AuthorId from Books where @BookId = Books.Id)
  if  @IdAuthorOfTheBook <> (select Id from Authors where @AuthorFullName = Concat(FirstName, ' ', LastName)) 
   begin
        declare @AuthorOfThisBook nvarchar(100) = (Select Concat(FirstName, ' ', LastName) from Authors where @IdAuthorOfTheBook = Authors.Id)
		print N'Вы выбрали книгу - ' + @AuthorOfThisBook
		return;
	end

 declare @IsBookTaken int = iif(@BookId in (Select BookId from UserBooks), 1, 0)
 if @IsBookTaken = 0
	begin
		print N'Книга уже выдана'
		return;
	end

 exec ChargeUser @Email
 declare @ChargeAmount int = (select ToCharge from UserBooks where BookId = @BookId) 
 print concat(N'Пеня ', @ChargeAmount ,N' оплачена')
 delete from UserBooks where BookId = @BookId
end
go
select * from UserInfo
go
exec GiveBookToUser N'dmitriy.danenkov@mail.ru', N'Yanka', N'Kupala', N'DROP IT NOW'
go
exec ReturnBook N'Dashakaramel@gmail.com', N'Yakub', N'Kolas', N'VECHERA NA HUTORE BLIZ DIKANKI'
go
exec ReturnBook N'Ivan2@drot.com', N'Stiven', N'King', N'ONO'
go
delete from Users where ExpiredDate < GETDATE() 
