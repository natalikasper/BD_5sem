--�����.������ ���� ���-��� PDB � ������ ORA12W
select name,open_mode from v$pdbs; 

--�������� �������� �����������
select INSTANCE_NAME from v$instance;

--�������� ��������.��������� + ������ � ������
select * from PRODUCT_COMPONENT_VERSION;

--������� ������.��������� (KNV_PDB)
--ORACLE DATABASE CONFIGURATION ASSISTANT (screenshot)

--�����.������ ���� ���-��� PDB � ������ ORA12W + ���� ���-��
select name,open_mode from v$pdbs;
