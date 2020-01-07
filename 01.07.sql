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
