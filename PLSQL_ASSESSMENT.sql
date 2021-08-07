use plsql;

-- 1)
CREATE TABLE myemp( Eno INTEGER(4) PRIMARY KEY,Ename VARCHAR(30)NOT NULL,Deptno INTEGER(4) NOT NULL,Esal DECIMAL(8,2));

desc myemp;
-- Field, Type, Null, Key, Default, Extra
-- 'Eno', 'int', 'NO', 'PRI'
-- 'Ename', 'varchar(30)', 'NO', ''
-- 'Deptno', 'int', 'NO', ''
-- 'Esal', 'decimal(8,2)', 'YES', ''

insert into myemp values(1,'latha',101,5500);
insert into myemp values(2,'maria',102,9500);
insert into myemp values(3,'raje',103,4000);
insert into myemp values(4,'komal',104,25000);
insert into myemp values(5,'ravi',105,15000);

select * from myemp;
-- Eno, Ename, Deptno, Esal, Experience, comm, department
-- 1	latha	101	5500.00
-- 2	maria	102	9500.00
-- 3	raje	103	4000.00
-- 4	komal	104	25000.00
-- 5	ravi	105	15000.00

-- (a)
alter table myemp add(Experience integer(2) not null);
desc myemp;

-- Field,		 Type,			 Null, Key
-- 'Eno', 		'int', 			'NO', 'PRI'
-- 'Ename', 	'varchar(30)',  'NO', ''
-- 'Deptno', 	'int', 			'NO', ''
-- 'Esal', 		'decimal(8,2)', 'YES', ''
-- 'Experience', 'int', 		'NO', ''

-- (b)
update myemp set Esal=null where esal between 5000 and 10000;
select * from myemp;


-- OUTPUT
-- Eno, Ename, Deptno,	 Esal, Experience, comm, department
-- 1	latha	101					0
-- 2	maria	102					0
-- 3	raje	103		4000.00		0
-- 4	komal	104		25000.00	0
-- 5	ravi	105		15000.00	0
-- ______________________________________________________________________________________________________________________________________________________________
-- 2)
ALTER TABLE myemp ADD comm integer(10);
desc myemp;
-- Field, Type, Null, Key, Default, Extra
-- Eno	int	NO
-- Ename	varchar(30)	NO
-- Deptno	int	NO
-- Esal	decimal(8,2)	YES
-- Experience	int	NO
-- comm	int	YES

insert into myemp values(6,'subi',106,30000,2,null);
insert into myemp values(7,'bruce',107,20000,1,1000);
insert into myemp values(8,'srubee',108,100000,15,5000);
select * from myemp;
-- Eno, Ename, Deptno, Esal, Experience, comm, department
-- 1	latha	101		0	
-- 2	maria	102		0	
-- 3	raje	103	4000.00	0	
-- 4	komal	104	25000.00	0	
-- 5	ravi	105	15000.00	0	
-- 6	subi	106	30000.00	2	
-- 7	bruce	107	20000.00	1	1000
-- 8	srubee	108	100000.00	15	5000
create table empcommnul LIKE myemp;
delete from myemp where comm is null;
desc empcommnul;
-- Field, Type, Null, Key, Default, Extra
-- Eno	int	NO	PRI
-- Ename	varchar(30)	NO	
-- Deptno	int	NO	
-- Esal	decimal(8,2)	YES	
-- Experience	int	NO	
-- comm	int	YES	
select * from myemp;
-- Eno, Ename, Deptno, Esal, Experience, comm, department
-- 7	bruce	107	20000.00	1	1000
-- 8	srubee	108	100000.00	15	5000
INSERT INTO empcommnul(SELECT  * FROM myemp WHERE comm is null);

select * from empcommnul;
-- OUTPUT
-- Eno, Ename, Deptno, 	Esal, 	Experience, comm
-- 1	latha	101					0	
-- 2	maria	102					0	
-- 3	raje	103		4000.00		0	
-- 4	komal	104		25000.00	0	
-- 5	ravi	105		15000.00	0	
-- 6	subi	106		30000.00	2	
-- __________________________________________________________________________________________________________________________________________________
-- 3)
alter table myemp add department int(4);

