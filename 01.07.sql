--DDL
--char(2000)byte까지, varchar2(4000)byte까지
create table t1(
c1 char(5), --고정으로 5byte자리
c2 varchar(5) --최대 5byte자리이다
);

insert into t1 values('123','123');
insert into t1 values ('123  ','123  ');
--insert into t1 values ('123456','123456'); 오류
insert into t1 values ('한글','한글'); --오류, 한글은 UTF-8(모든 문자가 3byte로 처리) 

select '*'||c1||'*','*'||c2||'*' from t1;

--자동으로 5자리 ...trim()
select * from t1
where c1 = '123'; -- '123  '와 같다

--값 그대로 사용(가변) 
select * from t1
where c2 = '123';  -- '123'이 값 그대로 조회, 공백 들어간 것 조회 안된다. 



desc locations;
select * from locations
where country_id ='US';

create table t2(
c1 char(2000),
v2 varchar2(4000)
);

-- number 자리수 생략되면 40자리
-- 전체자리수는 소수아래까지 합친수
create table t3(
c1 number,
c2 number(10),
c3 number(10,2)
);

insert into t3 values(
 1234567890123456789012345678901234567890,
 1234567890,
 12345678.90);
 

 insert into t3 values(
 1234567890123456789012345678901234567890123123,
 1234567890,
 12345678.90);
 
 select * from t3;

 -- LOB( lARGE OBJECT라는 뜻)
 -- CLOB, BLOB, BFILE
 create table t4(
 c4 number,
 c1 blob,
 c2 clob,
 c3 bfile
 );
 
 insert into t4 values(1, empty_blob(), empty_clob(),null);
 insert into t4 values(1, hextoraw('1234567890A'), '큰문자',null);
 
 rollback;
 select* from t4;
 
 create directory my_dir as 'c:/desktop/hello';
 insert into t4 values (3,hextoraw('1234567890A'), '큰문자aaa',
                        bfilename('MY_DIR', 'plsql.pdf')
                        );
                        
create table t5(
 c1 date,
 c2 timestamp,
 c3 interval year to month,
 c4 interval day to second
 );
 
 insert into t5 values (sysdate, systimestamp,null,null);
 insert into t5 values (sysdate, systimestamp,interval '1-2' year to month ,interval '01:30' hour to minute  );
 
 
 select * from t5;
 
 select to_char(sysdate, 'yyyy/mmd/dd hh:mi:ss'),
                systimestamp,
                systimestamp - interval '1-2' year to month, --1년 2개월전
                systimestamp - interval '01:30' hour to minute                
                from dual;
 
create table t6(
 c1 number default 100,
 c2 char(1) default 'M',
 c3 varchar2(2) default 'AB',
 c4 date default sysdate
);

insert into t6(c1, c2) values(1,'F');
insert into t6 (c3,c4) values('CC', to_date('2000/01/01'));
select * from t6;

--제약조건 (constraint type)
--not null(C) : null 허용안함
--unique(U) : 해당 테이블에서 값이 유일 (null 허용)
--primary key(P) : not null + unique
--foreign key(F) : 참조키, 외래키, 이미 있는 값을 사용
--check : 조건... 조건 맞으면 허용

drop table t7;
create table t7(
 c1 number(3) constraint pk_t7 primary key, --컬럼 레벨에서의 제약 조건 
 c2 varchar2(10)
);

create table t7(
 c1 number(3),
 c2 varchar2(10),
 constraint pk_t7 primary key (c1,c2) -- 테이블 레벨에서의 제약 조건
);

-- 위 2가지의 어떤 방법이든 상관 없다. 
-- 하지만 있는 경우도 있음. 예를 들어, constraint를 칼럼 정의후 사용, 
-- 프라이머리키가 여러 칼럼인 경우 1번째 방법은 불가능 
insert into t7 values(1, 'A');
insert into t7 values(1, 'B');



select * 
from user_constraints
where table_name = 'T7';

