
--SQL 문으로 작성한 것
create table emp_sum
as select deptno, sum(sal) as sum_sal
from emp 
group by deptno;

select * from emp_sum;

update emp_sum 
set sum_sal = 8750
where deptno = 10;

commit;

select empno, ename, sal, deptno
from emp 
where empno = 7788;

delete emp 
where empno = 7788;

update emp_sum
set sum_sal = sum_sal - 3000
where deptno = 20;

select * from emp_sum;

rollback;

--PL/SQL문으로 작성한 것

set serveroutput on;

declare 
    emp_rec emp%rowtype;
    sum_rec emp_sum%rowtype;
begin
    select * into emp_rec
    from emp
    where empno = 7788;
    
    delete emp 
    where empno = 7788;
    
    update emp_sum
    set sum_sal = sum_sal - emp_rec.sal
    where deptno = emp_rec.deptno;
    
    select * into sum_rec
    from emp_sum
    where deptno = emp_rec.deptno;
    
    dbms_output.put_line(sum_rec.sum_sal);
end;

/
rollback;

--Procedure생성

create or replace procedure delete_emp
(   p_empno NUMBER) AS
    emp_rec emp%rowtype;
    sum_rec emp_sum%rowtype;

BEGIN
    select * into emp_rec
    from emp
    where empno = p_empno;
    
    delete emp 
    where empno = p_empno;
    
    update emp_sum
    set sum_sal = sum_sal - emp_rec.sal
    where deptno = emp_rec.deptno;
    
    select * into sum_rec
    from emp_sum
    where deptno = emp_rec.deptno;
    
    dbms_output.put_line(sum_rec.sum_sal);

end;
/

set serveroutput on;
execute delete_emp(7788);

rollback;

--실행문 작성 (변수 정의)

set serveroutput on
declare 
 v_hiredate DATE;
 v_deptno number(2) not null :=10;
 v_location varchar2(13) :='Atlanta';
 c_comm constant number := 1400;
 
 begin 
 DBMS_OUTPUT.PUT_LINE(V_HIREDATE);
 DBMS_OUTPUT.PUT_LINE(V_DEPTNO);
 DBMS_OUTPUT.PUT_LINE(V_LOCATION);
 DBMS_OUTPUT.PUT_LINE(C_COMM);
 
 END;
 /
 
 --PL/SQL에서 DATA TYPE의 주의 사항
 ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-RR';
 SET SERVEROUTPUT ON;
 DECLARE 
    V_HIREDATE DATE := '09-DEC-13';
 BEGIN
 DBMS_OUTPUT.PUT_LINE(V_HIREDATE);
 END;
 /
 
 --BINARY_FLOAT, BINARY_DOUBLY TYPE 확인
 
 DECLARE 
    BF_VAR BINARY_FLOAT;
    BD_VAR BINARY_DOUBLE;
    
 BEGIN
    BF_VAR := 270/35;
    BD_VAR := 140/0.35;
    DBMS_OUTPUT.PUT_LINE('1: ' || BF_VAR);
    DBMS_OUTPUT.PUT_LINE('2: ' || BD_VAR);
 END;
 /
 
  DECLARE 
   BF_VAR NUMBER;
   BD_VAR NUMBER;

 BEGIN
    BF_VAR := 270/35;
    BD_VAR := 140/0.35;
    DBMS_OUTPUT.PUT_LINE('1: ' || BF_VAR);
    DBMS_OUTPUT.PUT_LINE('2: ' || BD_VAR);
 END;
 /
 
 -- TYPE 사용 
 
 DECLARE 
    V_SAL EMP01.SALARY%TYPE;
    
 BEGIN 
    SELECT SALARY INTO V_SAL
    FROM EMP01
    WHERE EMPLOYEE_ID = 131;
   
   DBMS_OUTPUT.PUT_LINE(V_SAL);
   END;
   /
 
 VARIABLE B_SAL NUMBER;
 BEGIN 
 SELECT SALARY INTO :B_SAL 
 FROM EMP01
 WHERE EMPLOYEE_ID = 131;
 END;
 /
 
