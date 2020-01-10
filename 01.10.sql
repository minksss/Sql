----익명블록
----sub program : function, procedure 
--
--set serveroutput on;
--
--
--    create or replace procedure sp_getname(
--    v_empid in number, v_fname out varchar2) --in으로 이름이 들어오고 out으로 나간다
--    is
--  --  v_empid employees.employee_id%type :=105;
--  --  v_fname employees.first_name%type;
--    
--    begin
--    select first_name||last_name
--    into v_fname
--    from employees
--    where employee_id = v_empid;
--    dbms_output.put_line('직원 이름은? - ' || v_fname);
--    end;
--    /
--    
--    
--    variable aa number;
--    execute :aa := 110;
--    execute sp_getname(:aa);
--    
--    variable bb varchar2
--    execute sp_getname(:aa,:bb);
--    print bb;
--    end;
--    
--    --연습
--    -- 부서번호를 입력해서 부서이름과 매니저번호를out
--    create or replace procedure sp_getdept(
--    v_deptid in number, v_deptname out varchar2, v_mgr out number)
--    is 
--     -- 익명블록의 declare부분과 같다. 필수가 아닌 선택사항이다 
--    begin
--    select department_name, manager_id
--    into v_deptname,v_mgr
--    from departments
--    where department_id = v_deptid;
--    
--    v_deptname  := '부서명:'||v_deptname;
--    
--    end;
--    /
--    
    --직원번호 in
    --out : 직원이름(성+이름), 부서이름, Job_title, Cit
    --선생님이 짠거 
    
    set serveroutput on;
    create or replace procedure sp_test(
        v_empid in employees.employee_id%type,
        v_empname out varchar2, 
        v_deptname out departments.department_name%type,
        v_job out jobs.job_title%type,
        v_city out locations.city%type
    )
    is
        v_aa number(10);
    begin
    select first_name||last_name, department_name, job_title, city
    into v_empname, v_deptname, v_job, v_city
    from employees join jobs using(job_id)
                   join departments using(department_id)
                   join locations using(location_id)
    where employee_id = v_empid;
    
    dbms_output.put_line(v_empid || '--직원정보--');
    dbms_output.put_line(v_empname || '--직원이름--');
    dbms_output.put_line(v_deptname || '--부서이름--');
   dbms_output.put_line(v_job || '--직무이름--');
   dbms_output.put_line(v_city);
    end;
    /
    --컴파일되어 db서버에 생성된다
    --어플리케이션에서 사용한다.
    variable a number
    variable b varchar2(40)
    variable c varchar2(40)
    variable d varchar2(40)
    variable e varchar2(40)
    
    execute sp_test(100, :b, :c, :d, :e);
    
    
    create or replace function f_tax(v_sal in number)
    return number
    is 
     v_result number;
    begin 
    v_result := v_sal * 0.1;
    return v_result;
    end;
/

        variable sal number
        variable tax number
    execute :sal :=10000;
    execute :tax := f_tax(:sal);
    print tax;
        
        
select first_name, salary, f_tax(salary), substr(first_name, 3)
from employees;


--PL?SQL에서 단일행 함수 사용가능
create or replace procedure sp_test
is
    v_length number;
    v_date date;
    v_seq number;
begin 
    v_length := length('hello');
 DBMS_OUTPUT.put_line(v_length);   
 DBMS_OUTPUT.put_line(sysdate); 
 DBMS_OUTPUT.put_line(current_date);   
 DBMS_OUTPUT.put_line(ceil(3.14));   
 DBMS_OUTPUT.put_line(add_months(sysdate,1));   
 
 v_date := to_date('2000-10-04', 'yyyy-mm-dd');
 DBMS_OUTPUT.put_line(v_date);   
 DBMS_OUTPUT.put_line(months_between(sysdate,v_date));   
 
 v_date := '10-JAN-2020';
 DBMS_OUTPUT.put_line(v_date);
 select board_seq.nextval
 into v_seq
 from dual;
 
 DBMS_OUTPUT.put_line(v_seq);
 
