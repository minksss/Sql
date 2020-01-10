----�͸���
----sub program : function, procedure 
--
--set serveroutput on;
--
--
--    create or replace procedure sp_getname(
--    v_empid in number, v_fname out varchar2) --in���� �̸��� ������ out���� ������
--    is
--  --  v_empid employees.employee_id%type :=105;
--  --  v_fname employees.first_name%type;
--    
--    begin
--    select first_name||last_name
--    into v_fname
--    from employees
--    where employee_id = v_empid;
--    dbms_output.put_line('���� �̸���? - ' || v_fname);
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
--    --����
--    -- �μ���ȣ�� �Է��ؼ� �μ��̸��� �Ŵ�����ȣ��out
--    create or replace procedure sp_getdept(
--    v_deptid in number, v_deptname out varchar2, v_mgr out number)
--    is 
--     -- �͸����� declare�κа� ����. �ʼ��� �ƴ� ���û����̴� 
--    begin
--    select department_name, manager_id
--    into v_deptname,v_mgr
--    from departments
--    where department_id = v_deptid;
--    
--    v_deptname  := '�μ���:'||v_deptname;
--    
--    end;
--    /
--    
    --������ȣ in
    --out : �����̸�(��+�̸�), �μ��̸�, Job_title, Cit
    --�������� §�� 
    
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
    
    dbms_output.put_line(v_empid || '--��������--');
    dbms_output.put_line(v_empname || '--�����̸�--');
    dbms_output.put_line(v_deptname || '--�μ��̸�--');
   dbms_output.put_line(v_job || '--�����̸�--');
   dbms_output.put_line(v_city);
    end;
    /
    --�����ϵǾ� db������ �����ȴ�
    --���ø����̼ǿ��� ����Ѵ�.
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

    
    
    