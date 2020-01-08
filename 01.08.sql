-- 시퀀스

create table board(
    board_no number primary key, 
    board_title varchar2(20),
    board_contents varchar2(2000),
    writer varchar2(20)
);

insert into board values (
(select nvl(max(board_no),0)+1
from board), 'sql연습', '아즈아', 'JMK' 
);

select * from board;

select nvl(max(board_no),0)+1
from board;

commit;

--다른 db는 auto increment를 제공

--아무 테이블 or 칼럼에서 사용 가능(종속 없음)
create sequence board_seq 
start with 10;

select * from user_objects
where object_type = 'SEQUENCE';

select * from user_sequences;

select * from departments;

select board_seq.nextval from dual;

select board_seq.currval from dual;

insert into board values (
board_seq.nextval, 'sql연습', '아즈아', 'JMK' 
);

select * from board;

select * from departments;

select * from user_sequences;

insert into departments values ( 
DEPARTMENTS_SEQ.nextval, '부서추가',100, 1700);

rollback;

select rowid, first_name
from employees 
where first_name = 'David';

select * 
from user_indexes
where table_name = 'BOARD';

select * 
from user_ind_columns
where table_name = 'BOARD';

create table t_indextest
(
    c1 varchar2(10) primary key,
    c2 varchar2(10) unique,
    c3 varchar2(10) not null,
    c4 varchar2(10) check (c4 in ('A' , 'B' ) )
);

desc t_indextest;

select * 
from user_indexes
where table_name = 'T_INDEXTEST';

select * 
from user_ind_columns
where table_name = 'T_INDEXTEST';

create index idx_indextest
on t_indextest (c3);

select * 
from user_indexes
where table_name = 'EMPLOYEES';


drop table emp01;
create table emp01
as 
select * from employees;

select * 
from user_indexes
where table_name = 'EMP01';

select * 
from user_ind_columns
where table_name = 'EMP01';

desc emp01;

select * from emp01;
--primary key설정
alter table emp01
add constraint emp01_pk primary key (employee_id);

alter table emp01
add constraint emp01_uk unique(email);

select * from user_constraints
where table_name = 'EMP01';

set autotrace on explain; --실행계획 표시 
select * 
from emp01
where email = 'aaa';    

select * 
from emp01 
where first_name = 'aa';

--수동 index 만들기 ( nonunique)

create index emp01_fname_lname_idx
on emp01(first_name, last_name);


select * 
from emp01 
where first_name = 'aa' and last_name = 'bb';
--뒤에 것 last name만 따로 검색하면 index를 사용하지 않고 full scan을 한다


create table emp9 
as 
select * from employees;

insert into emp9 
select * from emp9;

select * from emp9;

desc employees;
insert into emp9(employee_id, last_name, email, hire_date, job_id)
values(1, 'J','sd',sysdate, 'IT_PROG');

select * from emp9
where employee_id = 1;

commit;

create index emp9_idx
on emp9 (employee_id);

select * from emp9;

alter index emp9_idx visible;

select * 
from user_indexes
where table_name = 'EMP9';

select * from emp9
where substr(phone_number,1,7) = '515.123';

select * 
from user_ind_columns
where table_name = 'EMP9';

create index EMP9_PHONE_IDX 
ON EMP9(PHONE_NUMBER);
-- 함수 기반 index
create index EMP9_phone2_idx
on emp9(substr(phone_number,1,7));


select * from user_tables;

select sysdate from dual;

select * from all_tables;

select * from all_objects 
where object_type = 'SYNONYM';

--lab(11)

select empno, ename, sal, deptno
from emp
where deptno = 10;

create view empv10 as
select empno, ename, sal, deptno
from emp
where deptno = 10;

desc empv10;

select * from empv10;

update empv10
set sal = sal * 1.2
where empno = 7839;

update empv10
set deptno = 20
where empno = 7934;

select empno, ename, sal, deptno 
from emp
where empno IN (7839,7934);


select view_name, text 
from user_views;
--where view_name = 'empv10';

select * 
from( select empno, ename, sal, deptno 
      from emp
      where deptno = 10);
      
create view empv_sum
as 
select deptno, sum(sal) sum
from emp 
group by deptno;

select * from empv_sum;

delete empv_sum
where deptno = 10;

drop view empv_sum;

create or replace view empv10
as select empno, ename, sal, comm, deptno
from emp 
where deptno = 10;

CREATE OR REPLACE VIEW empv10
AS SELECT empno, ename, sal, comm, deptno
FROM emp
WHERE deptno = 10 WITH CHECK OPTION ;

UPDATE empv10
SET sal = 6000
WHERE empno = 7839 ;


select * from empv10;

UPDATE empv10
SET deptno = 20	
WHERE empno = 7839 ;

rollback;

CREATE OR REPLACE VIEW empv10
AS SELECT empno, ename, sal, comm, deptno
FROM emp
WHERE deptno = 10 WITH READ ONLY ;

UPDATE empv10
SET sal = 6000
WHERE empno = 7839 ;


create sequence empno_seq
start with 8000
increment by 1;

SELECT sequence_name, increment_by, cache_size, last_number
FROM user_sequences
WHERE sequence_name = 'EMPNO_SEQ' ;

INSERT INTO emp (empno, ename, deptno)
VALUES (empno_seq.nextval, 'RYU',30) ;

select * from emp;

SELECT empno_seq.nextval FROM dual ;
SELECT empno_seq.currval FROM dual ;

SELECT sequence_name, increment_by, cache_size, last_number
FROM user_sequences
WHERE sequence_name = 'EMPNO_SEQ' ;

rollback;

SELECT empno_seq.nextval FROM dual;

CREATE SEQUENCE seq1
START WITH 100
INCREMENT BY 1
MAXVALUE 103
MINVALUE 50
CYCLE
NOCACHE ;

SELECT seq1.nextval FROM dual ;

ALTER SEQUENCE seq1 
MAXVALUE 200
cache 20;

DROP SEQUENCE empno_seq ;
DROP SEQUENCE seq1 ;

SELECT index_name, index_type, table_name, uniqueness
FROM user_indexes
WHERE table_name = 'EMP' ;

set autotrace on explain;

select empno, ename, deptno 
from emp 
where empno = 7788;

SELECT empno, ename, deptno
FROM emp
WHERE ename = 'SCOTT' ;

select empno, ename,deptno 
from ora1.emp;