end;
/

execute sp_test;


select * from user_sequences;


declare 
    v_outter varchar2(20) := 'global변수';
begin
    dbms_output.put_line(v_outter);
    declare
    v_inner varchar2(20) := 'local변수';
    begin
      dbms_output.put_line(v_outter);
        dbms_output.put_line(v_inner);
    end;
end;
/

declare 
 v_cnt number := 0; 
 v_sal number := 10000;
 v_result boolean;
begin
 v_cnt := v_cnt + 1;
 dbms_output.put_line(v_cnt);
v_result := v_sal between 5000 and 15000;
    if v_result = true then
     dbms_output.put_line('good');
    else
     dbms_output.put_line('fucku');
     end                                                                                                                                                                                                                                                                                                                                              if;

end;
/



drop table retired_emps;
CREATE TABLE retired_emps
(EMPNO NUMBER(6), 
ENAME VARCHAR2(45),
JOB VARCHAR2(10),
MGR NUMBER(6),
HIREDATE DATE, 
LEAVEDATE DATE, --퇴사일 
SAL NUMBER(8,2), 
COMM NUMBER(2,2),
DEPTNO NUMBER(3));

create or replace procedure sp_retired_emp
is
 v_empid number:=124;
 v_ENAME VARCHAR2(45);
v_JOB VARCHAR2(10);
v_MGR NUMBER(6);
v_HIREDATE DATE; 
v_LEAVEDATE DATE; --퇴사일 
v_SAL NUMBER(8,2); 
v_COMM NUMBER(2,2);
v_DEPTNO NUMBER(3);
begin
    select first_name||last_name, job_id, manager_id,
            hire_date, salary, commission_pct, department_id
            into v_ENAME,v_JOB,v_MGR,v_HIREDATE,v_SAL,v_COMM,v_DEPTNO
            from employees
            where employee_id = v_empid;
    end;
    /
    
    execute sp_retired_emp;
    
    select * from retired_emps;
    
    
            
declare
    v_employee_id number := 100;
    first_name varchar2(20);
begin
    select first_name
    into first_name
    from employees
    where employee_id = v_employee_id;
    
    dbms_output.put_line(first_name);
    
end;
/
--param:1 입력...employees table
--param:2 수정...job_id='ST_CLERK'인 데이터만 sal+800
--param:3 삭제...board table 모두 삭제
SELECT * FROM USER_SEQUENCES;
SELECT JOB_ID
FROM(
SELECT JOB_ID, COUNT(EMPLOYEE_ID) 
FROM EMPLOYEES
GROUP BY JOB_ID
ORDER BY 2
) WHERE ROWNUM = 1;
create or replace procedure sp_dmltest(v_param in number)
is
    v_jobid employees.job_id%type;
    v_message varchar2(20);
begin
    if v_param = 1 then
    SELECT JOB_ID 
    INTO V_JOBID 
    FROM (
    SELECT JOB_ID
            FROM(
                    SELECT JOB_ID, COUNT(EMPLOYEE_ID) 
                        FROM EMPLOYEES
G                   gROUP BY JOB_ID
                ORDER BY 2
            ) WHERE ROWNUM = 1);
    
            insert into employees(EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
             values(EMPLOYEES_SEQ.NEXTVAL,'장민기','SFSF',SYSDATE,'IT_PROG');
    
    elsif v_param = 2 then
        update employees
        set salary = salary + 1
        where job_id = 'ST_CLERK';
        v_message :='update success';
    else
        delete from board;
        v_message := 'delete success';
    end if;

    commit;
end;
/

execute sp_dmltest(3);
select * from board;
select * from employees;


select * from boarD;

update employees
set salary = salary + 1
where job_id = 'ST_CLERK';
    
    
    