--�������.� ���.Developer + ������� �����������.�������
--LR4 -> PROP
CREATE TABLESPACE TS_KNV
DATAFILE 'D:\����\3 ����\5 �������\��\������������ ������\4\TS_KNV.dbf' 
size 7M
AUTOEXTEND ON NEXT 5M 
MAXSIZE 20M
LOGGING
ONLINE;
commit;

select TABLESPACE_NAME, BLOCK_SIZE, MAX_SIZE from sys.dba_tablespaces order by tablespace_name;

CREATE TEMPORARY TABLESPACE TS_KNV_TEMP_1
TEMPFILE 'D:\����\3 ����\5 �������\��\������������ ������\4\TS_KNV_TEMP1.dbf' size 5M
AUTOEXTEND ON NEXT 3M 
MAXSIZE 30M;
commit;

--alter session set "_ORACLE_SCRIPT"=true;
create role RL_KNV;
commit;

GRANT CREATE SESSION,
      CREATE TABLE,
      CREATE VIEW,
      CREATE PROCEDURE TO  RL_KNV;

create profile PF_KNV limit
password_life_time 180 -- ���-�� ���� ����� ������
sessions_per_user 3 -- ���-�� ������ ��� ������������
FAILED_LOGIN_ATTEMPTS 7 -- ���-�� ������� �����
PASSWORD_LOCK_TIME 1 -- ���-�� ���� ���������� ����� ������
PASSWORD_Reuse_time 10 -- ����� ������� ���� ����� ��������� ������
password_grace_time default -- ���-�� ���� �������������� � ����� ������
connect_time 180 -- ����� ����������
idle_time 30; -- �������
commit;

create user U1_KNV_PDB identified by 12345678
default tablespace TS_KNV quota unlimited on TS_KNV
profile PF_KNV
account unlock;
grant RL_KNV to U1_KNV_PDB;
commit;

--7
--lr4_2
create table KNV_table (x number (2), s varchar2(25));

insert into KNV_table values (4, 'Julia');
insert into KNV_table values (5, 'Sivak');
insert into KNV_table values (6, 'Cherniak');
commit;
select * from knv_table;

--8
--lr4
select * from ALL_USERS;  --��� ������������
select * from DBA_TABLESPACES;  --��� ���. ������
select * from DBA_DATA_FILES;   --������ ������ 
select * from DBA_TEMP_FILES;  --������ ������
select * from DBA_ROLES; --����
select GRANTEE, PRIVILEGE from DBA_SYS_PRIVS;  --��������
select * from DBA_PROFILES;  --������ ���.


--9
--������� cdb-������������
--���������
select username, status, schemaname, osuser, type from v$session where USERNAME is not null;
