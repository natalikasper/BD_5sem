--список всех табличных пространств
SELECT tablespace_name, contents FROM DBA_TABLESPACES;

--создать табл.пр-во
CREATE TABLESPACE KNV_QDATA
  DATAFILE 'D:\БГТУ\3 курс\5 семестр\БД\Лабораторные работы\5\KNV_QDATA.dbf'
  SIZE 10 M
  OFFLINE;
  
ALTER TABLESPACE KNV_QDATA ONLINE;

alter session set "_ORACLE_SCRIPT"=true;

create role myrole;
commit;

grant create session,
      create table, 
      create view, 
      create procedure,
      drop any table,
      drop any view,
      drop any procedure to myrole;
      
grant create session to myrole;
commit;

create profile myprofile limit
    password_life_time 180      --кол-во дней жизни пароля
    sessions_per_user 3         --кол-во сессий для юзера
    failed_login_attempts 7     --кол-во попыток ввода
    password_lock_time 1        --кол-во дней блока после ошибок
    password_reuse_time 10      --через скок дней можно повторить пароль
    password_grace_time default --кол-во дней предупрежд.о смене пароля
    connect_time 180            --время соед (мин)
    idle_time 30 ;              --кол-во мин простоя 

drop user user1;

create user user1 identified by 1111
default tablespace KNV_QDATA quota unlimited on KNV_QDATA
profile myprofile
account unlock;

ALTER USER user1
QUOTA 2 m ON KNV_QDATA;

grant myrole to user1;

--lr5
CREATE TABLE Example_table(
id number(15) PRIMARY KEY,
name varchar2(10));

INSERT INTO Example_table values(1, 'BAZ');
INSERT INTO Example_table values(2, 'IBS');
INSERT INTO Example_table values(3, 'SRG');

select * from example_table;


--список сегментов табл.пр-ва KNVQDATA
--knv
SELECT * FROM DBA_SEGMENTS WHERE tablespace_name='KNV_QDATA';


--удалить таблицу  + список сегментов + Запрос к представлению
drop table Example_table;
--knv
SELECT * FROM DBA_SEGMENTS WHERE tablespace_name='KNV_QDATA';
--lr5
select * from user_recyclebin;


--восстановить удал.табл
--lr5
FLASHBACK TABLE  Example_table TO BEFORE DROP;

--выполнить скрипт, заполняющий таблицу 10000 строк
--lr5
BEGIN
  FOR k IN 4..10004
  LOOP
    INSERT INTO Example_table VALUES(k, 'A');
  END LOOP;
  COMMIT;
END;

select * from Example_table;


--опред.сколько в сегменте таблицы экстентов, из размер + перечень всех экстентов
--knv
SELECT * FROM DBA_EXTENTS WHERE TABLESPACE_NAME='KNV_QDATA';


--удалить KNV_QDATA и его файл
--knv
DROP TABLESPACE KNV_QDATA INCLUDING CONTENTS AND DATAFILES;

--получить перечень груп журналов повтора
--knv
SELECT group#, sequence#, bytes, members, status, first_change# FROM V$LOG;

--перечень файлов журнала повтора инстанса
--knv
SELECT * FROM V$LOGFILE;
select *from V$LOG;


--12. создать группу журналов повтора с 3 файламя журнала
ALTER DATABASE ADD LOGFILE GROUP 4 'D:\app\ora_natasha\oradata\orcl\REDO04.LOG' 
SIZE 50 m BLOCKSIZE 512;
ALTER DATABASE ADD LOGFILE MEMBER 'D:\app\ora_natasha\oradata\orcl\REDO041.LOG'  TO GROUP 4;
ALTER DATABASE ADD LOGFILE MEMBER 'D:\app\ora_natasha\oradata\orcl\REDO042.LOG'  TO GROUP 4;

SELECT group#, sequence#, bytes, members, status, first_change# FROM V$LOG;


--11. переключение журналов 
ALTER SYSTEM SWITCH LOGFILE;
SELECT group#, sequence#, bytes, members, status, first_change# FROM V$LOG;


--13. удалить созданную группу журналов повтора
ALTER DATABASE DROP LOGFILE MEMBER 'D:\app\ora_natasha\oradata\orcl\REDO042.LOG' ;
ALTER DATABASE DROP LOGFILE MEMBER 'D:\app\ora_natasha\oradata\orcl\REDO041.LOG' ;

ALTER DATABASE DROP LOGFILE GROUP 4;
SELECT group#, sequence#, bytes, members, status, first_change# FROM V$LOG;


--14. убедитесь, что архимирование не выполняется (stopped)
SELECT NAME, LOG_MODE FROM V$DATABASE;
SELECT INSTANCE_NAME, ARCHIVER, ACTIVE_STATE FROM V$INSTANCE;


--включить архивирование
--sql plus
--connect /as sysdba
--shutdown immediate;
--startup mount;
--alter database archivelog;
--alter database open;

--
SELECT NAME, LOG_MODE FROM V$DATABASE;
SELECT INSTANCE_NAME, ARCHIVER, ACTIVE_STATE FROM V$INSTANCE;
select * from V$LOG;

--созд архивный файл 
SELECT * FROM V$ARCHIVED_LOG;
SELECT NAME, FIRST_CHANGE#, NEXT_CHANGE# FROM V$ARCHIVED_LOG;

ALTER SYSTEM SET LOG_ARCHIVE_DEST_1 ='LOCATION=D:\app\ora_natasha\oradata\orcl\archive'

ALTER SYSTEM SWITCH LOGFILE;
SELECT * FROM V$ARCHIVED_LOG;

--откл архивирование
--shutdown immediate;
--startup mount;
--alter database noarchivelog;
--select name, log_mode from v$database;
--alter database open;


--получить список упр-щих файлов
select name from v$controlfile;

--получите содержимое упр-щего файла
show parameter control;

--опр место файла параметров инстанса
ALTER DATABASE BACKUP CONTROLFILE TO TRACE;
show parameter spfile ;

--созд PFILE, исслед содержимео
--CREATE PFILE='user_pf.ora' FROM SPFILE;
--показать в папке D:\app\ora_natasha\product\12.1.0\dbhome_1\database

--опр место файла паролей, содержимое
SELECT * FROM V$PWFILE_USERS;
SELECT * FROM V$DIAG_INFO;
show parameter remote_login_passwordfile;


