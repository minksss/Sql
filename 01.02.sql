--sub query
-- last_name �� abel�� �޿����� ���� ������ ��ȸ

select salary 
from employees
where last_name = 'Abel';

select first_name, salary
from employees
where salary > (
select salary 
from employees
where last_name = 'Abel'
);

select department_id
from employees 
where first_name = 'Steven';

select *
from employees 
where department_id = ( 
                    select department_id 
                    from employees
                    where first_name = 'David');
                    
select * 
from employees 
where job_id = ( select job_id
                 from employees
                 where employee_id = 141);
                 
select *
from employees
where job_id = (select job_id  
                from employees 
                where employee_id = 141)
            and salary > ALL( select salary from employees
                                where last_name = 'Taylor');
                                
--�ּұ޿��� �޴� �����̸�, �޿�, �Ի��� 
select first_name, salary, hire_date
from employees 
where salary = (
select min(salary)
from employees
);

--����ã��
select max(hire_date)
from employees;

--�μ��� �ּұ޿� ��� 
select department_id, min(salary)
from employees
having min(salary) > ( --50�� �μ��� salary���� ū ���� ������ �������߿��� ��
            s0.elect min(salary)
            from employees
            where department_id = 50)
group by department_id;

--��å�� ����� ���� ���� ��å�� �����ΰ�?

select job_id, avg(salary) 
from employees
group by job_id
having avg(salary) =(   select min(avg(salary)) 
                        from employees
                        group by job_id);
                        
--job id = 'IT_Prog;�� ������ ������� �޿��� ���� ������

select first_name, salary, hire_date,job_id
from employees
where salary =ANY
(
                select salary
                from employees
                where job_id = 'IT_PROG');

-- �ּҺ��� ũ��

select first_name, salary, hire_date,job_id
from employees
where salary > ANY
(
                select salary
                from employees
                where job_id = 'IT_PROG');
                
                
select first_name, salary, hire_date,job_id
from employees
where salary > 
(
                select min(salary)
                from employees
                where job_id = 'IT_PROG');

--������ ���� �μ��ڵ� ������ ��ȸ
--���  sub qeuryt
select *
from departments
where not exists
(select * from employees 
where employees.department_id = departments.department_id);

select * 
from departments 
where department_id not in 
                    (
select distinct department_id
from employees
where department_id is not null);

select distinct department_id

where department_id not in (
    select distinct department_id 
    from employees 
    where department_id is not null);

--exists 
--�޿��� 15000�̻��� ������ �ִ°�?

select *
from employees
where exists(
                select 1
                from employees
                where salary >= 30000
                );
                
--�ڽ��� �μ��� ��պ��� ���� �޿��� �޴� ������ ��ȸ

select first_name, department_id, salary
from employees e
where salary < ( select avg(salary) 
                 from employees 
                 where e.department_id = 20);

select avg(salary)
from employees 
where department_id = 20;

select first_name, department_id, salary
from employees e
where salary < ( select avg(salary) 
                 from employees 
                 where department_id = e.department_id);


select first_name, department_id, salary,  ( select round(avg(salary)) 
                 from employees 
                 where department_id = e.department_id)  �μ����
from employees e
where salary < ( select avg(salary) 
                 from employees 
                 where department_id = e.department_id);
                 
                 
select first_name, department_id, salary
from employees,(
select department_id aa, round(avg(salary),2) �μ����
from employees 
group by department_id) inlineview
where employees.department_id = inlineview.aa
;
--�Ŵ����� �ƴ� ������ ��ȸ
--�Ŵ����� 18���̴�

select distinct manager_id   
from employees ;

select *
from employees
where employee_id in ( select distinct manager_id 
                            from employees
                            where manager_id is not null);
                            
    
select first_name, salary, hire_date
from employees 
where department_id 
(
 select department_id
from departments
where department_name = 'IT');


select first_name, last_name, department_id
from employees
where department_id in (


select  department_id
from employees
where first_name = 'Alexander');

select first_name, department_id, salary 
from employee
where salary > (    
                select avg(salary)
                from employees
                where department_id = 80);
                

select* from employees 
where salary>(
select min(salary)
from employees 
where department_id in (
                        select department_id
                        from departments 
                        where location_id = (
                                            select location_id
                                            from locations 
                                            where city = 'South San Francisco')
)
)

and salary > ( select avg(salary) from employees where department_id = 50)
;

--5. �������� �̸�, �Ի���, �μ����� ��ȸ�Ͻÿ�.
--��, �μ��� ���� ������ �ִٸ� �� ���������� ��°���� ���Խ�Ų��.
--�׸��� �μ��� ���� ������ ���ؼ��� '<�μ�����>' �� ��µǵ��� �Ѵ�.

select first_name, hire_date, department_name
from employees left outer join departments
using(department_id);




















