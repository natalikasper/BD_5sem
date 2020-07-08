--1.создать таблицу, имеющую несколько атрибутов, один из которых - первичный ключ
grant create  trigger to KNV_USER;
ALTER SESSION SET nls_date_format='dd-mm-yyyy hh24:mi:ss';

CREATE TABLE tabl(a int primary key,b varchar(30));

--2.заполнить таблицу строками(10шт)11:22 17.02.2020
DECLARE 
    i int :=0;
BEGIN
    WHILE i<10
LOOP
    INSERT INTO tabl(a,b)
    values (i,'a');
    i:= i+1;
END LOOP;
END;

SELECT * FROM tabl;

--3.создать before-“риггер уровн€ оператора на событи€ insert/delete/update
--4.они должны выводить на серверную консоль сообщ со своим именем
--вид процедуры, который сраб.по событию
CREATE OR REPLACE TRIGGER Insert_trigger_before
before insert on tabl
BEGIN
    dbms_output.put_line('Insert trigger before activate');
END;

insert into tabl values (16, 'D');

CREATE OR REPLACE TRIGGER Delete_trigger_before
before delete on tabl
BEGIN
    dbms_output.put_line('Delete trigger before  activate');
END;

delete from tabl where b='D';

CREATE OR REPLACE TRIGGER Update_trigger_before
before update on tabl
BEGIN
    dbms_output.put_line('Update trigger before  activate');
END;

--5.созлать before-триггер уровн€ строки на событи€ insert/delete/update
CREATE OR REPLACE TRIGGER Insert_for_each_trigger_before
before insert on tabl
for each row
BEGIN
    dbms_output.put_line('Insert_for_each_trigger before activate');
END;

CREATE OR REPLACE TRIGGER Update_for_each_trigger_before
before update on tabl
for each row
BEGIN
    dbms_output.put_line('Update_for_each_trigger before activate');
END;

CREATE OR REPLACE TRIGGER Delete_for_each_trigger_before
before delete on tabl
for each row
BEGIN
    dbms_output.put_line('Delete_for_each_trigger before activate');
END;

--6.применить предикаты inserting, updating, deleting
CREATE OR REPLACE TRIGGER Trigger_ing
after insert or update  or delete on tabl
BEGIN
IF INSERTING then
    dbms_output.put_line('Inserting after');
ELSIF UPDATING then
    dbms_output.put_line('Updating after');
ELSIF DELETING then
    dbms_output.put_line('Deleting after');
END IF;
END;

insert into tabl values (16, 'D');
delete from tabl where b='D';

--7.after-триггер уровн€ оператора на событи€
CREATE OR REPLACE TRIGGER Insert_trigger
after insert on tabl
BEGIN
    dbms_output.put_line('Insert trigger after activate');
END;

insert into tabl values (10, 'A');
select * from tabl;

-----------------
CREATE OR REPLACE TRIGGER Delete_trigger
after delete on tabl
BEGIN
    dbms_output.put_line('Delete trigger after  activate');
END;

insert into tabl values (13, 'B');
insert into tabl values (14, 'B');
delete from tabl where b='B';

-----------------
CREATE OR REPLACE TRIGGER Update_trigger
after update on tabl
BEGIN
    dbms_output.put_line('Update trigger after  activate');
END;

--8.after-триггер уровн€ строки на событи€
CREATE OR REPLACE TRIGGER Insert_for_each_trigger
after insert on tabl
for each row
BEGIN
    dbms_output.put_line('Insert_for_each_trigger after activate');
END;

CREATE OR REPLACE TRIGGER Update_for_each_trigger
after update on tabl
for each row
BEGIN
    dbms_output.put_line('Update_for_each_trigger after activate');
END;

update tabl set b = 'C';
select * from tabl;

CREATE OR REPLACE TRIGGER Delete_for_each_trigger
after delete on tabl
for each row
BEGIN
    dbms_output.put_line('Delete_for_each_trigger after activate');
END;

--9.создать таблицу, с 3 пол€ми (дата, тип операции, им€ триггера, дата)
create table AUDITS( 
    OperationDate date, 
    OperationType varchar2(40), 
    TriggerName varchar2(40), 
    Data varchar2(40) );

