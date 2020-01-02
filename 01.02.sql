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
where salary > ( --50�� �μ��� salary���� ū ���� ������ �������߿��� ��
            select min(salary)
            from employees
            where department_id = 50)
        group by department_id;