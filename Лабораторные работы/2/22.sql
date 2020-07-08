--табл.пр-во в сост offline
create tablespace KNV_QDATA6 OFFLINE
datafile 'D:\БГТУ\3 курс\5 семестр\БД\Лабораторные работы\2\KNV_QDATA5.txt'
size 10M reuse
autoextend on next 5M
maxsize 20M;

--перевести в сост.online
alter tablespace KNV_QDATA6 online;

--выделить польз.квоту 2м
ALTER USER KNVCORE1 QUOTA 2M ON KNV_QDATA6;

--создать таблицу и добавить в нее 3 строки.
CREATE TABLE t (c NUMBER);

INSERT INTO t(c) VALUES(3);
INSERT INTO t(c) VALUES(1);
INSERT INTO t(c) VALUES(2);

SELECT * FROM t;

--