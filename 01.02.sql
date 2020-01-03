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
                    
select * 0p
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
                where salary >= 30000
                );
                
--�ڽ��� �μ��� ��պ��� ���� �޿��� �޴� ������ ��ȸ

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
                 where department_id = e.department_id)  �μ����
from employees e
where salary < ( select avg(salary) 
                 from employees 
                 where department_id = e.department_id);
                 
                 
select first_name, department_id, salary
from employees,(
select department_id aa, round(avg(salary),2) �μ����
from employees 
group by department_id) inlineview
where employees.department_id = inlineview.aa
;
--�Ŵ����� �ƴ� ������ ��ȸ
--�Ŵ����� 18���̴�

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

--5. �������� �̸�, �Ի���, �μ����� ��ȸ�Ͻÿ�.
--��, �μ��� ���� ������ �ִٸ� �� ���������� ��°���� ���Խ�Ų��.
--�׸��� �μ��� ���� ������ ���ؼ��� '<�μ�����>' �� ��µǵ��� �Ѵ�.

select first_name, hire_date, nvl(department_name, '�μ�����') �μ��̸�
from employees left outer join departments
using(department_id);

--6. ������ ��å�� ���� ������ �ٸ��� �����Ϸ��� �Ѵ�.
--��å�� 'Manager'�� ���Ե� ������ �޿��� 0.5�� ���ϰ�
--������ �����鿡 ���ؼ��� ������ �޿��� �����ϵ��� �Ѵ�. 
--�����ϰ� ��ȸ�Ͻÿ�. 
--(using decode or case)

select first_name, job_title, salary, substr(job_title, -7) ���޸�, 
    decode( substr(job_title,-7),'Manager',salary*0.5, salary) ���ޱݾ�,
    case when job_title like '%Manager' then salary*0.5 else salary end  ���ޱݾ�2
from employees join jobs
using(job_id);

--7. �� �μ����� �����޿��� �޴� ������ �̸��� �μ�id, �޿��� ��ȸ�Ͻÿ�.
--1) inline view ��� 

select first_name, employees.department_id, salary
from employees ,(
            select department_id, min(salary) minsal
            from employees
            group by department_id) dept_group 
where employees.department_id = dept_group.department_id
and employees.salary = dept_group.minsal;

--��� sub query 
select first_name, aa.department_id, salary 
from employees aa 
where salary = ( select min(salary) 
                    from employees
                    where department_id = aa.department_id)
                    ;
--multi-column �̿�

select first_name, aa.department_id, salary 
from employees aa 
where (department_id, salary) in(

select department_id, min(salary)
from employees
group by department_id);



--8. �� ���޺�(job_title) �ο����� ��ȸ�ϵ� ������ ���� ������ �ִٸ� �ش� ���޵�
--��°���� ���Խ�Ű�ÿ�. �׸��� ���޺� �ο����� 3�� �̻��� ���޸� ��°���� ���Խ�Ű�ÿ�.

select job_title, count(employee_id)
from employees join jobs using(job_id)
group by job_title
having count(employee_id) >= 3;

--9. �� �μ��� �ִ�޿��� �޴� ������ �̸�, �μ���, �޿��� ��ȸ�Ͻÿ�.

select first_name, department_name, salary
from employees join departments using (department_id)
where (department_id, salary) in ( select department_id, max(salary)
                                    from departments
                                    group by department_id);
                                    
                   



--10. ������ �̸�, �μ�id, �޿��� ��ȸ�Ͻÿ�. �׸��� ������ ���� �ش� �μ��� 
--�ּұ޿��� �������� ���Խ��� ��� �Ͻÿ�.
--��Į�� �������� ���

    select first_name, department_id, salary,
                (select min(salary) from employees
                  where department_id = aa.department_id ) �ּұ޿�
    from employees aa;




--11. �޿��� ���� ���� �޴� ���� 5���� ���� ������ ��ȸ�Ͻÿ�.
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



--12. Ŀ�̼��� ���� ���� �޴� ���� 3���� ���� ������ ��ȸ�Ͻÿ�.
--(oracle�� null�� �켱�̴�)
select rownum seq, aa.*
from(
select first_name, commission_pct
from employees
order by commission_pct desc nulls last 
) aa
where rownum <= 10;

--13. ���� �Ի��� ���� ��ȸ�ϵ�, �Ի��� ���� 10�� �̻��� ���� ����Ͻÿ�.

select to_char(hire_date, 'mm'), count(*)
from employees
group by to_char(hire_date, 'mm')
having count(*) >= 10
order by 1;

--14. �⵵�� �Ի��� ���� ��ȸ�Ͻÿ�. 
--��, �Ի��ڼ��� ���� �⵵���� ��µǵ��� �մϴ�.

select to_char(hire_date, 'yyyy'), count(*)
from employees
group by to_char(hire_date, 'yyyy')
order by 2 desc;




