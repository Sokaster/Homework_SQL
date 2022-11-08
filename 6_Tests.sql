use Library
go

declare @userEmail nvarchar(20),@authorFirstName nvarchar(20),@authorLastName nvarchar(20),@bookName nvarchar(20)
set @userEmail = 'DmitriyDanone@gmail.com'
set @authorFirstName = N'Tom'
set @authorLastName = N'King'
set @bookName = N'ONO'
execute GiveBookToUser @userEmail,@authorFirstName,@authorLastName,@bookName 

go

declare @userEmail nvarchar(20),@authorFirstName nvarchar(20),@authorLastName nvarchar(20),@bookName nvarchar(20)
set @userEmail = 'DmitriyDanone@gmail.com'
set @authorFirstName = N'Alexandr'
set @authorLastName = N'Pushkin'
set @bookName = N'Captains Daughter'

update UserBooks
set CreatedDate = '2020-09-09' where BookId = (select Id from Books where Name = @bookName)

execute ReturnBook @userEmail,@authorFirstName,@authorLastName,@bookName

go

declare @userEmail nvarchar(20),@authorFirstName nvarchar(20),@authorLastName nvarchar(20),@bookName nvarchar(20)
set @userEmail = 'DmitriyDanone@gmail.com'
set @authorFirstName = N'Tom'
set @authorLastName = N'King'
set @bookName = N'Winsent'

execute ReturnBook @userEmail,@authorFirstName,@authorLastName,@bookName

go

declare @userEmail nvarchar(20),@authorFirstName nvarchar(20),@authorLastName nvarchar(20),@bookName nvarchar(20)
set @userEmail = 'DmitriyDanone@gmail.com'
set @authorFirstName = N'Sergey'
set @authorLastName = N'Esenin'
set @bookName = N'Poems'

update Users
set ExpiredDate = '2021-07-07' where Id = (select Id from UsersInfo where BookName = @bookName)

execute DeleteUsersByExpiredDate 

execute ReturnBook @userEmail,@authorFirstName,@authorLastName,@bookName

execute DeleteUsersByExpiredDate 
