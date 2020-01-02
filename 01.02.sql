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
having min(salary) > ( --50번 부서의 salary보다 큰 값을 가지는 직원들중에서 비교
            s0.elect min(salary)
            from employees
            where department_id = 50)
group by department_id;

--직책별 평균이 가장 작은 직책은 무엇인가?

select job_id, avg(salary) 
from employees
group by job_id
having avg(salary) =(   select min(avg(salary)) 
                        from employees
                        group by job_id);
                        
--job id = 'IT_Prog;와 같ㅌ은 사람들의 급여와 작은 직원들

select first_name, salary, hire_date,job_id
from employees
where salary =ANY
(
                select salary
                from employees
                where job_id = 'IT_PROG');

-- 최소보다 크다

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

--직원이 없는 부서코드 정보를 조회
--상관  sub qeuryt
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
--급여가 15000이상인 직원이 있는가?

select *
from employees
where exists(
                select 1
                from employees
                where salary >= 30000
                );
                
--자신의 부서의 평균보다 적은 급여를 받는 직원을 조회

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
                 where department_id = e.department_id)  부서평균
from employees e
where salary < ( select avg(salary) 
                 from employees 
                 where department_id = e.department_id);
                 
                 
select first_name, department_id, salary
from employees,(
select department_id aa, round(avg(salary),2) 부서평균
from employees 
group by department_id) inlineview
where employees.department_id = inlineview.aa
;
--매니저가 아닌 직원을 조회
--매니저는 18명이다

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

--5. 직원들의 이름, 입사일, 부서명을 조회하시오.
--단, 부서가 없는 직원이 있다면 그 직원정보도 출력결과에 포함시킨다.
--그리고 부서가 없는 직원에 대해서는 '<부서없음>' 이 출력되도록 한다.

select first_name, hire_date, department_name
from employees left outer join departments
using(department_id);




















