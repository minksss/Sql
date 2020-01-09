select * from user_users;
select * from all_users;
select * from dba_users;

select * from user_tab_privs_made; test가 user02에게 준 권한
select * from user_tab_privs_recd; -- 사용자가 다른 사용자에게 받은 권한

grant select,insert,update,delete on emp to user02 
with grant option;

-- user02 --> user04
grant select,insert,update,delete on test.emp to user04;


revoke all on emp from user02;
revoke select on departments from hr;

--role 정보 확인
select * from user_role_privs;

---------PLSQL---------------------------

set serveroutput on;
declare
    v_fname varchar2(20);
    v_salary number;
    v_hire date;
begin
    select first_name, salary, hire_date
    into v_fname, v_salary, v_hire
    from employees
    where employee_id = 105;
    dbms_output.put_line('the first name of the employee is ' || v_fname);
    dbms_output.put_line('the first name of the employee is ' || v_salary || v_hire);
end;
/

desc employees;

begin 
    DBMS_OUTPUT.put_line('begin과 end는 필수이다.');
end;
/

--변수의 타입을 알기 위해
--관례

declare 
    v_char char(5) := 'h';
    v_num number(5) := 1000;
    v_varchar varchar2(10) := '123455';
    v_date date := to_date('2020/01/09', 'yyyy/mm/dd');
    
    --상수 : 값 변경 불가 
    c_company constant varchar2(50) := '멀티캠퍼스';
    v_deptno number(2) not null := 20;
    v_message varchar(100);
begin 
 DBMS_OUTPUT.put_line('char:'||v_char);
 DBMS_OUTPUT.put_line(v_num);
 DBMS_OUTPUT.put_line(v_varchar);
 DBMS_OUTPUT.put_line(v_date);
  DBMS_OUTPUT.put_line(c_company);
  DBMS_OUTPUT.put_line(v_deptno);


v_char := '가';
v_num := 200;

 DBMS_OUTPUT.put_line('char:'||v_char);
 DBMS_OUTPUT.put_line(v_num);
   DBMS_OUTPUT.put_line(c_company);

    v_message := q'!아메리카노!';
   DBMS_OUTPUT.put_line(v_message);


end;

/

declare 
v_boolean boolean := true;
v_bi binary_integer := 100;
begin
    v_bi := v_bi +1;
    DBMS_OUTPUT.put_line(v_bi);
v_boolean := false;
    if v_boolean = true then
   DBMS_OUTPUT.put_line('합격');
   else
   DBMS_OUTPUT.put_line('불합격');
   end if;
end;
/

alter session set nls_date_language = 'American';
alter session set nls_date_language = 'korean';

alter session set nls_date_format = 'dd-mm-yyyy hh:mi:ss:sec'
    alter session set nls_date_format = 'yyyy-mm-dd hh:mi:ss'


set serveroutput on;

declare 
 v_salary number(1,2);
 v_salary2 employees.salary%type;
 v_hiredate date;
 v_hiredate2 employees.hire_date%type;
 v_hiredate3 
 
begin
    select salary
    into v_salary2
    from employees
    where employee_id = 105;
    dbms_output.put_line(v_salary2);
end;

/

desc emploees;
variable b_result number
execute :b_result := 1000
print b_result;

variable b_empid number
execute :b_empid ;

begin 
    select salary 
    into :b_result
    from employees
    where EMPLOYEE_id = 106;
end;
/
print b_result;

 select salary 
    from employees
    where EMPLOYEE_id = 101;
    
    
SELECT sql_text FROM v$sql WHERE lower(SQL_TEXT) LIKE '%first_name%';


 --------******중요***-------- 커맨드창에서는 입력을 못받나?

variable b_fname varchar2(20)
variable b_dept number
execute :b_fname :='&fname'
execute :b_dept :='&dept'


declare 
    v_employee_id employees.employee_id%type;
    v_hire_date employees.hire_date%type;
    v_salary employees.salary%type;
    v_last_name employees.last_name%type;
    
begin 
    select employee_id, hire_date, salary, last_name
    into v_employee_id, v_hire_date, v_salary, v_last_name
    from employees
    where first_name =:b_fname 
    and department_id =:b_dept;
    
    dbms_output.put_line(v_employee_id);
    dbms_output.put_line(v_hire_date);
    dbms_output.put_line(v_salary);
    dbms_output.put_line(v_last_name);

end;
/


