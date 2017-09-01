create database db_learning;
use db_learning;

CREATE UNIQUE INDEX Stusno ON Student(Sno desc);

create table Student(
Sno char(9) primary key,
Sname char(20) unique,
Ssex char(2),
Sage smallint,
Sdept char(20)
);

create table Course(
Cno char(9) primary key,
Cname char(20) unique
);

create table SC(
Sno char(9) not null,
Cno char(9) not null,
Cgrade float,
constraint fk_sno foreign key(Sno) references Student(Sno),
constraint fk_cno foreign key(Cno) references Course(Cno)
);

drop table Student cascade;
drop table Course cascade;
drop table SC cascade;

delete from Student;

insert into Student(Sno, Sname, Ssex, Sdept, Sage) values ('201009013', 'Lili', 'M', 'CS', 23);
insert into Student(Sno, Sname, Ssex, Sdept, Sage) values ('201009014', 'Wang', 'F', 'MA', 21);
insert into Student(Sno, Sname, Ssex, Sdept, Sage) values ('201009015', 'Zhang', 'M', 'PH', 22);
insert into Student(Sno, Sname, Ssex, Sdept) values ('201009016', 'Zhao', 'M', 'PH');
insert into Student(Sno, Sname, Ssex, Sdept, Sage) values ('201009017', 'Song', 'M', 'CS', 23);
insert into Student(Sno, Sname, Ssex, Sdept, Sage) values ('201009018', 'Tang', 'F', 'MA', 21);
insert into Student(Sno, Sname, Ssex, Sdept, Sage) values ('201009019', 'Ge', 'M', 'PH', 22);
insert into Student(Sno, Sname, Ssex, Sdept, Sage) values ('201009020', 'Gu', 'F', 'PH', 22);



insert into Course(Cno, Cname) values ('20100001', 'Computer');
insert into Course(Cno, Cname) values ('20100002', 'Math');
insert into Course(Cno, Cname) values ('20100003', 'Physical');
insert into Course(Cno, Cname) values ('20100004', 'Chinese');
insert into Course(Cno, Cname) values ('20100005', 'English');


insert into SC(Sno, Cno, Cgrade) values('201009013', '20100001', 80.5);
insert into SC(Sno, Cno, Cgrade) values('201009013', '20100002', 77);
insert into SC(Sno, Cno, Cgrade) values('201009013', '20100003', 65);
insert into SC(Sno, Cno, Cgrade) values('201009014', '20100001', 87);
insert into SC(Sno, Cno, Cgrade) values('201009014', '20100002', 95);
insert into SC(Sno, Cno, Cgrade) values('201009014', '20100003', 83);
insert into SC(Sno, Cno, Cgrade) values('201009015', '20100001', 90);
insert into SC(Sno, Cno, Cgrade) values('201009015', '20100002', 54);
insert into SC(Sno, Cno, Cgrade) values('201009015', '20100003', 93);
insert into SC(Sno, Cno, Cgrade) values('201009016', '20100001', 97);
insert into SC(Sno, Cno, Cgrade) values('201009016', '20100002', 100);
insert into SC(Sno, Cno, Cgrade) values('201009016', '20100003', 76);
insert into SC(Sno, Cno, Cgrade) values('201009017', '20100001', 88);
insert into SC(Sno, Cno, Cgrade) values('201009017', '20100002', 67);
insert into SC(Sno, Cno, Cgrade) values('201009017', '20100003', 56);
insert into SC(Sno, Cno, Cgrade) values('201009018', '20100001', 80);
insert into SC(Sno, Cno, Cgrade) values('201009018', '20100002', 85);
insert into SC(Sno, Cno, Cgrade) values('201009018', '20100003', 83);
insert into SC(Sno, Cno, Cgrade) values('201009019', '20100001', 78);
insert into SC(Sno, Cno, Cgrade) values('201009019', '20100002', 90);
insert into SC(Sno, Cno, Cgrade) values('201009019', '20100003', 54);

update Student set Sage=22 where Sno='201009013';
delete from Student where Sno='201009020';

select * from Student where Sname='Wang';
select * from Student where Sname like '%ang%';
select * from Student where Sage between 20 and 22;
select Sname, Ssex from Student where Sdept in ('CS', 'MA', 'PH');
select * from Student where Sage is null;
select * from Student order by Sage;
select * from Student order by Sdept, Sage desc;
select * from Student limit 2;
select * from Student limit 2, 5;
select Sage, count(*) from Student group by Sage;
select Sage, count(*) from Student group by Sage having count(*) > 1;
select Student.*, SC.* from Student, SC where Student.Sno=SC.Sno;
select Student.*, SC.* from Student left join SC on (Student.Sno=SC.Sno);

alter table Student drop column Sage;
alter table Student add Sentrance date;
alter table Student modify column Sage int;
alter table Student add unique(Sname);
truncate table SC;

SELECT * FROM db_learning.student;
SELECT * FROM db_learning.course;

create unique index Stusno ON Student(Sno desc);
alter table Student drop index Stusno;


create view cs_student as
select sno, sname from Student where Sdept='CS';

create view cs_student as
select sno, sname from Student where Sdept='CS' with check option;

select * from cs_student;
drop view cs_student;

