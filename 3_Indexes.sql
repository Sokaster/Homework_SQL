use Library;
go
create unique nonclustered index IX_UserId_BookId
on UserBooks (UserId asc, BookId asc)

go

create unique nonclustered index IX_Name_AuthorId
on Books(Name asc,AuthorId asc)

go

create unique nonclustered index IX_FirstName_LastName_Country
on Authors(FirstName asc,LastName asc,Country asc)
