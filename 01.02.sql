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
                where salary >= 15000
                );