PRINT B_SAL
 
 
--실행문 작성 

DECLARE 
    V_DESC_SIZE INTEGER(5);
    V_PROD_DESCRIPTION VARCHAR2(80) := 'YOU ARE AWESOME';
BEGIN 
    V_DESC_SIZE := LENGTH(V_PROD_DESCRIPTION);
    DBMS_OUTPUT.PUT_LINE(V_DESC_SIZE);
END;
/
 

DECLARE 
    V_DESC_SIZE INTEGER(5);
    V_PROD_DESCRIPTION VARCHAR2(80) := 'YOU ARE AWESOME';
BEGIN 
    V_DESC_SIZE := MAX(V_PROD_DESCRIPTION);
    DBMS_OUTPUT.PUT_LINE(V_DESC_SIZE);
END;
/

DECLARE 
    V_SUM NUMBER;
BEGIN 
    SELECT SUM(SALARY) INTO V_SUM
    FROM EMP01;
    DBMS_OUTPUT.PUT_LINE(V_SUM);
END;
/

--PL/SQL에서의 시퀀스 사용 
--시퀀스란 유일한 값을 생성해주는 오라클 객체.

CREATE SEQUENCE EMPNO_SEQ START WITH 1000;

DECLARE 
    V_NUM NUMBER := EMPNO_SEQ.NEXTVAL;
BEGIN 
    DBMS_OUTPUT.PUT_LINE(V_NUM);
END;
/

DECLARE 
    V_NUM NUMBER;
BEGIN 
    SELECT EMPNO_SEQ.NEXTVAL INTO V_NUM
    FROM DUAL;
    DBMS_OUTPUT.PUT_LINE(V_NUM);
END;
/

--중첩 블록에서 변수의 범위 

DECLARE 
    V_OUTER VARCHAR2(100) := 'OUTER';
    BEGIN
     DBMS_OUTPUT.PUT_LINE('OUTER: ' || V_OUTER);
     DECLARE 
     V_OUTER VARCHAR2(60) := 'HELLO';
     V_INNER VARCHAR2(100) := 'INNER VARIABLE';
     BEGIN 
        DBMS_OUTPUT.PUT_LINE('OUTER: ' || V_OUTER);
        DBMS_OUTPUT.PUT_LINE('INNER: ' || V_INNER);
     END;
    DBMS_OUTPUT.PUT_LINE('OUTER: ' || V_OUTER);
END;
/

BEGIN <<outer>>
DECLARE 
    V_FATHER_NAME VARCHAR2(20):= 'LOUIS';
    V_DOF DATE := '20-04-1972';
    BEGIN 
    DECLARE 
        V_CHILD_NAME VARCHAR2(20) := 'HENRY';
        V_DOF DATE := '12-08-1988';
    BEGIN 
        DBMS_OUTPUT.PUT_LINE('DAD''S NAME' || V_FATHER_NAME);
        DBMS_OUTPUT.PUT_LINE('DOF ' || outer.V_DOF);
        DBMS_OUTPUT.PUT_LINE('CHILD''S NAME' || V_CHILD_NAME);
        DBMS_OUTPUT.PUT_LINE('DOF ' || V_DOF);
    END;
END;
END outer;
/

--PL/SQL 프로그램에서 SQL문과 상호 작용
--DML(INSERT, UPDATE, DELETE)문 
BEGIN 
    INSERT INTO EMP01(EMPLOYEE_ID, LAST_NAME,EMAIL,HIRE_DATE, JOB_ID)
    VALUES (1234,'JANG','SDF','01-09-82','IT_PROG');
END;
/

SELECT * FROM EMP01
WHERE EMPLOYEE_ID = 1234;

DESC EMP01;

