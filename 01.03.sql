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
from emp;