--1. 'Southlake'���� �ٹ��ϴ� ������ �̸�, �޿�, ��å(job_title)�� ��ȸ�Ͻÿ�.
    
    select first_name, job_title, salary
    from employees join departments using (department_id)
                   join locations using (location_id)
                   join jobs using (job_id)
    where city = 'Southlake';
       
        
--2. ������ �ٹ� �ο����� ��ȸ�Ͻÿ�. ��, �ο����� 3�� �̻��� ���������� ��µǾ����.
    
    select country_id, count(*)
    from employees join departments using(department_id)
                    join locations using (location_id)
                    join countries using (country_id)
                    group by country_id
                    having count(*) >=3;
                    
--3. ������ �̸�, �޿�, ������ ������ �̸��� ��ȸ�Ͻÿ�. ��, �����ڰ� ���� ������
--   '<������ ����>'�� ��µǵ��� �ؾ� �Ѵ�.

 select ����.first_name, ����.salary, ������.first_name
 from employees ����, employees ������
 where ����.manager_id = ������.employee_id;
 

--4. ������ �̸�, �μ���, �ٹ������ ��ȸ�ϵ�, 20�� �̻� ��� �ټ��ڸ� ��µǷ��Ѵ�.
--5. �� �μ� �̸����� �ִ�޿��� �ּұ޿��� ��ȸ�Ͻÿ�. ��, �ִ�/�ּұ޿��� ������
--   �μ��� ��°������ ���ܽ�Ų��.

--6. �ڽ��� ���� �μ��� ��ձ޿����� ���� �޿��� �޴� ���������� ��ȸ�Ͻÿ�.
--   ��, ��°���� �ڽ��� ���� �μ��� ��� �޿������� ��µǾ���Ѵ�. 
    select first_name, salary, department_id
    from employees aa
    where salary > ( select avg(salary) 
                     from employees
                     where department_id = aa.department_id);
--7. '��'�� �ִ�޿����� �̸�, �޿��� ��ȸ�Ͻÿ�.
select first_name, hire_date, salary 
from employees
where (to_char(hire_date, 'mm'),salary) in(
select to_char(hire_date, 'mm'), max(salary)
from employees
group by to_char(hire_date,'mm'))
order by to_char(hire_date, 'mm');

--8. �μ���, ���޺�, ��ձ޿��� ��ȸ�Ͻÿ�. 
--   ��, ��ձ޿��� 50���μ��� ��պ��� ���� �μ��� ��µǾ�� �մϴ�.
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
--9. �ڽ��� �����ں��� ���� �޿��� �޴� ������ �̸��� �޿��� ��ȸ�Ͻÿ�.
select first_name, salary, manager_id
from employees aa
where salary > (select salary from employees
                where employee_id = aa.manager_id
                );
                
 select employee_id, salary from employees 
 where employee_id in(148,149);
--10. �޿��� ���� ���� ���� 6��°���� 10��° ������ ����Ͻÿ�.
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




--1. BLAKE�� ������ �μ��� ���� ��� ����� �̸��� �Ի����� ǥ���ϴ� ���Ǹ� �ۼ��Ͻÿ�.
--������� BLAKE�� ���ܽ�ŵ�ϴ�.j

select * 
from emp
where deptno = (
            select deptno
            from emp
            where ename = 'BLAKE')
and ename <> 'BLAKE';

--2. �μ��� ��ġ�� DALLAS�� ��� ����� �̸�, �μ���ȣ , ������ ǥ���Ͻÿ� 

select * 
from emp 
where deptno = ( select deptno from dept
where loc = 'DALLAS')
;

--3. KING���� �����ϴ� ��� ����� �̸��� �޿��� ǥ���ϴ� ���Ǹ� �ۼ��Ͻÿ� 
select ename, sal
from emp 
where mgr = (
                select empno
                from emp 
                where ename = 'KING');

select * 
from emp
where ename = 'KING'
;
-- LAB(07����)
-- subquery�� ����Ͽ� Query �ذ�
select sal 
from emp where ename = 'JONES';

select ename, sal, deptno
from emp 
where sal > (select sal 
from emp where ename = 'JONES');

--���̺��� ��� �޿����� �� ���� �޿��� �޴� ����� �˻�
select ename, sal, deptno
from emp
where sal > (select avg(sal) from emp);

-- ���̺��� �μ��� �ּ� �޿��� ������ �޿��� ���� ����� �˻�
select ename, sal, deptno
from emp 
where sal in (select min(sal) from emp group by deptno);

--Multiple ros subquery ���
select ename, sal, deptno
from emp 
where sal in(select min(sal) from emp group by deptno);

select ename, sal, deptno 
from emp 
where sal IN (950,800,1300);

select ename, sal, deptno 
from emp
where sal = 950 or sal = 800 or sal = 1300;

select ename, sal, deptno 
from emp 
where sal > any ( select avg(sal) from emp 
                    group by deptno);
                    
--������ ��� �μ��� ��� �޿����� �� ���� �޿��� �޴� ����� �˻�
select ename, sal, deptno 
from emp
where sal > ALL (
                select avg(sal) 
                from emp 
                group by deptno);
