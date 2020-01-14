--�����迭
 
set serveroutput on;

declare 
--Type����
    TYPE enameArr IS TABLE OF 
    employees.last_name%type -- �ƴϸ� �̰� VARCHAR2(20)
    INDEX BY PLS_INTEGER;
    -- PLS_INTEGER�� ���� ������� ������ �����ϱ� ������ ó���ӵ��� �� ����
    
    TYPE enameArr2 IS TABLE OF 
    employees.last_name%type -- �ƴϸ� �̰� VARCHAR2(20)
    INDEX BY BINARY_INTEGER;
    
    TYPE enameArr3 IS TABLE OF 
    employees.last_name%type -- �ƴϸ� �̰� VARCHAR2(20)
    INDEX BY VARCHAR2(10);
    
    TYPE dateArr IS TABLE OF 
    date INDEX BY BINARY_INTEGER; 
    
    TYPE cityArr IS TABLE OF
    varchar2(50); --index by ������ �ڵ����� 1,2,3,4,,,,,

    

--���� ����
    V_ENAME enameArr;
    V_ENAME2 enameArr2;
    V_ENAME3 enameArr3;
    V_HDATE dateArr;
    V_CITY cityArr := cityArr('����','�λ�','����');
begin
    V_ENAME(10) := 'HELLO';
    V_ENAME(11) := 'HI';
    DBMS_OUTPUT.PUT_LINE(V_ENAME(10));
    DBMS_OUTPUT.PUT_LINE(V_ENAME(11));
    
    V_ENAME2(12) := 'HELLO2';
    V_ENAME2(13) := 'HI2';
    DBMS_OUTPUT.PUT_LINE(V_ENAME2(12));
    DBMS_OUTPUT.PUT_LINE(V_ENAME2(13));
    
    V_ENAME3('����') := 'HELLO3';
    V_ENAME3('��') := 'HI3';
    DBMS_OUTPUT.PUT_LINE(V_ENAME3('����'));
    DBMS_OUTPUT.PUT_LINE(V_ENAME3('��'));
    
    V_HDATE(1) := SYSDATE;
    V_HDATE(2) := SYSDATE + 1;
    V_HDATE(6) := SYSDATE + 2;

    
    DBMS_OUTPUT.PUT_LINE(V_HDATE.COUNT);
    DBMS_OUTPUT.PUT_LINE(V_HDATE.FIRST);
    DBMS_OUTPUT.PUT_LINE(V_HDATE.LAST);
    DBMS_OUTPUT.PUT_LINE(V_HDATE.PRIOR(3));
    DBMS_OUTPUT.PUT_LINE(V_HDATE.NEXT(2));

    
    IF V_HDATE.EXISTS(2) THEN
        DBMS_OUTPUT.PUT_LINE('yes');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('FUCK NO!');
    END IF;
    
    --�ݺ���
    FOR V_COUNT IN V_HDATE.FIRST..V_HDATE.LAST 
    LOOP 
     --DBMS_OUTPUT.PUT_LINE(V_COUNT);   --�ε��� ��ȣ
     IF V_HDATE.EXISTS(V_COUNT)  THEN
     DBMS_OUTPUT.PUT_LINE(V_COUNT);   --�迭 ��  
     DBMS_OUTPUT.PUT_LINE(V_HDATE(V_COUNT));   --�迭 ��
     END IF;
     END LOOP;
     
     DBMS_OUTPUT.PUT_LINE(V_CITY.COUNT);
     FOR IDX IN 1..V_CITY.COUNT 
     LOOP
        DBMS_OUTPUT.PUT_LINE(V_CITY(IDX));
     END LOOP;
end;

DECLARE 
--DEPTTYPE�� �μ����̺��� ������ ����  
    TYPE DEPTTYPE IS TABLE OF 
        DEPARTMENTS %ROWTYPE INDEX BY BINARY_INTEGER;
    
    TYPE EMPTYPE IS TABLE OF 
    EMPLOYEES%ROWTYPE INDEX BY PLS_INTEGER;
    
    V_DEPT DEPTTYPE;
    V_EMP EMPTYPE;
    
    BEGIN 
        SELECT * INTO V_DEPT(1) FROM DEPARTMENTS
        WHERE DEPARTMENT_ID = 60;
        DBMS_OUTPUT.PUT_LINE(V_DEPT(1).DEPARTMENT_ID);
        DBMS_OUTPUT.PUT_LINE(V_DEPT(1).DEPARTMENT_NAME);
        DBMS_OUTPUT.PUT_LINE(V_DEPT(1).LOCATION_ID);
        DBMS_OUTPUT.PUT_LINE(V_DEPT(1).MANAGER_ID);
        
        --���� 100~110 -> ���̺� �ֱ� 
        
        FOR IDX IN 100..110 
        LOOP
            SELECT * INTO V_EMP(IDX) FROM EMPLOYEES
            WHERE EMPLOYEE_ID = IDX;
        END LOOP;
        
        FOR IDX IN 100..110
        LOOP
            DBMS_OUTPUT.PUT_LINE('---------');
            DBMS_OUTPUT.PUT_LINE(V_EMP(IDX).FIRST_NAME);
        END LOOP;
    
    
