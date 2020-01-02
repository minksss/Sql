--natural join
--employees�� �ִ� �Ŵ����� ���, departments�� �ִ� �Ŵ����� �μ���


--32��
select * 
from employees natural join departments;

--  ������ �μ��� �����Ѵ�. �Ǽ��� �����Ǽ�: 107
--  DB vendor ���� -> oracle, sybase, mysql, mssql, informix, db2 ,,,,)
--  where����  join������ ANSIǥ���� �ƴ�
--  ���ϴ� ����� �ƴϴ�. 

select *
from employees, departments
where employees.department_id = departments.department_id
and employees.manager_id = departments.manager_id;

--106��
select  first_name, department_name, employees.department_id
from employees, departments
where employees.department_id = departments.department_id;

-- ANSI ǥ��
-- join using : Į�� �̸��� ���� ��� 
select  first_name, department_name, department_id
from employees join departments using (department_id);

-- join on : Į�� �̸��� �ٸ� ���
select  first_name, department_name, employees.department_id, departments.department_id
from employees join departments on (employees.department_id=departments.department_id);


desc departments;
desc locations;

select * from departments;

--orcale����
select department_name, city, departments.location_id
from departments, locations
where departments.location_id = locations.location_id;

--natural( �̸��� ���� ��� ������ ����)
select department_name, city, location_id
from departments natural join locations;

--join using(�̸� ���� ��� ���ϴ� Į���� ����)
select d.department_name, lo.CITY, location_id
from departments d join locations lo using(location_id)
where location_id=1700;

--join on(�̸� �ٸ� ���) alias�� ���� ������ �� ��������. 
select aa.department_name, bb.city, aa.location_id
from departments aa join locations bb
on (aa.location_id = bb.location_id);

select e.first_name, e.hire_date, d.department_name, e.manager_id ���, d.manager_id �μ���, department_id, e.employee_id 
from departments d join employees e using(department_id);

-- employees, departments, locations 3���� �����ϰ� ���� ��
-- �����̸�, �μ��̸�, �μ� ��ġ�� ���� 
-- oracle

select first_name, department_name, city, employees.department_id
from employees, departments, locations
where employees.department_id = departments.department_id
and departments.location_id = locations.location_id
and employees.department_id in (20,30,40);

select first_name, department_name, city, department_id
from employees join departments using (department_id)
    join locations using (location_id)
where department_id in (20,30,40);

select first_name, department_name, city, employees.department_id
from employees join departments 
on(employees.department_id = departments.department_id)
join locations
on(departments.location_id = locations.location_id)
and employees.department_id in (20,30,40);


-- self join (�����ϰ��� �ϴ� ���� �ڽ��� ���̺� ���� ���)
select worker.employee_id ����, worker.first_name,
        manager.employee_id �Ŵ���, manager.first_name
from employees worker, employees manager
where worker.manager_id = manager.employee_id(+);

-- ansi (JOIN USING �Ұ�.. WHY? Į���̸��� �ٸ��Ƿ�)
-- ansi (JOIN ON ����)
select worker.employee_id ����, worker.first_name,
        manager.employee_id �Ŵ���, manager.first_name
from employees worker join employees manager
on worker.manager_id = manager.employee_id;


--inner join(default innter ���� ����)
--outer join : ���ʸ� �����ص� select

select worker.employee_id ����, worker.first_name,
    nvl2(manager.employee_id , to_char(manager.employee_id), '�Ŵ�������'),
    nvl(manager.first_name, '�Ŵ�������')
from employees worker left outer join employees manager
on worker.manager_id = manager.employee_id;

select * from jobs;

create table job_grades
(   joblevel char(1) primary key,
    lowsal number(7),
    hisal number(7) );

insert into job_grades values('A', 0, 5000);
insert into job_grades values('b', 5001, 10000);
insert into job_grades values('c', 10001, 15000);
insert into job_grades values('d', 15001, 20000);
insert into job_grades values('e', 20001, 25000);
commit;

select first_name, salary, joblevel
from employees, job_grades
where employees.salary between job_grades.lowsal and job_grades.hisal
order by first_name;