drop table t7;
create table t7(
c1 number(3) constraint pk_t7 primary key,
c2 varchar2(10), --null 허용
c3 varchar2(10) constraint c3_nn not null,
c4 varchar2(10) constraint c4_unique unique, --null 허용
c5 varchar2(10) constraint c5_unique_nn unique not null,
c6 number(2),
salary number(7) constraint salary_chk check(salary>1000),
gender char(1) constraint gender_chk check (gender in ('M','F')),
constraint fk_dept foreign key (c6) 
references dept(deptno)--dept 테이블의 deptno를 참조한다

);


insert into t7(c1,c3,c5) values (1,'A','c');
insert into t7(c1,c3,c4,c5,c6) values (2,'A','zz','c');
insert into t7(c1,c3,c4,c5,c6) values (2,'A','zz','c',10);
insert into t7(c1, c3, c5) values (1,'a','c');
insert into t7(c1, c3, c5,salary,gender) values (1,'a','c',860,'G');
insert into t7(c1, c3, c5,salary,gender) values (12,'a','csd',1200,'F');

-- 순서 check, primary, uniqe
select * from t7;

select * from t7;

 
select * 
from user_constraints
where table_name = 'T7';

desc dept;


select * 
from user_constraints
where table_name = 'DEPT';

select * 
from user_cons_columns
where table_name = 'DEPT';

select constraint_type, search_condition, column_name
from user_constraints join user_cons_columns using(owner, constraint_name, table_name)
where table_name = 'DEPT';

select * from dept; -- 부모
select distinct deptno from emp; --자식

--foreign key 설정된 경우
--default : 자식 record 없으면 지워짐, 자식 있으면 삭제 불가능 
delete from dept where deptno = 20;
delete from dept where deptno = 40;

--부모 테이블 
create table parentTBL(
    c1 number(2) primary key,
    c2 varchar2(30) 
);
--자식 테이블]
drop table childTBL;
create table childTBL(
 c1 number(2) primary key,
 c2 varchar2(30), 
 c3 number(2) constraint childTBL_fk references parentTBL(c1)
    on delete set null
);
-- on delete set null 부모 삭제시 자식 칼럼 값 null
-- on delete cascade 부모 삭제시 자식 삭제
-- default는 자식이 없는 부모 삭제 불가
insert into parentTBL values (10, '개발부');
insert into parentTBL values (20, '영업부');
insert into parentTBL values (30, '사업부');
select * from parentTBL;

delete from parentTBL where c1 = 30;
delete from parentTBL where c1 = 20;
delete from parentTBL where c1 = 30;

insert into childTBL values (1, 'A', 10);
insert into childTBL values (2, 'B', 10);
insert into childTBL values (3, 'C', 20);

select * from childTBL;

drop table player_t;
create table player_t (
    player_id char(7) constraint PLAYER_ID_PK primary key
    , team_id char(3) constraint team_id_nn not null
        constraint team_id_fk references team_t(team_id)
    , player_name varchar2(20)
    , nickname varchar2(40)
    , join_yyyy char(4) constraint join_yyyy_chk check( length(trim(join_yyyy))=4)
    , position char(2) constraint position_chk check (position in ('MF','DF','ST'))
    , back_no number(2)
    , nation varchar2(20)
    , birth date
    , solar char(3) constraint solar_chk check (solar in ('양','음'))
    , height number(3)
    , weight number(3) constraint weight_chk check (weight >= 50 and weight <=110)
);

insert into team_t(team_id, region_name, stadium_id, team_name)
values ('A01','전남','BBB','드레곤즈');

insert into player_t(player_id, team_id, player_name,join_yyyy)
values ('0003','A01','jmk','2020');

insert into player_t(player_id, team_id, player_name,join_yyyy, position, solar)
values ('0005','A01','jmk','2020','MF','양');


select * from player_t;
 select * from team_t;


drop table team_t;
create table team_t(
    team_id char(3) 
    , region_name varchar2(12) not null
    , stadium_id char(3) not null
    , team_name varchar2(20) not null
    , e_team_name varchar2(50)
    , orig_yyyy char(4)
    , owner varchar2(10)
    , zip_code1 char(3)
    , zip_code2 char(3)
    , address  varchar2(60)
    , ddd varchar2(3)
    , tel varchar2(10)
    , fax varchar2(10)
    , homepage varchar2(50)
    , constraint TEAM_ID_PK primary key (team_id)
);


