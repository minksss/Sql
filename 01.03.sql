select*
from job_history;

select employee_id, job_id, department_id 
from job_history 
union
select employee_id, job_id, department_id
from employees
where employee_id = 101;

select employee_id, job_id, department_id 
from job_history  --과거직무 
--중간에 order by가 들어갈 수 없다. 
union all
select employee_id, job_id, department_id
from employees
where employee_id = 101; --현재직무

select employee_id, job_id, department_id, start_date, end_date
from job_history  --과거직무 
--중간에 order by가 들어갈 수 없다. 
union all
select employee_id, job_id, department_id, sysdate, null
from employees; --현재직무

--orderby는 마지막에 작성한다

--직원목록(이름, 급여)
--부서목록(부서이름, 없음)
select first_name, salary
from employees
union all
select department_name, 0
from departments;

select employee_id, job_id, department_id
from job_history  --과거직무 
--중간에 order by가 들어갈 수 없다. 
intersect
select employee_id, job_id, department_id
from employees; --현재직무


update employees
set job_id = 'IT_PROG'
where employee_id = 101;
--trigger(PL/SQL)가 동작
--employees의 job_id 또는 department_id가 수정되면 job_histroy에 
--insert한다

select count(distinct employee_id)
from job_history;

select employee_id
from employees 
minus
select employee_id
from job_history;



--직원코드, 직원이름, 입사일
--부서이름, 매니저
select employee_id, first_name, hire_date,'직원';
from employees
union all
select '부서', department_name,  to_char(manager_id)
from departments;




select * 
from emp, ( select deptno, sum(sal) from emp 
            group by deptno) aa
            where emp.deptno = aa.deptno;
            
--분석함수 이용
select ename, sal, deptno,
(select sum(sal) from emp where deptno = aa.deptno) 부서급여합,
    sum(sal) over (partition by deptno) 부서급여합2,
    sum(sal) over (partition by deptno order by sal asc) 부서급여합3,
    sum(sal) over (partition by deptno order by sal desc) 부서급여합4

    from emp aa;
    

select ename, sal, deptno,
sum(sal) over (order by sal asc) 부서급여합5
from emp aa;

--직무별 가장 급여가 많은 직원은?
--1) (multi column) 상관 subquery 
     select *
     from emp
     where (job, sal) in (select job, max(sal)
                             from emp
                             group by job);
     
--2) inlineview
    select * 
    from emp join (select job, max(sal) sal
                             from emp
                             group by job) 
    using (job, sal);

--3) 분석함수
    select empno, ename, sal, job, 
        max(sal) over(partition by job) 직무별급여합계
    from emp;


select*
from(
    select empno, ename, sal, job, 
        max(sal) over(partition by job) 직무별급여합계
    from emp) aa
    where sal = aa.직무별급여합계;

--select하고 난 다음에 넘버링
select rownum, ename, sal
, rank() over(order by sal desc) 순위
,DENSE_RANK() over(order by sal desc) 순위2
, row_number() over(order by sal desc) 순위3
from emp;


select rownum, ename, sal,deptno
, rank() over(partition by deptno order by sal desc) 순위
,DENSE_RANK() over(partition by deptno order by sal desc) 순위2
, row_number() over(partition by deptno order by sal desc) 순위3
from emp;