-- ansi 
select first_name, salary, joblevel
from employees join job_grades
on employees.salary between job_grades.lowsal and job_grades.hisal
order by first_name;

-- �μ� ��ȸ
select department_name, first_name
from departmens, employees
where departments.manger_id = employees.employee_id(+);

select department_name, first_name
from departments inner join employees
on departments.manager_id = employees.employee_id;

-- 
select nvl(department_name, '�Ϲ�����') �μ��̸�, first_name �μ���
from departments right outer join employees
on departments.manager_id = employees.employee_id;


select department_name �μ��̸�, first_name �μ���
from departments right outer join employees
on departments.department_id = employees.department_id;

-- ��� ���� ���(�μ��Ҵ���� ���� ����) .. ��� �μ� ���(���� �Ҵ� �ȵ� �μ�����)

select first_name, job_title
from employees, jobs
where employees.job_id = jobs.job_id;

select first_name, job_title
from employees join jobs using(job_id);

select first_name, job_title
from employees join jobs
on employees.job_id = jobs.job_id;

select d.department_name, city
from departments d, locations 
where d.location_id = locations.location_id;

select d.department_name, city
from departments d join locations using(location_id);

select d.department_name, city
from departments d join locations 
on d.location_id = locations.location_id;


select first_name, country_name
from employees, departments, locations, countries
where employees.department_id = departments.department_id
and departments.location_id = locations.location_id
and locations.country_id = countries.COUNTRY_ID;

select first_name, country_name
from employees join departments using(department_id)
                join locations using(location_id)
                join countries using (country_id);
                
select first_name, country_name
from employees join departments on (employees.department_id =departments.department_id)
                join locations on(departments.location_id = locations.location_id)
                join countries on(locations.country_id = countries.COUNTRY_ID);


--4. ��å(job_title)�� 'manager' �� ����� �̸�, ��å, �μ����� ��ȸ�Ͻÿ�.

    
    select first_name, job_title, department_name
    from employees, jobs, departments
    where employees.job_id = jobs.job_id
    and employees.department_id = departments.department_id
    and job_title like initcap('&manager');

--5. �������� �̸�, �Ի���, �μ����� ��ȸ�Ͻÿ�.

--6. �������� �̸�, �Ի���, �μ����� ��ȸ�Ͻÿ�.
--��, �μ��� ���� ������ �ִٸ� �� ���������� ��°���� ���Խ�Ų��.
    select first_name, hire_date, department_name
    from employees left outer join departments using(department_id);
    

--7. ������ �̸��� ��å(job_title)�� ����Ͻÿ�.
--��, ������ �ʴ� ��å�� �ִٸ� �� ��å������ ��°���� ���Խ�Ű�ÿ�.
    select first_name, job_title 
    from employees right outer join jobs using (job_id);
    
    desc jobs;
    
    insert into jobs values('play','���',15000,50000);
    commit;
    
    
    select count(job_id)
    from jobs;
    
    
    select count(distinct job_id)
    from employees;

--8. ������ �̸��� ������ �̸��� ��ȸ�Ͻÿ�.
    select emp.first_name �����̸�, mgr.first_name ����̸�
    from employees emp join employees mgr
    on emp.manager_id = mgr.manager_id;

--9. ������ �̸��� ������ �̸��� ��ȸ�Ͻÿ�.
--�����ڰ� ���� ���������� ��� ����Ͻÿ�.

    

--10. ������ �̸��� �����ڰ� �����ϴ� ������ ���� ��ȸ�Ͻÿ�.
--��, ������������ 3�� �̻��� �����ڸ� ��µǵ��� �Ͻÿ�.

select mgr.first_name �������̸�, count(emp.first_name) ������
from employees emp join employees mgr
on (emp.manager_id = mgr.employee_id)
group by mgr.first_name
having count(emp.first_name) >= 3
order by 2 desc;


select empno, ename, deptno, deptno, dname, loc
from employees e, deparments d;

select e.ename, e.sal, j.grade_level
from emp e join JOB_GRADES 
on e.salary between j.lowest_sal and j.highest_sal;