END;

DECLARE
    TYPE LOCATION_TYPE IS VARRAY(5) OF VARCHAR2(20);
    V_LOCATION LOCATION_TYPE;
BEGIN
    V_LOCATION := LOCATION_TYPE('����', '�뱸','�λ�',NULL,NULL);
    V_LOCATION(4) := 'MULTI';
    V_LOCATION(5) := 'HEHE';
    FOR IDX IN 1..V_LOCATION.COUNT 
    LOOP
        DBMS_OUTPUT.PUT_LINE(V_LOCATION(IDX));
    END LOOP;
END;
/


--����� Ŀ��

declare
    --Ŀ���� ������ �� (�׷��� ������ into�� ���� �ʴ´�)
    cursor cur_emp is 
    select employee_id, first_name from employees
    where department_id = 60;
    
    cursor cur_emp2 is 
    select * from employees
    where department_id = 60;
    
    v_empid employees.employee_id%type;
    v_fname employees.first_name%type;
    v_rec employees%rowtype; -- ���ڵ� 
    
begin
    --Ŀ�� ����(����)
    open cur_emp;
    
    loop 
        fetch cur_emp into v_empid, v_fname;
        exit when cur_emp%notfound;
        dbms_output.put_line(v_empid || ' + ' || v_fname);
    end loop;
    --Ŀ�� �ݱ� (�ſ� �߿�)
    close cur_emp;
    
        --Ŀ�� ����(����)
    open cur_emp2;
    
    loop 
        fetch cur_emp2 into v_rec;
        exit when cur_emp2%notfound;
        dbms_output.put_line(v_rec.employee_id || ' + ' || v_rec.first_name);
    end loop;
    --Ŀ�� �ݱ� (�ſ� �߿�)
      dbms_output.put_line('-----------------');

    close cur_emp2;
    
    

    --for���� Ŀ�� �ڵ����� open, fetch, close
    for v_rec2 in cur_emp2 
    loop
            dbms_output.put_line(v_rec2.employee_id || ' + ' || v_rec2.first_name);
    end loop;

      dbms_output.put_line('-----------------');
      
    --for���� �ڵ����� Ŀ��ó��
    for v_rec2 in (select * from employees where job_id = 'IT_PROG')
    loop
            dbms_output.put_line(v_rec2.last_name || ' + ' || v_rec2.job_id);
    end loop;

end;
/

    -- �޿��� Ư�� �� �̻��� ������ ��ȸ
execute sp_cursort(2000);

create or replace procedure sp_cursort(v_sal in number)
is

    --����� Ŀ�� 
        cursor cur_empsal is 
            select * from employees
            where salary >= v_sal;
    
    --�Ķ���Ͱ� ���Ե� Ŀ��
        cursor cur_empsal(ss number) is 
            select * from employees
            where salary >= ss;
    
        
        v_emp employees%rowtype;
    begin
    --����� Ŀ�� ����(select�� ����)
        open cur_empsal;
      fetch cur_empsal into v_emp;

    while cur_empsal%found loop
        --Ŀ�� fetch(�Ѱ� ��������)
        dbms_output.put_line(v_emp.first_name);

        fetch cur_empsal into v_emp;
        --into ������ �� ���� select���� ��ġ�ؾ� �Ѵ�.
    end loop;
              dbms_output.put_line('-----------------');

    --����� Ŀ�� �ݱ� 
        close cur_empsal;
    
    --�Ͻ��� Ŀ��( declare, open, fetch, close�� �ڵ�����)
    for aa in cur_empsal loop
             dbms_output.put_line(aa.first_name);
    end loop;
        
        dbms_output.put_line('-----------------');

        for aa in (select * from employees where salary >= v_sal)
        loop
             dbms_output.put_line(aa.first_name);
    end loop;
    
    
    end;
    /
    
    -- �� ��� �� ���� �� ����
    --for update��
    
    declare
    cursor c_emp_cursor IS
    select employee_id, last_name, salary from employees
    where department_id = 80 for update of salary NOWAIT;
    --NOWAIT��� �Ǿ����� �� �ٸ� session�� lock �ɾ��ٸ� 
    --cursor ���� �� ������ ����
    --default�� wait�̴�
    
    v_empid number;
    v_lname varchar2(30);
    begin
        open c_emp_cursor;
        
        loop
            fetch c_emp_cursor into v_empid, v_lname;
            exit when c_emp_cursor%notfound;
            dbms_output.put_line(v_empid || v_lname);

    --fetch�ǿ� �ش��ϴ� row�� �ϳ��� ������Ʈ�ϴ� �� 
       update employees
        set salary = 9999
        where current of c_emp_cursor;
     end loop;        
        close c_emp_cursor;
    end;
