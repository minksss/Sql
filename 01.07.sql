--DDL
--char(2000)byte����, varchar2(4000)byte����
create table t1(
c1 char(5), --�������� 5byte�ڸ�
c2 varchar(5) --�ִ� 5byte�ڸ��̴�
);

insert into t1 values('123','123');
insert into t1 values ('123  ','123  ');
--insert into t1 values ('123456','123456'); ����
insert into t1 values ('�ѱ�','�ѱ�'); --����, �ѱ��� UTF-8(��� ���ڰ� 3byte�� ó��) 

select '*'||c1||'*','*'||c2||'*' from t1;

--�ڵ����� 5�ڸ� ...trim()
select * from t1
where c1 = '123'; -- '123  '�� ����

--�� �״�� ���(����) 
select * from t1
where c2 = '123';  -- '123'�� �� �״�� ��ȸ, ���� �� �� ��ȸ �ȵȴ�. 



desc locations;
select * from locations
where country_id ='US';

create table t2(
c1 char(2000),
v2 varchar2(4000)
);

-- number �ڸ��� �����Ǹ� 40�ڸ�
-- ��ü�ڸ����� �Ҽ��Ʒ����� ��ģ��
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

 -- LOB( lARGE OBJECT��� ��)
 -- CLOB, BLOB, BFILE
 create table t4(
 c4 number,
 c1 blob,
 c2 clob,
 c3 bfile
 );
 
 insert into t4 values(1, empty_blob(), empty_clob(),null);
 insert into t4 values(1, hextoraw('1234567890A'), 'ū����',null);
 
 rollback;
 select* from t4;
 
 create directory my_dir as 'c:/desktop/hello';
 insert into t4 values (3,hextoraw('1234567890A'), 'ū����aaa',
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
                systimestamp - interval '1-2' year to month, --1�� 2������
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

--�������� (constraint type)
--not null(C) : null ������
--unique(U) : �ش� ���̺��� ���� ���� (null ���)
--primary key(P) : not null + unique
--foreign key(F) : ����Ű, �ܷ�Ű, �̹� �ִ� ���� ���
--check : ����... ���� ������ ���

drop table t7;
create table t7(
 c1 number(3) constraint pk_t7 primary key, --�÷� ���������� ���� ���� 
 c2 varchar2(10)
);

create table t7(
 c1 number(3),
 c2 varchar2(10),
 constraint pk_t7 primary key (c1,c2) -- ���̺� ���������� ���� ����
);

-- �� 2������ � ����̵� ��� ����. 
-- ������ �ִ� ��쵵 ����. ���� ���, constraint�� Į�� ������ ���, 
-- �����̸Ӹ�Ű�� ���� Į���� ��� 1��° ����� �Ұ��� 
insert into t7 values(1, 'A');
insert into t7 values(1, 'B');



select * 
from user_constraints
where table_name = 'T7';

drop table t7;
create table t7(
c1 number(3) constraint pk_t7 primary key,
c2 varchar2(10), --null ���
c3 varchar2(10) constraint c3_nn not null,
c4 varchar2(10) constraint c4_unique unique, --null ���
c5 varchar2(10) constraint c5_unique_nn unique not null,
c6 number(2),
salary number(7) constraint salary_chk check(salary>1000),
gender char(1) constraint gender_chk check (gender in ('M','F')),
constraint fk_dept foreign key (c6) 
references dept(deptno)--dept ���̺��� deptno�� �����Ѵ�

);


insert into t7(c1,c3,c5) values (1,'A','c');
insert into t7(c1,c3,c4,c5,c6) values (2,'A','zz','c');
insert into t7(c1,c3,c4,c5,c6) values (2,'A','zz','c',10);
insert into t7(c1, c3, c5) values (1,'a','c');
insert into t7(c1, c3, c5,salary,gender) values (1,'a','c',860,'G');
insert into t7(c1, c3, c5,salary,gender) values (12,'a','csd',1200,'F');

-- ���� check, primary, uniqe
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

select * from dept; -- �θ�
select distinct deptno from emp; --�ڽ�

--foreign key ������ ���
--default : �ڽ� record ������ ������, �ڽ� ������ ���� �Ұ��� 
delete from dept where deptno = 20;
delete from dept where deptno = 40;

--�θ� ���̺� 
create table parentTBL(
    c1 number(2) primary key,
    c2 varchar2(30) 
);
--�ڽ� ���̺�]
drop table childTBL;
create table childTBL(
 c1 number(2) primary key,
 c2 varchar2(30), 
 c3 number(2) constraint childTBL_fk references parentTBL(c1)
    on delete set null
);
-- on delete set null �θ� ������ �ڽ� Į�� �� null
-- on delete cascade �θ� ������ �ڽ� ����
-- default�� �ڽ��� ���� �θ� ���� �Ұ�
insert into parentTBL values (10, '���ߺ�');
insert into parentTBL values (20, '������');
insert into parentTBL values (30, '�����');
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
    , solar char(3) constraint solar_chk check (solar in ('��','��'))
    , height number(3)
    , weight number(3) constraint weight_chk check (weight >= 50 and weight <=110)
);

insert into team_t(team_id, region_name, stadium_id, team_name)
values ('A01','����','BBB','�巹����');

insert into player_t(player_id, team_id, player_name,join_yyyy)
values ('0003','A01','jmk','2020');

insert into player_t(player_id, team_id, player_name,join_yyyy, position, solar)
values ('0005','A01','jmk','2020','MF','��');


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
-- EMPLOYEES �������� 10�� (p,c,r,U)
-- not null ���ุ ����ȴ� 

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
modify (�߰�Į�� varchar(30), adcol2 number(30));

select * from emp_backup60;

update emp_backup60
set �߰�Į�� = '12345678465464649', adcol2 = 04040468468468440;

alter table emp_backup60
drop column adcol2;

delete from emp_backup60;
rollback;

truncate table emp_backup60; --truncate�ϸ� �ѹ��� �ҿ����.

select * from user_constraints;


select * 
from all_constraints;

select *
from dba_constraints;
