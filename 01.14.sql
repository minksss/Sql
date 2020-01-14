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







