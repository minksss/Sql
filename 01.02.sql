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

select first_name, hire_date, nvl(department_name, '부서없음') 부서이름
from employees left outer join departments
using(department_id);

--6. 직원의 직책에 따라 월급을 다르게 지급하려고 한다.
--직책에 'Manager'가 포함된 직원은 급여에 0.5를 곱하고
--나머지 직원들에 대해서는 원래의 급여를 지급하도록 한다. 
--적절하게 조회하시오. 
--(using decode or case)

select first_name, job_title, salary, substr(job_title, -7) 직급명, 
    decode( substr(job_title,-7),'Manager',salary*0.5, salary) 지급금액,
    case when job_title like '%Manager' then salary*0.5 else salary end  지급금액2
from employees join jobs
using(job_id);

--7. 각 부서별로 최저급여를 받는 직원의 이름과 부서id, 급여를 조회하시오.
--1) inline view 방법 

select first_name, employees.department_id, salary
from employees ,(
            select department_id, min(salary) minsal
            from employees
            group by department_id) dept_group 
where employees.department_id = dept_group.department_id
and employees.salary = dept_group.minsal;

--상관 sub query 
select first_name, aa.department_id, salary 
from employees aa 
where salary = ( select min(salary) 
                    from employees
                    where department_id = aa.department_id)
                    ;
--multi-column 이용

select first_name, aa.department_id, salary 
from employees aa 
where (department_id, salary) in(

select department_id, min(salary)
from employees
group by department_id);



--8. 각 직급별(job_title) 인원수를 조회하되 사용되지 않은 직급이 있다면 해당 직급도
--출력결과에 포함시키시오. 그리고 직급별 인원수가 3명 이상인 직급만 출력결과에 포함시키시오.

select job_title, count(employee_id)
from employees join jobs using(job_id)
group by job_title
having count(employee_id) >= 3;

--9. 각 부서별 최대급여를 받는 직원의 이름, 부서명, 급여를 조회하시오.

select first_name, department_name, salary
from employees join departments using (department_id)
where (department_id, salary) in ( select department_id, max(salary)
                                    from departments
                                    group by department_id);
                                    
                   



--10. 직원의 이름, 부서id, 급여를 조회하시오. 그리고 직원이 속한 해당 부서의 
--최소급여를 마지막에 포함시켜 출력 하시오.
--스칼라 서브쿼리 사용

    select first_name, department_id, salary,
                (select min(salary) from employees
                  where department_id = aa.department_id ) 최소급여
    from employees aa;




--11. 급여를 가장 많이 받는 상위 5명의 직원 정보를 조회하시오.
     select rownum, first_name, salary
     from employees
     where rownum <=5
     order by salary desc ;

select *
from ( 
     select rownum, first_name, salary
     from employees
     order by salary desc)
where rownum <=5;



--12. 커미션을 가장 많이 받는 상위 3명의 직원 정보를 조회하시오.
--(oracle은 null이 우선이다)
select rownum seq, aa.*
from(
select first_name, commission_pct
from employees
order by commission_pct desc nulls last 
) aa
where rownum <= 10;

--13. 월별 입사자 수를 조회하되, 입사자 수가 10명 이상인 월만 출력하시오.

select to_char(hire_date, 'mm'), count(*)
from employees
group by to_char(hire_date, 'mm')
having count(*) >= 10
order by 1;

--14. 년도별 입사자 수를 조회하시오. 
--단, 입사자수가 많은 년도부터 출력되도록 합니다.

select to_char(hire_date, 'yyyy'), count(*)
from employees
group by to_char(hire_date, 'yyyy')
order by 2 desc;




--1. 'Southlake'에서 근무하는 직원의 이름, 급여, 직책(job_title)을 조회하시오.
    
    select first_name, job_title, salary
    from employees join departments using (department_id)
                   join locations using (location_id)
                   join jobs using (job_id)
    where city = 'Southlake';
       
        
--2. 국가별 근무 인원수를 조회하시오. 단, 인원수가 3명 이상인 국가정보만 출력되어야함.
    
    select country_id, count(*)
    from employees join departments using(department_id)
                    join locations using (location_id)
                    join countries using (country_id)
                    group by country_id
                    having count(*) >=3;
                    
--3. 직원의 이름, 급여, 직원의 관리자 이름을 조회하시오. 단, 관리자가 없는 직원은
--   '<관리자 없음>'이 출력되도록 해야 한다.

 select 직원.first_name, 직원.salary, 관리자.first_name
 from employees 직원, employees 관리자
 where 직원.manager_id = 관리자.employee_id;
 

--4. 직원의 이름, 부서명, 근무년수를 조회하되, 20년 이상 장기 근속자만 출력되록한다.
--5. 각 부서 이름별로 최대급여와 최소급여를 조회하시오. 단, 최대/최소급여가 동일한
--   부서는 출력결과에서 제외시킨다.

--6. 자신이 속한 부서의 평균급여보다 많은 급여를 받는 직원정보만 조회하시오.
--   단, 출력결과에 자신이 속한 부서의 평균 급여정보도 출력되어야한다. 
    select first_name, salary, department_id
    from employees aa
    where salary > ( select avg(salary) 
                     from employees
                     where department_id = aa.department_id);
--7. '월'별 최대급여자의 이름, 급여를 조회하시오.
select first_name, hire_date, salary 
from employees
where (to_char(hire_date, 'mm'),salary) in(
select to_char(hire_date, 'mm'), max(salary)
from employees
group by to_char(hire_date,'mm'))
order by to_char(hire_date, 'mm');

--8. 부서별, 직급별, 평균급여를 조회하시오. 
--   단, 평균급여가 50번부서의 평균보다 많은 부서만 출력되어야 합니다.
select department_id, job_id, avg(salary)
from employees
group by department_id, job_id
having avg(salary) > (select avg(salary)                    
                        from employees
                        where department_id = 50
);

select avg(salary)
from employees
where department_id = 50;
--9. 자신의 관리자보다 많은 급여를 받는 직원의 이름과 급여를 조회하시오.
select first_name, salary, manager_id
from employees aa
where salary > (select salary from employees
                where employee_id = aa.manager_id
                );
                
 select employee_id, salary from employees 
 where employee_id in(148,149);
--10. 급여가 가장 많은 직원 6번째부터 10번째 직원만 출력하시오.
select * 
from(
select rownum rk, aa.*
from(
select first_name, salary 
from employees
order by salary desc 
)aa
)
where rk between 6 and 10;









