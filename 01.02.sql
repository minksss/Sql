--sub query
-- last_name 이 abel의 급여보다 많은 직원을 조회

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
                                
--최소급여를 받는 직원이름, 급여, 입사일 
select first_name, salary, hire_date
from employees 
where salary = (
select min(salary)
from employees
);

--막내찾기
select max(hire_date)
from employees;

--부서별 최소급여 출력 
select department_id, min(salary)
from employees 
where salary > ( --50번 부서의 salary보다 큰 값을 가지는 직원들중에서 비교
            select min(salary)
            from employees
            where department_id = 50)
        group by department_id;