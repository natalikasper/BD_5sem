--1. ������ ������ ������� ���������
select name, description from v$bgprocess order by 1;

--2.	���������� ������� ��������, ������� �������� � �������� � ��������� ������.
SELECT *FROM v$process ; 

--3.	����������, ������� ��������� DBWn �������� � ��������� ������.
show parameter db_writer_processes;

--4. �������� ������� ���������� � �����������.
SELECT * FROM V$INSTANCE;

--5.	���������� �������.
select * from V$SERVICES ;  

--6.	�������� ��������� ��� ��������� ���������� � �� ��������.
SELECT * FROM V$DISPATCHER;
show parameter DISPATCHERS;

--7.	�������� �������� ������� ���������� � ���������. (dedicated, shared). 
SELECT USERNAME,SERVER FROM V$SESSION;

--8.	����������������� � �������� ���������� ����� LISTENER.ORA. 
--D:\app\ora_natasha\product\12.1.0\dbhome_1\NETWORK\ADMIN

--9-10.	��������� ������� lsnrctl � �������� �� �������� �������. 
--�������� ������ ����� ��������, ������������� ��������� LISTENER. 
--lsnrctl status, start, stop

