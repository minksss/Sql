select * from departments;


select * from user_constraints
where table_name = 'DEPARTMENTS';

select * from user_cons_columns
where table_name = 'DEPARTMENTS';

desc employees;

select * from user_constraints
where table_name = 'EMPLOYEES';

select * from user_cons_columns
where table_name = 'EMPLOYEES';

desc employees;

--DDL
create table t1(
c1 number primary key, 
c2 varchar2(10) not null,
c3 varchar2(10) unique,  --null허용
c4 varchar2(10)           --null허용
);

insert into t1(c1,c2,c3,c4)
values(1, '윤재은','aa','반장');

insert into t1(c1,c2,c3,c4)
values(2, '윤재은','bb','반장'); --unique constraint (HR.SYS_C007085) violated

select * from user_constraints
where table_name ='T1';

select * from user_cons_columns
where table_name = 'T1';


desc t1;

desc employees;

insert into employees(employee_id, last_name, email, hire_date, job_id)
values (1, 'Jang', 'pobo19','2020-01-06','IT_PROG');


--primary key, unique, not null, foreign key, check
select * from user_constraints
where table_name ='EMPLOYEES';

select * from user_cons_columns
where table_name = 'EMPLOYEES';

select * from user_constraints
where constraint_name = 'JOB_ID_PK';

insert into employees(employee_id, last_name, email, hire_date, job_id)
values (2, 'Jang', 'pobo29','2020-01-06','IT_PROG');

insert into employees(employee_id, last_name, email, hire_date, job_id)
values (2, 'Jang', 'pobo29',sysdate,'IT_PROG');

select * from employees;

insert into departments(department_id, department_name)
values (&aa, &bb);

select * from departments;

desc t1;

insert into t1
select employee_id, first_name, email, substr(phone_number,1,10)
from employees
where department_id = 30;

select * from t1;

create table t2
as
select employee_id, first_name, email, phone_number
from employees
where department_id = 30;

select * from t2;
desc t2;

create table t3
as
select employee_id, first_name, email, phone_number
from employees
where 1=0;

select * from t3;
desc t3;

rollback;

select * from t1;
select * from t2;
select * from t3;



insert into employees(employee_id, last_name, email, hire_date, job_id)
values(7,'정진6','wesdw@naver.com', add_months(sysdate,-1), 'IT_PROG');

create table t5
as 
select employee_id, first_name, email, phone_number
from employees;

select * from employees;

update employees
set first_name = '아무개', phone_number ='1234', salary =100,
    commission_pct = 0.2
    where first_name is null;
    
    select * from employees;
    
    rollback;
    
update employees
set job_id = 'ST_CLERK'
where employee_id = 102;

select *
from employees
where employee_id = 102;

update employees
set hire_date = sysdate-7
where employee_id = 102;

update employees
set job_id = 'IT_PROG'
where employee_id = 102;

select *
from employees
where employee_id = 102;

rollback;

delete from job_history;

select * 
from job_history;

rollback;

select * from departments
where department_name like '%Public%';

select * from employees
where department_id = 70;

select *
from departments 
where manager_id = 204;

create table emp_hire(
empno number,
ename varchar2(10),
hiredate date);

create table emp_mgr(
empno number(4),
ename varchar2(10),
mgr number(4));

insert all
into emp_hire values (empno, ename, hiredate)
into emp_mgr values (empno, ename, mgr)
select *
from emp;

create table emp_sal(
empno number(4),
ename varchar2(10),
sal number(7,2));

delete from emp_hire;
delete from emp_sal;

insert all 
when hiredate>'1982/01/01' then
    into emp_hire values(empno, ename, hiredate)
when sal > 2000 then
    into emp_sal values(empno, ename, sal)
    select * 
    from emp;
    
select * from emp_hire;
select * from emp_sal;  

CREATE TABLE SALES( 
SALES_ID NUMBER(4),
WEEK_ID NUMBER(4),
MON_SALES NUMBER(8, 2),
TUE_SALES NUMBER(8, 2),
WED_SALES NUMBER(8, 2), --전체 자리수가 8이고 , 소수 아래 2자리
THU_SALES NUMBER(8, 2),
FRI_SALES NUMBER(8, 2));

INSERT INTO SALES VALUES 
(1001, 1, 200, 100, 300, 400, 500);
INSERT INTO SALES VALUES 
(1002, 2, 100, 300, 200, 500, 350);

select * from sales;
desc employees
select * from employees
where employee_id = 100;
update employees 
set salary = 99999999
where employee_id = 100;
rollback;




CREATE TABLE SALES_DATA( 
SALES_ID NUMBER(4),
WEEK_ID NUMBER(4),
DAILY_ID NUMBER(4), 
SALES NUMBER(8, 2));

INSERT ALL
INTO SALES_DATA VALUES(SALES_ID, WEEK_ID, 1, MON_SALES)
INTO SALES_DATA VALUES(SALES_ID, WEEK_ID, 2, TUE_SALES)
INTO SALES_DATA VALUES(SALES_ID, WEEK_ID, 3, WED_SALES)
INTO SALES_DATA VALUES(SALES_ID, WEEK_ID, 4, THU_SALES)
INTO SALES_DATA VALUES(SALES_ID, WEEK_ID, 5, FRI_SALES)
SELECT SALES_ID, WEEK_ID, MON_SALES, TUE_SALES, WED_SALES,
THU_SALES, FRI_SALES 
FROM SALES;

select * from sales_data 
order by 2;
rollback;


