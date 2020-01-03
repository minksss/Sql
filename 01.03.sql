select*
from job_history;

select employee_id, job_id, department_id 
from job_history 
union
select employee_id, job_id, department_id
from employees
where employee_id = 101;

select employee_id, job_id, department_id 
from job_history  --�������� 
--�߰��� order by�� �� �� ����. 
union all
select employee_id, job_id, department_id
from employees
where employee_id = 101; --��������

select employee_id, job_id, department_id, start_date, end_date
from job_history  --�������� 
--�߰��� order by�� �� �� ����. 
union all
select employee_id, job_id, department_id, sysdate, null
from employees; --��������

--orderby�� �������� �ۼ��Ѵ�

--�������(�̸�, �޿�)
--�μ����(�μ��̸�, ����)
select first_name, salary
from employees
union all
select department_name, 0
from departments;

select employee_id, job_id, department_id
from job_history  --�������� 
--�߰��� order by�� �� �� ����. 
intersect
select employee_id, job_id, department_id
from employees; --��������


update employees
set job_id = 'IT_PROG'
where employee_id = 101;
--trigger(PL/SQL)�� ����
--employees�� job_id �Ǵ� department_id�� �����Ǹ� job_histroy�� 
--insert�Ѵ�

select count(distinct employee_id)
from job_history;

select employee_id
from employees 
minus
select employee_id
from job_history;



--�����ڵ�, �����̸�, �Ի���
--�μ��̸�, �Ŵ���
select employee_id, first_name, hire_date,'����';
from employees
union all
select '�μ�', department_name,  to_char(manager_id)
from departments;




select * 
from emp, ( select deptno, sum(sal) from emp 
            group by deptno) aa
            where emp.deptno = aa.deptno;
            
--�м��Լ� �̿�
select ename, sal, deptno,
(select sum(sal) from emp where deptno = aa.deptno) �μ��޿���,
    sum(sal) over (partition by deptno) �μ��޿���2,
    sum(sal) over (partition by deptno order by sal asc) �μ��޿���3,
    sum(sal) over (partition by deptno order by sal desc) �μ��޿���4

    from emp aa;
    

select ename, sal, deptno,
sum(sal) over (order by sal asc) �μ��޿���5
from emp aa;

--������ ���� �޿��� ���� ������?
--1) (multi column) ��� subquery 
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

--3) �м��Լ�
    select empno, ename, sal, job, 
        max(sal) over(partition by job) �������޿��հ�
    from emp;


select*
from(
    select empno, ename, sal, job, 
        max(sal) over(partition by job) �������޿��հ�
    from emp) aa
    where sal = aa.�������޿��հ�;

--select�ϰ� �� ������ �ѹ���
select rownum, ename, sal
, rank() over(order by sal desc) ����
,DENSE_RANK() over(order by sal desc) ����2
, row_number() over(order by sal desc) ����3
from emp;


select rownum, ename, sal,deptno
, rank() over(partition by deptno order by sal desc) ����
,DENSE_RANK() over(partition by deptno order by sal desc) ����2
, row_number() over(partition by deptno order by sal desc) ����3
, ntile(3) over (order by sal desc) ���
, ntile(2) over (order by sal desc) ���
from emp;

select ename, sal, hiredate
,lag(sal, 1) over (order by hiredate) ��sal
,lag(sal, 2) over (order by hiredate) ����sal
,lead(sal, 1) over (order by hiredate) ��sal
,lead(sal, 2) over (order by hiredate) ����sal
from emp;

SELECT empno, ename, deptno, sal
, sum(sal) over(order by deptno, empno)  
, sum(sal) over(order by deptno, empno rows between unbounded preceding and unbounded following ) sal2
, sum(sal) over(order by deptno, empno rows between unbounded preceding and current row ) sal3
, sum(sal) over(order by deptno, empno rows between current row and unbounded following) sal4
FROM emp;

select empno,ename, hiredate, sal, deptno 
, first_value(ename) over(partition by deptno order by sal desc rows between unbounded preceding and unbounded following) �޳�
, last_value(ename) over(partition by deptno order by sal desc rows between unbounded preceding and unbounded following) ����
from emp;

select empno,ename, hiredate, sal, deptno 
, round(ratio_to_report(sal) over(),2) aa
, trunc(sal/sum(sal)over(),2) cc
, ratio_to_report(sal) over(partition by deptno) bb
, trunc(sal / sum(sal) over (partition by deptno),2)
from emp;

select round(3.1)  �ݿø�, trunc(3.7) ����,
ceil(3.1) �����������οø�, 
floor(3.1) �����ǹ���_����
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
                          AND INTERVAL '1' MONTH PRECEDING) "���� 3���� �հ�"
     , SUM(amt) OVER(ORDER BY TO_DATE(yyyymm,'yyyymm')
                RANGE BETWEEN INTERVAL '1' MONTH FOLLOWING
                          AND INTERVAL '3' MONTH FOLLOWING) "���� 3���� �հ�" 
  FROM test;

select level ����, enmpno, mgr, SYS_CONNECT_BY_PATH(ename, '/'),
connect_by_isleaf(ename) ������level
from emp
start with ename = 'KING'
connect by prior empno = mgr;