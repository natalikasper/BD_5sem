--����.��-�� � ���� offline
create tablespace KNV_QDATA6 OFFLINE
datafile 'D:\����\3 ����\5 �������\��\������������ ������\2\KNV_QDATA5.txt'
size 10M reuse
autoextend on next 5M
maxsize 20M;

--��������� � ����.online
alter tablespace KNV_QDATA6 online;

--�������� �����.����� 2�
ALTER USER KNVCORE1 QUOTA 2M ON KNV_QDATA6;

--������� ������� � �������� � ��� 3 ������.
CREATE TABLE t (c NUMBER);

INSERT INTO t(c) VALUES(3);
INSERT INTO t(c) VALUES(1);
INSERT INTO t(c) VALUES(2);

SELECT * FROM t;

--