--subquery�� not in ���� ��� �� ���ǻ���
select ename, mgr, sal ,deptno 
from emp
where empno IN (select mgr from emp);

select ename, mgr, sal, deptno
from emp
where empno NOT IN (select mgr from emp);

select ename, sal, deptno
from emp
where deptno in (10,20, NULL);

select empno, ename, sal, deptno 
from emp aa
where sal > ( select avg(sal)
                from emp 
                group by aa.deptno);

select empno, ename, deptno, sal,
(select sum(sal) from emp group by aa.deptno) total
from emp aa ;

SELECT a.empno, a.ename, a.deptno, a.sal , SUM(b.sal) AS TOTAL
     FROM ( SELECT empno, ename, sal, deptno
            FROM emp
            WHERE deptno = 10 ) a ,
          ( SELECT empno, ename, sal, deptno
            FROM emp
            WHERE deptno = 10 ) b
WHERE a.empno >= b.empno
GROUP BY a.empno, a.ename, a.deptno, a.sal
ORDER BY a.empno ;

--LAB 06 13)

select last_name, salary, job_id,employees.department_id
from employees, (
                 select department_id, max(salary) maxsal
                 from employees 
                 group by department_id) dept_group
where employees.department_id = dept_group.department_id
and employees.salary = dept_group.maxsal
order by department_id asc;
       
select to_char(hire_date, 'mm'),count(*)
from employees 
group by to_char(hire_date, 'mm')
having to_char(hire_date, 'yyyy',1981);

select prods.prod_id, prods.prod_name, NVL(s.ps,0)
from prods left outer join( select prod_id, sum(quantity_sold) ps
                            from sales
                            group by prod_id) S
                        on prods.prod_id = S.prod_id;
                        
-- Lab 06AD 6��
--1) subquery

select ename, sal, (select sal 
                    from emp
                    where ename = 'JONES' ) "Jones�� salary"
from emp 
where sal > (
select sal 
from emp
where ename = 'JONES'
             );           
--2) self-join

select ����.ename, ����.sal, ����.sal
from emp ����, emp ����
where ����.sal > ����.sal
and ����.ename = 'JONES';

--7��) in, not in, exists, not exists
--1) not in
select * 
from departments 
where department_id not in ( select distinct department_id
                             from employees );
                             

--2) not exists

select *
from departments aa
where not exists ( select 1
                    from employees 
                    where department_id = aa.department_id);
                             
--8��
select aa.* , (select 'YES'
                from dual
                where exists
                (select 1
                from emp
                where deptno = aa.deptno
                )
                )
                from dept aa;
                
select dept.* , ( select 1 from emp where emp.deptno = dept.deptno
from dept;


select * from orders;
select * from order_items
where order_id = 2458;

select * from wishlist
where cust_id =106 and product_id = 3039;

where cust_id, product_id
from orders join order_items using (order_id)
where cust_id = 106 and product_id = 3090;

select cust_id, product_id, sum(unit_price*quantity) ������
from wishlist
group by cust_id, product_id;


select cust_id, product_id, sum(unit_price*quantity) �ֹ���
from orders join order_items using(order_id)
group by cust_id, product_id;


select nvl(aa.cust_id, bb.cust_id) cust_id,
nvl(aa.product_id, bb.product_id) product_id,
aa.������, bb.�ֹ���
from (
select cust_id, product_id, sum(unit_price*quantity) ������
from wishlist
group by cust_id, product_id_ aa full outer join

select cust_id, product_id, sum(unit_price*quantity) �ֹ���
from orders join order_items using(order_id)
group by cust_id, product_id)bb
on(aa.cust_id = bb.cust_id and aa.product_id = bb.product_id);


select prod_id, prod_name, sum(quantity_sold) �Ǹ��հ�
from prods left outer join sales using (prod_id)
group by prod_id, prod_name;

                        
select to_char(hiredate,'yyyy/mm') mon, count(*) �Ի��ڼ�
from emp
where hiredate between '1981/01/01' and '1981/12/31';

--12��)
select ��, nvl(�Ի��ڼ�,0)
from (
select '1981/'||lpad(level, 2, 0) ��
from dual 
connect by level <=12) aa left outer join (
select to_char(hiredate,'yyyy/mm') ��, count(*) �Ի��ڼ�
from emp
where hiredate between '1981/01/01' and '1981/12/31'
group by to_char(hiredate,'yyyy/mm')
                                            ) bb
using( ��)
order by 1;
                        
--13��
--inline view(������ ���̺�)
select first_name, aa.department_id, salary 
from employees 
join (
select department_id, max(salary) maxsal
from employees
group by department_id) aa  
on (employees.department_id=aa.department_id
and employees.salary = aa.maxsal)
order by 3;

select * 
from emp, ( select deptno, sum(sal) from emp 
            group by deptno) aa
            where emp.deptno = aa.deptno;
            



                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
