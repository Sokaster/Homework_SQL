use Library;
go
create or alter view UsersInfo as 
select U.Id,Concat(U.FirstName,' ',U.LastName)as UserFullName,U.Age as UserAge, CONCAT(A.FirstName,' ', A.LastName) as AuthorFullName, 
B.Name as BookName, B.Year as BookYear from UserBooks as UB
		     right join Users as U on UB.UserId = U.Id
	 		 left join Books as B on UB.BookId = B.Id
			 left join Authors as A on B.AuthorId = A.Id


go

create or alter procedure DeleteUsersByExpiredDate as
begin
declare @userFullNameWithBook nvarchar(50)
set @userFullNameWithBook = (select UserFullName from UsersInfo where (select ExpiredDate from Users where UsersInfo.Id = Users.Id)<GETDATE() and BookName is not null)
delete from Users where Id = (select Id from UsersInfo where ExpiredDate < GETDATE() and BookName is null)
end;

go

alter table UserBooks
add ToCharge float(2) not null default 0

go


create or alter procedure GiveBookToUser @userEmail nvarchar(20),
								@authorFirstName nvarchar(20),
								@authorLastName nvarchar(20),
								@bookName nvarchar(20)
as
begin
if((select BookName from UsersInfo where 
(select CONCAT(FirstName,' ',LastName) from Users 
where Email = @userEmail) = UserFullName and BookName = @bookName) = @bookName)
print('Warning! This user contain this book')
else if(not exists(select Name from Books where Name = @bookName))
print('Book is not found')
else if(exists(select BookName from UsersInfo where BookName = @bookName))
print('Book is reserved for another one')
else
insert into UserBooks values
(
(select Id from Users where Email = @userEmail),
(select Id from Books where Name = @bookName),
'1950-03-03',
0
)
end;
go

create or alter function ChargeUser(@dateOfCreating date, @daysCount int = 60) returns money
begin
	declare @charge int
	declare @result float(2)
	set @result = 0
	set @charge = DATEDIFF(d,@dateOfCreating,GETDATE())
	if(@charge = 0) return 0 
	else if(@charge>@daysCount)
	set @result = (@charge-@daysCount) * 2.7
	return @result
end;

go

create or alter procedure ChargingUser @userEmail nvarchar(20),	
									 @bookId int
as
begin
declare @Id int
set @Id = (select Id from Users where Email = @userEmail)
declare @Date date
set @Date = (select CreatedDate from UserBooks where BookId = @bookId)
update UserBooks
set ToCharge = (select dbo.ChargeUser(@Date,60)) where UserId = @Id and BookId = @bookId
end;

go

create or alter procedure ReturnBook @userEmail nvarchar(20),
									 @authorFirstName nvarchar(20),
									 @authorLastName nvarchar(20),
									 @bookName nvarchar(20)
as
begin
declare @bookId int
set @bookId = (select Id from Books where Name = @bookName)
execute ChargingUser @userEmail, @bookId
declare @charge float(2)
set @charge = (select ToCharge from UserBooks where BookId = @bookId)
print(@charge)
delete from UserBooks where BookId = @bookId
end;

go