desc employees;

select *
from user_constraints join user_cons_columns
using(owner, constraint_name, table_name)
where table_name = 'EMP_BACKUP60';
-- EMPLOYEES 제약조건 10개 (p,c,r,U)
-- not null 제약만 복사된다 

create table emp_backup60
as
select * from employees
where department_id = 60;

select * from emp_backup60;

insert into emp_backup60(last_name, email, hire_date, job_id)
values('aa','bb',sysdate,'cc');

drop table emp_backup60;
create table emp_backup60
as 
select employee_id, first_name, salary, hire_date,0 bonus 
from employees
where department_id =60;

create table emp_backup62(empid,fname,sal,hdate, bonus)
as 
select employee_id, first_name, salary, hire_date,0 bonus 
from employees
where department_id =60;

desc emp_backup62;
select * from emp_backup62;

alter table emp_backup60 read only;
alter table emp_backup60 read write;

select rowid,emp_backup60.* from emp_backup60
where employee_id = 103;

desc emp_backup60;

alter table emp_backup60
modify (추가칼럼 varchar(30), adcol2 number(30));

select * from emp_backup60;

update emp_backup60
set 추가칼럼 = '12345678465464649', adcol2 = 04040468468468440;

alter table emp_backup60
drop column adcol2;

delete from emp_backup60;
rollback;

truncate table emp_backup60; --truncate하면 롤백은 소용없다.

select * from user_constraints;


select * 
from all_constraints;

select *
from dba_constraints;

--table, view, sequence, index, synonym .... 
select *
from user_objects;

show user;

CREATE TABLE MEMBER01 (
NAME VARCHAR2(10),
ADDRESS VARCHAR2(30),
HPHONE VARCHAR2(16),
CONSTRAINT MEMBER01_COMBO_PK PRIMARY KEY(NAME, HPHONE)
);

DESC MEMBER01;

INSERT INTO MEMBER01 VALUES ('김','역삼동','010-5258-5258');
INSERT INTO MEMBER01 VALUES ('박','역삼동','010-5258-5238');
INSERT INTO MEMBER01 VALUES ('김','역삼동','010-5258-5258');

SELECT * FROM MEMBER01;

ALTER TABLE MEMBER01
DROP CONSTRAINT MEMBER01_COMBO_PK; 

ALTER TABLE MEMBER01
ADD CONSTRAINT MEMBER01_COMBO_PK PRIMARY KEY(NAME, HPHONE);

ALTER TABLE MEMBER01
ADD NAME CONSTRAINT MEMBER01_PK PRIMARY KEY;

SELECT * 
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'MEMBER01';


CREATE TABLE DEPT01(
DEPTNO NUMBER(2) CONSTRAINT DEPT01_DEPTNO_PK PRIMARY KEY,
DNAME VARCHAR2(14),
LOC VARCHAR2(13)
);

CREATE TABLE EMP01( 
EMPNO NUMBER(4) 
CONSTRAINT EMP01_EMPNO_PK PRIMARY KEY ,
ENAME VARCHAR2(10) 
CONSTRAINT EMP01_ENAME_NN NOT NULL, 
JOB VARCHAR2(9), 
DEPTNO NUMBER(4) 
CONSTRAINT EMP01_DEPTNO_FK REFERENCES DEPT01(DEPTNO)
); 

INSERT INTO EMP01 VALUES(7499, 'ALLEN', 'SALESMAN', 10);
INSERT INTO EMP01 VALUES(7369, 'SMITH', 'CLERK', 20);
INSERT INTO EMP01 VALUES(7269, 'SITH', 'CERK', 30);


DELETE FROM DEPT01 WHERE DEPTNO=10;

ALTER TABLE EMP01
DISABLE CONSTRAINT EMP01_DEPTNO_FK;


ALTER TABLE EMP01
ENABLE CONSTRAINT EMP01_DEPTNO_FK;

SELECT * FROM EMP01;

