--연관배열
 
set serveroutput on;

declare 
--Type선언
    TYPE enameArr IS TABLE OF 
    employees.last_name%type -- 아니면 이거 VARCHAR2(20)
    INDEX BY PLS_INTEGER;
    -- PLS_INTEGER가 실제 기계적인 연산을 수행하기 때문에 처리속도가 더 빠름
    
    TYPE enameArr2 IS TABLE OF 
    employees.last_name%type -- 아니면 이거 VARCHAR2(20)
    INDEX BY BINARY_INTEGER;
    
    TYPE enameArr3 IS TABLE OF 
    employees.last_name%type -- 아니면 이거 VARCHAR2(20)
    INDEX BY VARCHAR2(10);
    
    TYPE dateArr IS TABLE OF 
    date INDEX BY BINARY_INTEGER; 
    
    TYPE cityArr IS TABLE OF
    varchar2(50); --index by 생략시 자동으로 1,2,3,4,,,,,

    

--변수 선언
    V_ENAME enameArr;
    V_ENAME2 enameArr2;
    V_ENAME3 enameArr3;
    V_HDATE dateArr;
    V_CITY cityArr := cityArr('서울','부산','대전');
begin
    V_ENAME(10) := 'HELLO';
    V_ENAME(11) := 'HI';
    DBMS_OUTPUT.PUT_LINE(V_ENAME(10));
    DBMS_OUTPUT.PUT_LINE(V_ENAME(11));
    
    V_ENAME2(12) := 'HELLO2';
    V_ENAME2(13) := 'HI2';
    DBMS_OUTPUT.PUT_LINE(V_ENAME2(12));
    DBMS_OUTPUT.PUT_LINE(V_ENAME2(13));
    
    V_ENAME3('반장') := 'HELLO3';
    V_ENAME3('부') := 'HI3';
    DBMS_OUTPUT.PUT_LINE(V_ENAME3('반장'));
    DBMS_OUTPUT.PUT_LINE(V_ENAME3('부'));
    
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
    
    --반복문
    FOR V_COUNT IN V_HDATE.FIRST..V_HDATE.LAST 
    LOOP 
     --DBMS_OUTPUT.PUT_LINE(V_COUNT);   --인덱스 번호
     IF V_HDATE.EXISTS(V_COUNT)  THEN
     DBMS_OUTPUT.PUT_LINE(V_COUNT);   --배열 값  
     DBMS_OUTPUT.PUT_LINE(V_HDATE(V_COUNT));   --배열 값
     END IF;
     END LOOP;
     
     DBMS_OUTPUT.PUT_LINE(V_CITY.COUNT);
     FOR IDX IN 1..V_CITY.COUNT 
     LOOP
        DBMS_OUTPUT.PUT_LINE(V_CITY(IDX));
     END LOOP;
end;

DECLARE 
--DEPTTYPE은 부서테이블의 여러건 가능  
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
        
        --직원 100~110 -> 테이블에 넣기 
        
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
    V_LOCATION := LOCATION_TYPE('서울', '대구','부산',NULL,NULL);
    V_LOCATION(4) := 'MULTI';
    V_LOCATION(5) := 'HEHE';
    FOR IDX IN 1..V_LOCATION.COUNT 
    LOOP
        DBMS_OUTPUT.PUT_LINE(V_LOCATION(IDX));
    END LOOP;
END;
/


--명시적 커서

declare
    --커서를 선언한 것 (그렇기 때문에 into를 쓰지 않는다)
    cursor cur_emp is 
    select employee_id, first_name from employees
    where department_id = 60;
    
    cursor cur_emp2 is 
    select * from employees
    where department_id = 60;
    
    v_empid employees.employee_id%type;
    v_fname employees.first_name%type;
    v_rec employees%rowtype; -- 레코드 
    
begin
    --커서 실행(열기)
    open cur_emp;
    
    loop 
        fetch cur_emp into v_empid, v_fname;
        exit when cur_emp%notfound;
        dbms_output.put_line(v_empid || ' + ' || v_fname);
    end loop;
    --커서 닫기 (매우 중요)
    close cur_emp;
    
        --커서 실행(열기)
    open cur_emp2;
    
    loop 
        fetch cur_emp2 into v_rec;
        exit when cur_emp2%notfound;
        dbms_output.put_line(v_rec.employee_id || ' + ' || v_rec.first_name);
    end loop;
    --커서 닫기 (매우 중요)
      dbms_output.put_line('-----------------');

    close cur_emp2;
    
    

    --for문은 커서 자동으로 open, fetch, close
    for v_rec2 in cur_emp2 
    loop
            dbms_output.put_line(v_rec2.employee_id || ' + ' || v_rec2.first_name);
    end loop;

      dbms_output.put_line('-----------------');
      
    --for문은 자동으로 커서처리
    for v_rec2 in (select * from employees where job_id = 'IT_PROG')
    loop
            dbms_output.put_line(v_rec2.last_name || ' + ' || v_rec2.job_id);
    end loop;