BEGIN 
    UPDATE EMP01
    SET SALARY = 4000
    WHERE EMPLOYEE_ID = 1234;
 END;
 /
 
 BEGIN
    DELETE EMP01
    WHERE EMPLOYEE_ID = 1234;
 END;
 /
 
 SELECT * FROM EMP01;
 BEGIN
    UPDATE EMP01
    SET SALARY = 4000
    WHERE EMPLOYEE_ID = 177;
    
    UPDATE EMP01
    SET SALARY = 3500
    WHERE EMPLOYEE_ID = 176;
END;
/
 
SELECT * FROM EMP01
WHERE EMPLOYEE_ID IN (176,177);

ROLLBACK;

SET SERVEROUTPUT ON;

BEGIN 
    UPDATE EMP01
    SET SALARY = 4000
    WHERE EMPLOYEE_ID = 176;
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT); --SQL%ROWCOUNT는 가장 최근에 수행된
                                        -- SQL문에 의해 영향을 받은 행의 갯수

    DELETE EMP01
    WHERE DEPARTMENT_ID = 10;
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT); 
END;
/

    --SELECT 문
    
    INSERT INTO EMP01
    (EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE,JOB_ID)
    VALUES(999,'CHANG','POBO','10/12/02','IT_PROG');
    
    SELECT * FROM EMP01;
    DESC EMP01;
    DECLARE 
        V_ENAME VARCHAR2(10);
        V_SAL EMP01.SALARY%TYPE;
    BEGIN 
        SELECT FIRST_NAME, SALARY 
        INTO V_ENAME, V_SAL 
        FROM EMP01
        WHERE EMPLOYEE_ID = 999;
        
        DBMS_OUTPUT.PUT_LINE(V_ENAME || '+' || V_SAL);
    END;

 -- DDL, DCL문
 
    BEGIN 
        DROP TABLE EMP01;
    END;
    /
    
    
--제어 구조 작성 
--IF문

    DECLARE
        V_MYAGE NUMBER;
    BEGIN
        IF V_MYAGE < 11 THEN
            DBMS_OUTPUT.PUT_LINE('CHILD');
        ELSE
            DBMS_OUTPUT.PUT_LINE('NO CHILD');
        END IF;
    END;
    /
    
--CASE 표현식 
    DECLARE 
        V_GRADE VARCHAR2(10) := UPPER('&GRADE');
        V_APP VARCHAR2(20);
    BEGIN
        V_APP := CASE V_GRADE WHEN 'A' THEN 'EX'
                              WHEN 'B' THEN 'VG'
                              WHEN 'C' THEN 'G'
                    ELSE 'NO G'
                    END;
        DBMS_OUTPUT.PUT_LINE(V_GRADE || '~' || V_APP);

    END;
    /
 
 --LOOP문
 
 DECLARE 
    V_COUNT NUMBER(2) := 1;
    
 BEGIN 
    LOOP 
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(V_COUNT));
        V_COUNT := V_COUNT + 2;
        EXIT WHEN V_COUNT = 7;
    END LOOP;
    END;
    /
    
--NESTED LOOPS
    
 DECLARE 
    X NUMBER := 3;
    Y NUMBER;
 BEGIN 
    <<OUTER_LOOP>>
    LOOP 
     Y := 1;
     EXIT WHEN X > 4;
     <<INNER_LOOP>>
    LOOP
    DBMS_OUTPUT.PUT_LINE( X || '*' || Y || '=' || X*Y );
    Y := Y + 1;
    EXIT WHEN Y>5;
    END LOOP INNER_LOOP;
    X := X+1;
    END LOOP OUTER_LOOP;
    END;
    /
    
    --CONTINUE문
    
    DECLARE 
    V_TOTAL SIMPLE_INTEGER := 0;
    
    BEGIN
        FOR i IN 1..5 LOOP
        V_TOTAL := V_TOTAL + i;
        DBMS_OUTPUT.PUT_LINE(V_TOTAL);
        
        CONTINUE WHEN i > 3;
        v_total := v_total +i;
        DBMS_OUTPUT.PUT_LINE('out' || v_total);
        END LOOP;
    END;
    /
    
    --조합 데이터 유형
    --PL/SQL RECORD 
    DESC EMP01;    
    DECLARE 
        TYPE EMP_REC_TYP IS RECORD
        (ENAME VARCHAR2(10),
         SAL EMP01.SALARY%TYPE,
         JOB EMP01.JOB_ID%TYPE := 'NONE');
        
        EMP_REC EMP_REC_TYP;
    
    BEGIN
        SELECT FIRST_NAME, SALARY, JOB_ID INTO EMP_REC
        FROM EMP01
        WHERE EMPLOYEE_ID = 177;
    
    END;
    /
    
    DECLARE 
        EMP_REC EMP01%ROWTYPE;
    BEGIN
        SELECT * INTO EMP_REC
        FROM EMP01
        WHERE EMPLOYEE_ID = 176;
    END;
    /
    
    --RECORD TYPE 사용
    
    CREATE TABLE COPY_EMP
    AS
    SELECT * FROM EMP01
    WHERE DEPARTMENT_ID = 30;
    
    DROP TABLE COPY_EMP;
    
    SELECT * FROM COPY_EMP;

    DECLARE 
        EMP_REC EMP01%ROWTYPE;
    BEGIN 
        SELECT * INTO EMP_REC
        FROM EMP01
        WHERE EMPLOYEE_ID = 177;
    
        INSERT INTO COPY_EMP
        VALUES EMP_REC;
        
        SELECT * INTO EMP_REC
        FROM EMP01
        WHERE EMPLOYEE_ID = 178;
        
         INSERT INTO COPY_EMP
        VALUES EMP_REC;
        
        END;
        /
        
        SELECT * FROM COPY_EMP;
        
        --PL/SQL COLLECTION (INDEX BY TABLE) 사용
        
        DECLARE 
            TYPE TAB_TYP IS TABLE OF VARCHAR2(10)
            INDEX BY PLS_INTEGER;
            
            TAB TAB_TYP;
            
        BEGIN
            TAB(100) := 'AAA';
            TAB(10) := 'BBB';
            TAB(50) := 'CCC';
            TAB(30) := 'DDD';
            
            FOR i IN 1..TAB.LAST LOOP
                IF TAB.EXISTS(i) THEN 
                    DBMS_OUTPUT.PUT_LINE(i || '-'||TAB(i));
                END IF;
            END LOOP;
        END;
        /
        
        DECLARE 
            TYPE ENAME_TAB_TYP IS TABLE OF EMP01.FIRST_NAME%TYPE
            INDEX BY PLS_INTEGER;
        
            ENAME_TAB ENAME_TAB_TYP;
        BEGIN
            SELECT FIRST_NAME BULK COLLECT INTO ENAME_TAB
            FROM EMP01
            WHERE DEPARTMENT_ID = 30;
            
            FOR i IN ENAME_TAB.FIRST .. ENAME_TAB.LAST 
            LOOP 
                IF ENAME_TAB.EXISTS(i) THEN 
                    DBMS_OUTPUT.PUT_LINE(i || '-' || ename_tab(i));
            END IF;
            END LOOP;
        END;
        /
        
    -- PL/SQL COLLECTION(NESTED TABLE) 사용
        DECLARE 
            TYPE TAB_TYP IS TABLE OF VARCHAR2(10);
            
            TAB TAB_TYP := TAB_TYP('AAA','BBB','CCC');
        
        BEGIN
            FOR i IN TAB.FIRST .. TAB.LAST 
            LOOP
                IF TAB.EXISTS(i) THEN
                     DBMS_OUTPUT.PUT_LINE(i || '-' || TAB(i));
                END IF;
            END LOOP;
        END;
        /
        
    --P28부터 시작
        

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 begin
        dbms_output.put_line(v_hiredate);
        dbms_output.put_line(v_deptno);
        dbms_output.put_line(v_location);
        dbms_output.put_line(c_comm);
end;
/
        



