SELECT *
FROM USER_CONSTRAINTS
WHERE CONSTRAINT_NAME = 'EMP01_DEPTNO_FK';

INSERT INTO DEPT01
VALUES(10, 'ACCOUNTING', 'NEW YORK');

INSERT INTO DEPT01
VALUES(20, 'AOUNTING', 'NEW YORK');
SELECT * FROM DEPT01;

SELECT * FROM T1;
DROP TABLE T1;

CREATE TABLE T1(
    C1 CHAR(5)
    , C2 VARCHAR(5)
    , C3 LONG
    , C4 CLOB
    );
    
    DESC T1;
    
    INSERT INTO T1 VALUES('ABC', 'ABC', 'ABC', 'ABC');
    
    SELECT * FROM T1;   
    
    select LENGTH(C1), LENGTH(C2), DUMP(C1), DUMP(C2) FROM T1;

    SELECT C1, C2 FROM T1 WHERE C2 = 'ABC';
    SELECT C1, C2 FROM T1 WHERE C1 = 'ABC';
    SELECT C1, C2 FROM T1 WHERE C1 = C2;
    SELECT C1, C2 FROM T1 WHERE TRIM(C1) = C2;
        
    ALTER TABLE T1 
    ADD (C5 LONG);
    
    SELECT TABLE_NAME, COLUMN_NAME, SEGMENT_NAME
    FROM USER_LOBS;
    
    ALTER TABLE T1
    ADD (C5 CLOB);
    
    DESC T1;
    
    SELECT TABLE_NAME, COLUMN_NAME, SEGMENT_NAME
    FROM USER_LOBS;

    SELECT object_name, object_type
    FROM user_objects
    WHERE object_name LIKE 'SYS%' ;
    
    CREATE TABLE T2
    ( c1 NUMBER,
        c2 NUMBER(4,2),
        c3 NUMBER(4,0),
        c4 NUMBER(2,4),
        c5 NUMBER(3,-1) ) ;
        
     INSERT INTO t2
VALUES (999999.999999 , 99.99, 9999, 0.0099, 9990) ;
INSERT INTO t2 (c2)
VALUES (999.99) ;
SELECT * FROM T2;

DROP TABLE T3;
CREATE TABLE t3
( c1 DATE,
c2 TIMESTAMP,
c3 TIMESTAMP WITH TIME ZONE,
c4 TIMESTAMP WITH LOCAL TIME ZONE,
c5 INTERVAL YEAR TO MONTH,
c6 INTERVAL DAY TO SECOND ) ;

SELECT dbtimezone, sessiontimezone FROM dual ;

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-RR HH24:MI:SS' ;
SELECT SYSDATE, SYSTIMESTAMP FROM dual ;

SELECT CURRENT_DATE, CURRENT_TIMESTAMP FROM DUAL;

ALTER SESSION SET TIME_ZONE = '-10:00';

INSERT INTO t3 (c1,c2,c3,c4)
VALUES (SYSTIMESTAMP, SYSTIMESTAMP, SYSTIMESTAMP, SYSTIMESTAMP) ;
SELECT c1,c2,c3,c4 FROM t3 ;

UPDATE T3
SET C5 = '1-5', C6 = '5 15:11:10';
SELECT * FROM T3;

SELECT SYSDATE, SYSDATE + TO_YMINTERVAL ('2-3')
FROM dual ;


CREATE TABLE t4
( c1 RAW(2000),
c2 LONG RAW,
c3 BLOB,
c4 BFILE ) ;

--PURGE사용하면 휴지통에 저장되지 않음 
-- 휴지통에 있는 테이블 복원 , FLASHBACK TABLE 테이블명 TO BEFORE DROP(지원X)
DROP TABLE T1 PURGE;
DROP TABLE T2 PURGE;
DROP TABLE T3 PURGE;
DROP TABLE T4 PURGE;

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-RR' ;

SELECT table_name, column_name, data_type, data_default
FROM user_tab_columns
WHERE table_name = 'EMP01' ;

SELECT empno, ename, hiredate, dept
FROM employees
WHERE employee_id = 1234 ;