end;
/

    -- 급여가 특정 값 이상인 직원들 조회
execute sp_cursort(2000);

create or replace procedure sp_cursort(v_sal in number)
is

    --명시적 커서 
        cursor cur_empsal is 
            select * from employees
            where salary >= v_sal;
    
    --파라미터가 포함된 커서
        cursor cur_empsal(ss number) is 
            select * from employees
            where salary >= ss;
    
        
        v_emp employees%rowtype;
    begin
    --명시적 커서 열기(select문 실행)
        open cur_empsal;
      fetch cur_empsal into v_emp;

    while cur_empsal%found loop
        --커서 fetch(한건 가져오기)
        dbms_output.put_line(v_emp.first_name);

        fetch cur_empsal into v_emp;
        --into 다음에 올 것은 select문과 일치해야 한다.
    end loop;
              dbms_output.put_line('-----------------');

    --명시적 커서 닫기 
        close cur_empsal;
    
    --암시적 커서( declare, open, fetch, close를 자동으로)
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
    
    -- 행 잠금 및 현재 행 참조
    --for update절
    
    declare
    cursor c_emp_cursor IS
    select employee_id, last_name, salary from employees
    where department_id = 80 for update of salary NOWAIT;
    --NOWAIT라고 되어있을 시 다른 session이 lock 걸었다면 
    --cursor 오픈 시 오류가 난다
    --default는 wait이다
    
    v_empid number;
    v_lname varchar2(30);
    begin
        open c_emp_cursor;
        
        loop
            fetch c_emp_cursor into v_empid, v_lname;
            exit when c_emp_cursor%notfound;
            dbms_output.put_line(v_empid || v_lname);

    --fetch건에 해당하는 row을 하나씩 업데이트하는 것 
       update employees
        set salary = 9999
        where current of c_emp_cursor;
     end loop;        
        close c_emp_cursor;
    end;
/


-- 8. 예외 처리
--예외란? 오류가 발생하더라도 중단되지 않고 계속 진행. 정상 종료 

create or replace procedure sp_no_exception
is
    v_su number := 10;
    v_su2 number := 0;
    v_lname varchar2(30);
    type location_type is varray(5) of varchar2(20);
    v_location location_type := location_type('ㅁ','ㅇ','ㄹ','ㅎ','ㄷ');
    V_REC EMPLOYEES%ROWTYPE;
begin
  --  v_su := v_su/0; --여기서 중단 됌
  
    SELECT * INTO V_REC FROM EMPLOYEES WHERE 1=0;
  
    dbms_output.put_line(v_location(1));
    v_location(6) := 'a';
    select last_name
    into v_lname 
    from employees
    where first_name = 'John'; --3건의 결과가 추출이 된다. 
    
    dbms_output.put_line('success!');

exception
when ZERO_DIVIDE then
    dbms_output.put_line('u cannot divide by 0');
when TOO_MANY_ROWS then
    dbms_output.put_line('jonna many row');
when  NO_DATA_FOUND then
    dbms_output.put_line('no fucking data!');
WHEN SUBSCRIPT_BEYOND_COUNT THEN
    dbms_output.put_line('COLLECTION의 첨자오류');
    
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
    v_su := v_su/0; --중단없이 계속 진행하고 싶을 때 
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
    --업무로직(business logic)과 오류처리를 분리하는 목적
    if v_deptid < 10 or v_deptid > 200 then 
        raise v_myexception; --강제 exception 발생
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


--만들어진 sp_exception를 다른 프로그램에서 사용

declare 

begin 
    sp_exception(9);
    dbms_output.put_line('bbaque');
    
end;
/
--------------부서번호를 이요해서 부서이름 out
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
--이용(받을 변수가 필요하다)
declare
    v_dept varchar2(40);
    v_fname varchar2(40);
begin
    --procedure를 호출한 것 
    sp_deptname(60,v_dept);
    dbms_output.put_line(v_dept);

    --함수 호출
    v_dept := f_deptname(90);
    dbms_output.put_line(v_dept);
    
    --더 자주 사용
     select first_name, f_deptname(department_id)
     into v_fname, v_dept
     from employees
     where employee_id = 100;
  dbms_output.put_line(v_dept);
end;
/

--package : procedure + function들의 묵음 
--명세부 + 실행부 
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

--trigger 자동으로 실행되는 프로그램
    select * from emp;
    --7900번은 수정안됨, 신규안됨, 삭제안됨
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


--Trigger 연습

--order_list에 insert하면 
--sales_per_date에 없으면 insert하고
--                있으면  update하기
    
    
    SELECT * FROM ORDER_LIST;
    SELECT * FROM SALES_PER_DATE;
    
    INSERT INTO ORDER_LIST VALUES('20200115', 'COFFEE',20,4000);
    
    CREATE OR REPLACE TRIGGER TRIGGER_ORDER
    AFTER INSERT ON ORDER_LIST FOR EACH ROW
    DECLARE
        --이미 존재하는가? YES --> 수정 NO --> 입력
    

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
    







