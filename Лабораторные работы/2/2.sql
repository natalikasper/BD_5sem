--������� ��������� ��-�� ��� ����.�-� � ���.���-��
create tablespace ts_KNV
datafile 'D:\����\3 ����\5 �������\��\������������ ������\2\ts_KNV.dbf'
size 7M
reuse autoextend on next 5M
maxsize 20M;

--����.����.��-�� ��� ����.�-� � ���.���-��
create temporary tablespace ts_KNV_TEMP
tempfile 'D:\����\3 ����\5 �������\��\������������ ������\2\ts_KNV_TEMP.dbf'
size 5M
reuse autoextend on next 3M
maxsize 30M;

--�����.��� ����.��-�� � ���.select-������� � �������
select tablespace_name, contents logging from SYS.DBA_TABLESPACES;

--������� ���� (���������� - ������.�� ����.� ��������; ���� ����, ���������, ��������� � �-���)
--alter session set "_ORACLE_SCRIPT"=true;
create role RL_KVNCORE;
commit;

grant create session,
      create table, 
      create view, 
      create procedure to RL_KVNCORE;
      
grant drop any table,
      drop any view,
      drop any procedure to RL_KVNCORE;

--� ���.������-������� ����� ���� � ������� � �� ����������
SELECT grantee, privilege FROM SYS.dba_sys_privs where grantee = 'RL_KVNCORE';

--�������� ������� ���-��� � ������� ��� �� ��
create profile PF_KNVCORE limit
    password_life_time 180      --���-�� ���� ����� ������
    sessions_per_user 3         --���-�� ������ ��� �����
    failed_login_attempts 7     --���-�� ������� �����
    password_lock_time 1        --���-�� ���� ����� ����� ������
    password_reuse_time 10      --����� ���� ���� ����� ��������� ������
    password_grace_time default --���-�� ���� ����������.� ����� ������
    connect_time 180            --����� ���� (���)
    idle_time 30 ;              --���-�� ��� ������� 
    
--select: ��� �������, ��� ���-�� ������ ������, ��� ���-�� ������� default
select profile from dba_profiles;
select * from dba_profiles where profile = 'PF_KNVCORE';
select * from dba_profiles where profile = 'DEFAULT';

--������� �����.� ��� ���-��:
/*XXXCORE*/
create user KNVCORE1 identified by 2110
default tablespace ts_KNV quota unlimited on ts_KNV
temporary tablespace ts_KNV_TEMP
profile PF_KNVCORE
account unlock
password expire;

grant RL_KVNCORE to KNVCORE1;
grant CREATE TABLESPACE, ALTER TABLESPACE to KNVCORE1;

drop user KNVCORE1 cascade;

--���� � oracle ����� sqlplus + ����� ������

