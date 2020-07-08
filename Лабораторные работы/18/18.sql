CREATE TABLE ORDRS(
	ORDER_NUM INTEGER PRIMARY KEY,
	ORDER_DATE DATE,
	PRODUCT VARCHAR2(10),
	AMOUNT NUMBER,
    text CLOB,
    img BLOB,
    f_name VARCHAR2(30),
    i_name VARCHAR2(30) );

--update ordrs set text = upper(text);

select * from ordrs;

--1.txt
--ordrs.ctl
--cmd
--F:
--cd 5 семестр\БД\Лабораторные работы\18
--sqlldr KNV_USER/natasha CONTROL=ORDRS.ctl

--f5
select /*txt*/ * from ordrs;

--ctrl+enter
--export
select /*xml*/ * from ordrs;