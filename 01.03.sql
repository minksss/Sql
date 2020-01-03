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
, ntile(3) over (order by sal desc) 등분
, ntile(2) over (order by sal desc) 등분
from emp;

select ename, sal, hiredate
,lag(sal, 1) over (order by hiredate) 전sal
,lag(sal, 2) over (order by hiredate) 전전sal
,lead(sal, 1) over (order by hiredate) 후sal
,lead(sal, 2) over (order by hiredate) 후후sal
from emp;

SELECT empno, ename, deptno, sal
, sum(sal) over(order by deptno, empno)  
, sum(sal) over(order by deptno, empno rows between unbounded preceding and unbounded following ) sal2
, sum(sal) over(order by deptno, empno rows between unbounded preceding and current row ) sal3
, sum(sal) over(order by deptno, empno rows between current row and unbounded following) sal4
FROM emp;

select empno,ename, hiredate, sal, deptno 
, first_value(ename) over(partition by deptno order by sal desc rows between unbounded preceding and unbounded following) 급높
, last_value(ename) over(partition by deptno order by sal desc rows between unbounded preceding and unbounded following) 급작
from emp;

select empno,ename, hiredate, sal, deptno 
, round(ratio_to_report(sal) over(),2) aa
, trunc(sal/sum(sal)over(),2) cc
, ratio_to_report(sal) over(partition by deptno) bb
, trunc(sal / sum(sal) over (partition by deptno),2)
from emp;

select round(3.1)  반올림, trunc(3.7) 버림,
ceil(3.1) 무조건정수로올림, 
floor(3.1) 무조건버림_정수
from dual;


WITH test AS
(
SELECT '201901' yyyymm, 100 amt FROM dual
UNION ALL SELECT '201902', 200 FROM dual
UNION ALL SELECT '201903', 300 FROM dual
UNION ALL SELECT '201904', 400 FROM dual
UNION ALL SELECT '201905', 500 FROM dual
UNION ALL SELECT '201906', 600 FROM dual
UNION ALL SELECT '201908', 800 FROM dual
UNION ALL SELECT '201909', 900 FROM dual
UNION ALL SELECT '201910', 100 FROM dual
UNION ALL SELECT '201911', 200 FROM dual
UNION ALL SELECT '201912', 300 FROM dual
)
SELECT yyyymm
     , amt
     , SUM(amt) OVER(ORDER BY TO_DATE(yyyymm,'yyyymm')
                RANGE BETWEEN INTERVAL '3' MONTH PRECEDING
                          AND INTERVAL '1' MONTH PRECEDING) "직전 3개월 합계"
     , SUM(amt) OVER(ORDER BY TO_DATE(yyyymm,'yyyymm')
                RANGE BETWEEN INTERVAL '1' MONTH FOLLOWING
                          AND INTERVAL '3' MONTH FOLLOWING) "이후 3개월 합계" 
  FROM test;

select level 차수, enmpno, mgr, SYS_CONNECT_BY_PATH(ename, '/'),
connect_by_isleaf(ename) 마지막level
from emp
start with ename = 'KING'
connect by prior empno = mgr;