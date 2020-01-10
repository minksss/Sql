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

    
    
    