desc myemp;
-- Field, Type, Null, Key
-- comm	int	YES	
-- department	int	YES	
-- Deptno	int	NO	
-- Ename	varchar(30)	NO	
-- Eno	int	NO	PRI
-- Esal	decimal(8,2)	YES	
-- Experience	int	NO	
select * from myemp;
-- Eno, Ename, Deptno, Esal, Experience, comm, department
-- 7	bruce	107	20000.00	1	1000	
-- 8	srubee	108	100000.00	15	5000


select * from myemp;

-- Eno, Ename, Deptno, Esal, Experience, comm, department
-- 7	bruce	107	20000.00	1	1000	
-- 8	srubee	108	100000.00	15	5000
	
select department, count(department) from myemp group by department;

-- OUTPUT
-- department, count(department)
-- null				0
-- __________________________________________________________________________________________________________________________________________________
-- 4)
DELIMITER //
create trigger weekdays
 before insert on myemp for each row 
begin
declare day1 varchar(20);
declare day2 varchar(20);
declare day3 varchar(20);
set day1='Saturday';
set day2='Sunday';
set day3=current_date();
if strcmp(day1,dayname(day3))=0 || strcmp(day2,dayname(day3))=0 then
SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Sorry Access on week-end days is denied!';
end if;
end 
//
insert into myemp values(9,'amul',109,22000,3,2000,2);
insert into myemp values(10,'arun',110,80000,20,3000,2);
insert into myemp values(11,'gomathy',111,20000,1,300,1);
insert into myemp values(12,'akash',112,30000,3,300,5);

-- OUTPUT	
-- 	insert into myemp values(9,'amul',109,22000,3,2000,2)	Error Code: 1644. You have no access to insert on week end!	0.000 sec
-- insert into myemp values(10,'arun',110,80000,20,3000,2)	Error Code: 1644. You have no access to insert on week end!	0.000 sec
-- insert into myemp values(12,'akash',112,30000,3,300,3)	Error Code: 1644. You have no access to insert on week end!	0.000 sec
-- insert into myemp values(12,'akash',112,30000,3,300,5)	Error Code: 1644. You have no access to insert on week end!	0.000 sec

-- __________________________________________________________________________________________________________________________________________________
-- 5)

DELIMITER //
create procedure pemp(id int(3))
begin
declare exit handler for not found select 'Error occured';   
select 'Cannot find datas'; 
end
 //

call pemp(1990);

-- OUTPUT:
-- Cannot find datas
-- 'Cannot find datas'

-- __________________________________________________________________________________________________________________________________________________
-- 6)

create table ebill(cno varchar(10) primary key, cname varchar(30) not null, nounits integer(4)not null,bamt decimal(8,2));
desc ebill;
-- cno	varchar(10)	NO	PRI
-- cname	varchar(30)	NO	
-- ncounts	int	NO	
-- bamt	decimal(8,2)	YES	
insert into ebill values('c1','latha',40,null);
insert into ebill values('c2','mani',30,null);
insert into ebill values('c3','bharathi',60,null);
insert into ebill values('c4','abdul',20,null);
insert into ebill values('c5','Greetan',90,null);
select * from ebill;
cno, 	cname, 		ncounts, bamt
-- c1	latha			40
-- c2	mani			30
-- c3	bharathi		60
-- c4	abdul			20
-- c5	Greetan			90

DELIMITER //
create procedure ebillp(in x varchar(10), out y decimal(8,2))
begin
declare done boolean default 0;
declare units int(4);
declare curs cursor for
select ncounts from ebill where cno=x;
open curs;
fetch curs into units;
if units>200 then
set y=(units-200)*1.5+150;
elseif units>100 and units<200 then
set y=(units-100)*1.5+50;
else
set y=units*0.5;
end if;
close curs;
update ebill set bamt=y where cno=x;
select * from ebill where cno=x;
end //

call ebillp('c1', @zz);
-- OUTPUT
-- cno, cname, ncounts, bamt
-- c1	latha	40		20.00