/


-- 8. ���� ó��
--���ܶ�? ������ �߻��ϴ��� �ߴܵ��� �ʰ� ��� ����. ���� ���� 

create or replace procedure sp_no_exception
is
    v_su number := 10;
    v_su2 number := 0;
    v_lname varchar2(30);
    type location_type is varray(5) of varchar2(20);
    v_location location_type := location_type('��','��','��','��','��');
    V_REC EMPLOYEES%ROWTYPE;
begin
  --  v_su := v_su/0; --���⼭ �ߴ� ��
  
    SELECT * INTO V_REC FROM EMPLOYEES WHERE 1=0;
  
    dbms_output.put_line(v_location(1));
    v_location(6) := 'a';
    select last_name
    into v_lname 
    from employees
    where first_name = 'John'; --3���� ����� ������ �ȴ�. 
    
    dbms_output.put_line('success!');

exception
when ZERO_DIVIDE then
    dbms_output.put_line('u cannot divide by 0');
when TOO_MANY_ROWS then
    dbms_output.put_line('jonna many row');
when  NO_DATA_FOUND then
    dbms_output.put_line('no fucking data!');
WHEN SUBSCRIPT_BEYOND_COUNT THEN
    dbms_output.put_line('COLLECTION�� ÷�ڿ���');
    
when others then
    dbms_output.put_line('exception !!!!');
    dbms_output.put_line(SQLCODE);
    dbms_output.put_line(SQLERRM);
    
    
end;
/

execute sp_no_exception;

create or replace procedure sp_exception
is
    v_su number := 10;
    v_su2 number := 0;
begin
    v_su := v_su/0; --�ߴܾ��� ��� �����ϰ� ���� �� 
    dbms_output.put_line('success!');
end;
/

---------------------------------------------
create or replace procedure sp_exception(v_deptid in number)
is 
    v_emp employees%rowtype;
    v_test number;
    v_myexception EXCEPTION;
    
begin
    --��������(business logic)�� ����ó���� �и��ϴ� ����
    if v_deptid < 10 or v_deptid > 200 then 
        raise v_myexception; --���� exception �߻�
    end if;
    v_test := 10/0;
    select * 
    into v_emp
    from employees
    where department_id =v_deptid;
    dbms_output.put_line(v_emp.first_name || v_emp.last_name); 
    exception 
    when too_many_rows then
    dbms_output.put_line('jonnnnnnna manah, use cursor');
    when NO_DATA_FOUND then
    dbms_output.put_line('no fucking data!');
    when v_myexception then
    dbms_output.put_line('10<=number <=200');    
    when others then
        dbms_output.put_line('exception !!!!');
    dbms_output.put_line(SQLCODE);
    dbms_output.put_line(SQLERRM);    
    
    dbms_output.put_line(SQLERRM(SQLCODE));    
    
end;
/

execute sp_exception(60);


--������� sp_exception�� �ٸ� ���α׷����� ���

declare 

begin 
    sp_exception(9);
    dbms_output.put_line('bbaque');
    
end;
/
--------------�μ���ȣ�� �̿��ؼ� �μ��̸� out
--procedure
create or replace procedure sp_deptname(
v_deptid in number, v_deptname out varchar2)
is 
begin
    select department_name 
    into v_deptname
    from departments
    where department_id = v_deptid;
end;
/

--function
create or replace function f_deptname(v_deptid in number)
return varchar2
is
    v_deptname varchar2(30);
begin
    select department_name 
    into v_deptname
    from departments
    where department_id = v_deptid;
    return v_deptname;
    
end;
/
--�̿�(���� ������ �ʿ��ϴ�)
declare
    v_dept varchar2(40);
    v_fname varchar2(40);
