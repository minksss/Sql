--DDL
--char(2000)byte����, varchar2(4000)byte����
create table t1(
c1 char(5), --�������� 5�ڸ�
c2 varchar(5) --�ִ� 5�ڸ��̴�
);

insert into t1 values('123','123');
insert into t1 values ('123  ','123  ');
--insert into t1 values ('123456','123456'); ����
select '*'||c1||'*','*'||c2||'*' from t1;

--�ڵ����� 5�ڸ� ...trim()
select * from t1
where c1 = '123';

--�� �״�� ���
select * from t1
where c2 = '123';
