--knv_user
--natasha

GRANT CREATE SEQUENCE to KNV_USER;
GRANT SELECT ANY SEQUENCE to KNV_USER;
ALTER USER KNV_USER QUOTA UNLIMITED ON USERS;
GRANT CREATE CLUSTER to KNV_USER;
GRANT CREATE PUBLIC SYNONYM to KNV_USER;
GRANT CREATE MATERIALIZED VIEW TO KNV_USER;
GRANT DROP PUBLIC SYNONYM to KNV_USER;

--2. создать послед.со след.хар-ками + вывести несколько знач.посл-сти + текущее
--объект для генерации числ.послед-сти
drop sequence s1;

CREATE SEQUENCE S1
START WITH 1000       --начальное значение
INCREMENT BY 10       --приращение
NOCYCLE               --не циклическая
NOORDER               --хронология не гарантируется
NOCACHE               --не кешируется
nomaxvalue            --нет макс.знач
nominvalue;           --нет мин.знач.

SELECT S1.nextval FROM dual;
SELECT S1.CURRVAL  FROM DUAL;

--2.создать послед-сть со след.хар-ками + вывести все значения
--получить знач, выходящее за макс
drop sequence s2;

create sequence S2
start with 10
increment by 10
maxvalue 100
nocycle;

select s2.nextval from dual;
select s2.currval from dual;

alter SEQUENCE S2 increment by 90;
alter SEQUENCE  S2 increment by 10;

--3.создать послед-сть со след.хар-ками + получить значения
--попытаться получить значение меньше минимального значения
drop sequence s3;

create sequence s3
start with 10
increment by -10
minvalue -100
maxvalue 100
nocycle
order;

SELECT S3.nextval  FROM dual;
SELECT s3.CURRVAL  FROM DUAL;

alter SEQUENCE S3 increment by -90;
alter SEQUENCE  S3 increment by -10;

--5.создать послед-сть + продемонстрировать цикличность
drop sequence s4;

create sequence s4
start with 1
increment by 1
maxvalue 4
cycle
noorder
cache 2;

SELECT S4.nextval  FROM dual;
SELECT S4.CURRVAL  FROM DUAL;

--6.получить список всех посл-стей, владалец KNV_USER
select * from sys.all_sequences where sequence_owner = 'KNV_USER';
select * from sys.user_sequences;

--7.созд.таблицу с 4 столбцами типа number(20)
--кот.кешируется в keep
--с пом.insert добавить 7 строк
--вводимое значение генерится с пом.посл-стей
drop table t1;

CREATE TABLE T1(N1 NUMBER (20),
                N2 NUMBER (20),
                N3 NUMBER (20),
                N4 NUMBER (20));
alter table T1 cache storage (buffer_pool keep);

insert into t1(n1, n2, n3, n4) values (s1.currval, s2.currval, s3.currval, s4.currval);

select * from t1;

--8. создать кластер АВС, имеющий hash-тип(размер 200)
--2 поля (x(number(10)) и v(varchar2(12))
create cluster abc ( x number(10), v varchar2(12))
hashkeys 200;

drop cluster abc;

--9-11. создать таблицу А(XA (NUMBER (10)) и VA (VARCHAR2(12))), кот.принадл.кластеру
-- + 1 произвольный столбец
drop table c;

CREATE TABLE A(XA NUMBER (10),
               VA VARCHAR2(12), 
               NA NUMBER (20))
CLUSTER  ABC (XA,VA); 

CREATE TABLE B(XB NUMBER (10),
               VB VARCHAR2(12), 
               NB NUMBER (20))
CLUSTER  ABC (XB,VB); 

CREATE TABLE C(XC NUMBER (10),
               VC VARCHAR2(12), 
               NC NUMBER (20))
CLUSTER  ABC (XC,VC); 

--12. найти созд.табл и кластер в представл.словаря Oracle
--knv
select * from dba_tables where cluster_name = 'ABC';
select cluster_name, owner from dba_clusters;

--13-14.создать частный синоним для таблицы KNV_USER.C + применение
--создать публичный синоним для таблицы KNV_USER.В + применение
--L9
drop public synonym B1;

create synonym C1 for KNV_USER.C;
create public synonym B1 for KNV_USER.B;

select * from dba_synonyms where table_owner = 'KNV_USER';

--15.2 произв.табл А и В(с первичн и внешн ключом), заполнить д-ми
--создать представд v1, кот.осн.на select....for A inner join B
create table a1 (x number(11) primary key);
create table a2(y number(11), constraint fk_column foreign key (y) references a1(x));

insert into a1 values (1);
insert into a1 values (2);
insert into a1 values (3);
insert into a1 values (4);
insert into a1 values (5);
insert into a1 values (6);

insert into a2 values (1);
insert into a2 values (2);
insert into a2 values (3);
insert into a2 values (4);
insert into a2 values (5);

drop view KNV_VIEW1;
create view KNV_VIEW1 as select x,y from a1 inner join a2 on a1.x=a2.y;
select * from KNV_VIEW1;

--16.на осн.табл.А и В создать матер.представл MV, кот.имеет периодичность обновл 2 мин
drop materialized view mv;

create materialized view mv
build immediate
refresh complete 
start with sysdate
next sysdate + Interval '120' second
as select a1.x, a2.y from
  (select count(*) x from a1) a1,
  (select count(*) y from a2) a2;

select * from mv;