begin
    --procedure�� ȣ���� �� 
    sp_deptname(60,v_dept);
    dbms_output.put_line(v_dept);

    --�Լ� ȣ��
    v_dept := f_deptname(90);
    dbms_output.put_line(v_dept);
    
    --�� ���� ���
     select first_name, f_deptname(department_id)
     into v_fname, v_dept
     from employees
     where employee_id = 100;
  dbms_output.put_line(v_dept);
end;
/

--package : procedure + function���� ���� 
--���� + ����� 
create or replace package pkg_multicampus is
    procedure sp_deptname( v_deptid in number, v_deptname out varchar2);
    
    function f_deptname(v_deptid in number) return varchar2;
end pkg_multicampus;
/

    create or replace package body pkg_multicampus is
     procedure  sp_deptname(
         v_deptid in number, v_deptname out varchar2)
         is 
          begin
        select department_name 
        into v_deptname
        from departments
        where department_id = v_deptid;
        end sp_deptname;
        
       function f_deptname(v_deptid in number)
        return varchar2
        is
            v_deptname varchar2(30);
        begin
            select department_name 
            into v_deptname
            from departments
            where department_id = v_deptid;
            return v_deptname;
        end f_deptname; 
end pkg_multicampus;
/

declare 
    v_deptname varchar2(40);
begin
     pkg_multicampus.sp_deptname(60, v_deptname);
    dbms_output.put_line(v_deptname);
    
    v_deptname := pkg_multicampus.f_deptname(60);
    dbms_output.put_line(v_deptname);
    
    select pkg_multicampus.f_deptname(department_id)
    into v_deptname
    from employees
    where employee_id = 100;
    dbms_output.put_line(v_deptname);
end;
/

--trigger �ڵ����� ����Ǵ� ���α׷�
    select * from emp;
    --7900���� �����ȵ�, �űԾȵ�, �����ȵ�
    delete from emp where empno = 7900; 
    insert into emp (empno, ename) values(7900,'aa');
    update emp set ename='aa' where empno = 7900;
    

    
    create or replace trigger trigger_emp
    before update or delete or insert on emp for each row
    declare
    v_message varchar2(100) := '';
    begin
        if updating then 
            if :old.empno =7900 then 
                v_message := '7900 cannot update mufufker';
                raise_application_error(-20001,v_message);
            end if;
        end if;
        
        if deleting then
            if :old.empno = 7900 then
                v_message := 'no delete';
                raise_application_error(-20002,v_message);
            end if;
        end if;
        
    end;
    /


--Trigger ����

--order_list�� insert�ϸ� 
--sales_per_date�� ������ insert�ϰ�
--                ������  update�ϱ�
    
    
    SELECT * FROM ORDER_LIST;
    SELECT * FROM SALES_PER_DATE;
    
    INSERT INTO ORDER_LIST VALUES('20200115', 'COFFEE',20,4000);
    
    CREATE OR REPLACE TRIGGER TRIGGER_ORDER
    AFTER INSERT ON ORDER_LIST FOR EACH ROW
    DECLARE
        --�̹� �����ϴ°�? YES --> ���� NO --> �Է�
    

    BEGIN
        UPDATE SALES_PER_DATE
        SET QTY = QTY + :NEW.QTY, 
            AMOUNT = AMOUNT + :NEW.AMOUNT
        WHERE SALE_DATE = :NEW.ORDER_DATE
        AND   PRODUCT = :NEW.PRODUCT;
    
        IF SQL%NOTFOUND THEN
        INSERT INTO SALES_PER_DATE VALUES(
        :NEW.ORDER_DATE,
        :NEW.PRODUCT,
        :NEW.QTY,
        :NEW.AMOUNT);
        END IF;
        --COMMIT;
         DBMS_OUTPUT.PUT_LINE('YAYAYAYYYAYAY');
    EXCEPTION WHEN OTHERS THEN 
       -- ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('EROROROROROROR');
    END;
    /
    
    
    CREATE TABLE ORDER_LIST (
    ORDER_DATE CHAR(8) NOT NULL,
    PRODUCT VARCHAR2(10) NOT NULL,
    QTY NUMBER NOT NULL,
    AMOUNT NUMBER NOT NULL);
    
    
    CREATE TABLE SALES_PER_DATE (
    SALE_DATE CHAR(8) NOT NULL,
    PRODUCT VARCHAR2(10) NOT NULL,
    QTY NUMBER NOT NULL,
     AMOUNT NUMBER NOT NULL);
    







