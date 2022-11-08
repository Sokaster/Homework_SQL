use Library
go

insert into Authors values
(N'Sergey',N'Esenin',N'Russia','1933-08-27'),
(N'Alexandr',N'Pushkin',N'Russia','1852-02-15'),
(N'Tom',N'King',N'USA','1993-05-17')

insert into Books values
(N'ONO',
(select Id from Authors where LastName = N'King'),
2012),
(N'Poems',
(select Id from Authors where LastName = N'Esenin'),
1875),
(N'Captains Daughter',
(select Id from Authors where LastName = N'Pushkin'),
1987),
(N'Eugene Onegin',
(select Id from Authors where LastName = N'Pushkin'),
1966),
(N'Winsent',
(select Id from Authors where LastName = N'King'),
1985),
(N'Fairy Tail',
(select Id from Authors where LastName = N'Esenin'),
1875),


insert into Users values
(N'Danenkov',N'Dmitriy','DmitriyDanone@gmail.com','1999-03-09',1,N'Rokossovskogo, 42','1950-03-03'),
(N'Lomeiko',N'Dariya','Dasha@gmail.com','2003-03-11',1,N'Plehanova, 23','1950-03-03'),
(N'Sokolov',N'Andrey','Sokol@gmail.com','1999-11-11',1,N'Intelovo, 12','1950-03-03'),
(N'Ivanova',N'Hanna','Hanna@gmail.com','1996-01-11',1,N'Pushkina, 33','1950-03-03')

insert into UserBooks values
(
(select Id from Users where email = 'DmitriyDanone@gmail.com'),
(select Id from Books where Name = N'ONO'),
'1950-03-03'
),
(
(select Id from Users where email = 'DmitriyDanone@gmail.com'),
(select Id from Books where Name = N'Captains Daughter'),
'1950-03-03'
),
(
(select Id from Users where email = 'Sokol@gmail.com'),
(select Id from Books where Name = N'Winsent'),
'1950-03-03'
),
(
(select Id from Users where email = 'Hanna@gmail.com'),
(select Id from Books where Name = N'Fairy Tail'),
'1950-03-03'
),
(
(select Id from Users where email = 'Dasha@gmail.com'),
(select Id from Books where Name = N'Eugene Onegin'),
'1950-03-03'
),
(
(select Id from Users where email = 'Dasha@gmail.com'),
(select Id from Books where Name = N'Poems'),
'1950-03-03'
)