--10.изменить триггеры таким образом, чотбы они рег.все оп-ции в табл.аудит
CREATE OR REPLACE TRIGGER AUDITS_trigger_before
before insert or update or delete on tabl
  BEGIN
  if inserting then
    dbms_output.put_line('before_insert_AUDITS');
    INSERT INTO AUDITS(OperationDate,OperationType , TriggerName,Data  )
    SELECT sysdate,'Insert', 'AUDITS_trigger_before',concat(tabl.a ,tabl.b)
    FROM tabl;
  elsif updating then
    dbms_output.put_line('before_update_AUDITS');
    INSERT INTO AUDITS(OperationDate,OperationType , TriggerName,Data  )
    SELECT sysdate,'Update', 'AUDITS_trigger_before',concat(tabl.a ,tabl.b)
    FROM tabl;
  elsif deleting then
    dbms_output.put_line('before_delete_AUDITS');
    INSERT INTO AUDITS(OperationDate,OperationType , TriggerName, Data )
    SELECT sysdate,'Delete', 'AUDITS_trigger_before',concat(a ,b)
    FROM tabl;
  END if;
END;

select * from audits;
delete from audits where triggername='insert';
insert into audits values('11.11.2019', 'insert', 'insert', 'vv');

CREATE OR REPLACE TRIGGER AUDITS_trigger_after
  after insert or update  or delete on tabl
  BEGIN
  if inserting then
    dbms_output.put_line('after_insert_AUDITS');
    INSERT INTO AUDITS(OperationDate,OperationType , TriggerName,Data  )
    SELECT sysdate,'Insert', 'AUDITS_trigger_after',concat(tabl.a ,tabl.b)
    FROM tabl;
  elsif updating then
    dbms_output.put_line('after_update_AUDITS');
    INSERT INTO AUDITS(OperationDate,OperationType , TriggerName,Data  )
    SELECT sysdate,'Update', 'AUDITS_trigger_after',concat(tabl.a ,tabl.b)
    FROM tabl;
  elsif deleting then
    dbms_output.put_line('after_delete_AUDITS');
    INSERT INTO AUDITS(OperationDate,OperationType , TriggerName, Data )
    SELECT sysdate,'Delete', 'AUDITS_trigger_after',concat(a ,b)
    FROM tabl;
    END if;
END;

--12.удалите исходную таблицу. объ€сните результат
--добавьте триггер, запрещающий удаление исх.таблц
--13.удалите таблцу аудит. изменить триггеры
drop table tabl;
FLASHBACK table tabl TO BEFORE DROP;
drop table audits;
FLASHBACK table audits TO BEFORE DROP;

CREATE OR REPLACE TRIGGER no_drop_trg
  BEFORE DROP ON KNV_USER.SCHEMA
  DECLARE
  v_msg VARCHAR2(1000) :=
  'No drop allowed on ' ||
  DICTIONARY_OBJ_OWNER || '.' ||
  DICTIONARY_OBJ_NAME || ' from ' ||
  LOGIN_USER;
BEGIN
  IF DICTIONARY_OBJ_OWNER = 'KNV_USER' AND
  DICTIONARY_OBJ_NAME = 'TABL' AND
  DICTIONARY_OBJ_TYPE = 'TABLE'
THEN
  RAISE_APPLICATION_ERROR ( -20905, v_msg);
  END IF;
END;

select * from all_objects where object_name = 'TABL';


select object_name, status from user_objects where object_type = 'TRIGGER';

--14.создать представление над исх.таблицей
create view tablview as SELECT * FROM tabl;
SELECT * FROM tabl;
SELECT * FROM tablview;

--разраб.Instead of insert триггер, кот.должен добавл€ть строку в таблицу
CREATE OR REPLACE TRIGGER tabl_trigg
instead of insert or update or delete on tablview
BEGIN
if inserting then
  dbms_output.put_line('insert');
  insert into tabl VALUES (5, 'F');
elsif updating then
    dbms_output.put_line('update');
elsif deleting then
dbms_output.put_line('delete');
END if;
END tabl_trigg;

select * from tablview;

INSERT INTO tablview values(2,'c');