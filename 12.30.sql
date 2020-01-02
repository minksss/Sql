--natural join
--employees에 있는 매니저는 상사, departments에 있는 매니저는 부서장


--32건
select * 
from employees natural join departments;

--  직원이 부서를 참조한다. 건수는 직원건수: 107
--  DB vendor 문법 -> oracle, sybase, mysql, mssql, informix, db2 ,,,,)
--  where절에  join문장은 ANSI표준이 아님
--  원하는 결과가 아니다. 

select *
from employees, departments
where employees.department_id = departments.department_id
and employees.manager_id = departments.manager_id;

--106건
select  first_name, department_name, employees.department_id
from employees, departments
where employees.department_id = departments.department_id;

-- ANSI 표준
-- join using : 칼럼 이름이 같은 경우 
select  first_name, department_name, department_id
from employees join departments using (department_id);

-- join on : 칼럼 이름이 다른 경우
select  first_name, department_name, employees.department_id, departments.department_id
from employees join departments on (employees.department_id=departments.department_id);


desc departments;
desc locations;

select * from departments;

--orcale문법
select department_name, city, departments.location_id
from departments, locations
where departments.location_id = locations.location_id;

--natural( 이름이 같은 경우 무조건 조인)
select department_name, city, location_id
from departments natural join locations;

--join using(이름 같은 경우 원하는 칼럼만 조인)
select d.department_name, lo.CITY, location_id
from departments d join locations lo using(location_id)
where location_id=1700;

--join on(이름 다른 경우) alias를 쓰면 성능이 더 좋아진다. 
select aa.department_name, bb.city, aa.location_id
from departments aa join locations bb
on (aa.location_id = bb.location_id);

select e.first_name, e.hire_date, d.department_name, e.manager_id 상사, d.manager_id 부서장, department_id, e.employee_id 
from departments d join employees e using(department_id);

-- employees, departments, locations 3개를 조인하고 싶을 때
-- 직원이름, 부서이름, 부서 위치의 도시 
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


-- self join (참조하고자 하는 값이 자신의 테이블에 있을 경우)
select worker.employee_id 직원, worker.first_name,
        manager.employee_id 매니저, manager.first_name
from employees worker, employees manager
where worker.manager_id = manager.employee_id(+);

-- ansi (JOIN USING 불가.. WHY? 칼럼이름이 다르므로)
-- ansi (JOIN ON 가능)
select worker.employee_id 직원, worker.first_name,
        manager.employee_id 매니저, manager.first_name
from employees worker join employees manager
on worker.manager_id = manager.employee_id;


--inner join(default innter 생략 가능)
--outer join : 한쪽만 존재해도 select

select worker.employee_id 직원, worker.first_name,
    nvl2(manager.employee_id , to_char(manager.employee_id), '매니저없음'),
    nvl(manager.first_name, '매니저없음')
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

-- 부서 조회
select department_name, first_name
from departmens, employees
where departments.manger_id = employees.employee_id(+);

select department_name, first_name
from departments inner join employees
on departments.manager_id = employees.employee_id;

-- 
select nvl(department_name, '일반직원') 부서이름, first_name 부서장
from departments right outer join employees
on departments.manager_id = employees.employee_id;


select department_name 부서이름, first_name 부서장
from departments right outer join employees
on departments.department_id = employees.department_id;

-- 모든 직원 출력(부서할당없는 직원 포함) .. 모든 부서 출력(직원 할당 안된 부서포함)

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


--4. 직책(job_title)이 'manager' 인 사람의 이름, 직책, 부서명을 조회하시오.

    
    select first_name, job_title, department_name
    from employees, jobs, departments
    where employees.job_id = jobs.job_id
    and employees.department_id = departments.department_id
    and job_title like initcap('&manager');

--5. 직원들의 이름, 입사일, 부서명을 조회하시오.

--6. 직원들의 이름, 입사일, 부서명을 조회하시오.
--단, 부서가 없는 직원이 있다면 그 직원정보도 출력결과에 포함시킨다.
    select first_name, hire_date, department_name
    from employees left outer join departments using(department_id);
    

--7. 직원의 이름과 직책(job_title)을 출력하시오.
--단, 사용되지 않는 직책이 있다면 그 직책정보도 출력결과에 포함시키시오.
    select first_name, job_title 
    from employees right outer join jobs using (job_id);
    
    desc jobs;
    
    insert into jobs values('play','놀기',15000,50000);
    commit;
    
    
    select count(job_id)
    from jobs;
    
    
    select count(distinct job_id)
    from employees;

--8. 직원의 이름과 관리자 이름을 조회하시오.
    select emp.first_name 직원이름, mgr.first_name 상사이름
    from employees emp join employees mgr
    on emp.manager_id = mgr.manager_id;

--9. 직원의 이름과 관리자 이름을 조회하시오.
--관리자가 없는 직원정보도 모두 출력하시오.

    

--10. 관리자 이름과 관리자가 관리하는 직원의 수를 조회하시오.
--단, 관리직원수가 3명 이상인 관리자만 출력되도록 하시오.

select mgr.first_name 관리자이름, count(emp.first_name) 직원수
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