select *
from emp
where job = 'MANAGER';

CREATE TABLE EMP01
AS 
SELECT * FROM EMP;

CREATE TABLE EMP02
AS
SELECT * FROM EMP
WHERE JOB='MANAGER';

UPDATE EMP02
SET JOB='TEST‘;

INSERT INTO EMP02
VALUES(8000, 'SYJ', 'TOP', 7566, '2009/01/12', 1200, 10, 20);

desc emp02;
select * from emp01;
select * from emp02;

MERGE INTO EMP01
USING EMP02
ON(EMP01.EMPNO=EMP02.EMPNO)
WHEN MATCHED THEN
UPDATE SET
EMP01.ENAME=EMP02.ENAME,
EMP01.JOB=EMP02.JOB,
EMP01.MGR=EMP02.MGR,
EMP01.HIREDATE=EMP02.HIREDATE,
EMP01.SAL=EMP02.SAL,
EMP01.COMM=EMP02.COMM,
EMP01.DEPTNO=EMP02.DEPTNO
WHEN NOT MATCHED THEN
INSERT VALUES(EMP02.EMPNO, EMP02.ENAME, EMP02.JOB, 
EMP02.MGR, EMP02.HIREDATE, EMP02.SAL, 
EMP02.COMM, EMP02.DEPTNO);

select * from emp02;

select * from emp01;



delete from emp01;


--ddl문장 쓰면 자동 커밋

rollback;

create table emp4
as 
select * from emp;

select * from emp4;
 
delete from emp4 where deptno = 10;
commit;

select * from emp_sal;
delete from emp_sal;
savepoint aa;s
delete from emp4 where deptno = 20;
savepoint bb;
delete from emp4 where deptno = 30;
select * from emp4;
rollback to bb;
commit;
rollback to aa;

select salary,first_name from employees where employee_id = 100;
update employees 
set first_name = '스티븐' where employee_id = 100;
commit;

update employees 
set first_name = '스티븐2',
salary = 60000 
where employee_id = 100;

rollback;

select * from employees
where job_id = 'SA_REP'
for update;

rollback;

create table copy_emp 
as 
select* from emp where 1 = 0;

select * from copy_emp;

 INSERT INTO copy_emp ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
VALUES ( 7369, 'SMITH', 'CLERK', 7902, TO_DATE('80/12/17','RR/MM/DD') , 800, NULL, 20 ) ;

INSERT INTO copy_emp ( empno, ename, hiredate, deptno )
VALUES ( 7499, 'ALLEN', SYSDATE, 30 ) ;

INSERT INTO copy_emp
SELECT * FROM emp
WHERE deptno = 10 ;

commit;

UPDATE copy_emp
SET sal = 5000
WHERE empno = 7369 ;

 UPDATE copy_emp
SET hiredate = SYSDATE , comm = NULL
WHERE empno = 7369 ;

 UPDATE copy_emp
SET deptno = 50 ;

 SELECT * FROM copy_emp ;
 
 rollback;
 
 update copy_emp
 set hiredate = (select hiredate from emp
                    where empno = 7499);
                    
                    UPDATE copy_emp
SET (job, mgr, sal, comm) = ( SELECT job, mgr, sal, comm
FROM emp
WHERE empno = 7499 )
WHERE empno = 7499 ;
select * from copy_emp;
p
WHERE empno = 7499 ;

commit;

select * from copy_emp;

delete copy_emp;

DELETE copy_emp
WHERE deptno = ( SELECT deptno FROM emp
WHERE empno = 7839 ) ;


rollback;

SELECT * FROM salgrade ;

truncate table salgrade;

rollback;


UPDATE copy_emp
SET sal = 6000
WHERE empno = 7369;

SAVEPOINT update_done ;

delete copy_emp
where empno = 7499;

rollback to update_done;

select * from copy_emp;
rollback;

UPDATE copy_emp
SET sal = 7000
WHERE empno = 7369 ;

ALTER TABLE copy_emp
MODIFY (sal NUMBER(8,2)) ;

SELECT * FROM copy_emp ;


SELECT empno, sal
FROM emp AS OF TIMESTAMP TO_DATE('2013/05/14 16:15:58','YYYY/MM/DD HH24:MI:SS')
WHERE empno = 7788 ;

SELECT empno, ename, sal
FROM copy_emp
WHERE deptno = 10 ;

UPDATE copy_emp
SET sal = 9999
WHERE empno = 7839 ;

SELECT empno, ename, sal
FROM copy_emp
WHERE deptno = 10 ;

SELECT empno, ename, sal
FROM copy_emp
WHERE deptno = 10 ;

SELECT TO_CHAR(SYSDATE,'YYYY/MM/DD HH24:MI:SS') FROM dual ;

update emp
set sal = sal * 1.2
where empno = 7788;

commit;

select empno, sal 
from emp
where empno = 7788;

update emp
set sal = 20000
where empno = 7788;

select * from emp
where empno = 7788;

select empno, sal 
from emp as of timestamp to_date('2020/01/06 16:34:24','YYYY/MM/DD HH24:MI:SS')
where empno = 7788;

SELECT empno, sal
FROM emp AS OF TIMESTAMP ( SYSDATE - INTERVAL '10' MINUTE )
WHERE empno = 7788 ;

 SELECT empno, sal, versions_starttime, versions_endtime, versions_startscn, versions_endscn
FROM emp VERSIONS BETWEEN TIMESTAMP MINVALUE AND MAXVALUE
WHERE empno = 7788 ;

