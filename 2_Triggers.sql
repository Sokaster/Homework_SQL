use Library;
go
create or alter trigger UserBooksTrigger on UserBooks
after insert 
as update UserBooks
set CreatedDate = getdate();

go

create or alter trigger UsersTriggerDate on Users 
after insert
as update Users
set ExpiredDate = getdate()+365;

go 

create or alter trigger UsersTriggerAge on Users
after insert,update
as update Users
set Age = DATEDIFF(YEAR,BirthDate,getdate());