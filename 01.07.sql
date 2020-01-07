--DDL
--char(2000)byte까지, varchar2(4000)byte까지
create table t1(
c1 char(5), --고정으로 5자리
c2 varchar(5) --최대 5자리이다
);

insert into t1 values('123','123');
insert into t1 values ('123  ','123  ');
--insert into t1 values ('123456','123456'); 오류
select '*'||c1||'*','*'||c2||'*' from t1;

--자동으로 5자리 ...trim()
select * from t1
where c1 = '123';

--값 그대로 사용
select * from t1
where c2 = '123';
