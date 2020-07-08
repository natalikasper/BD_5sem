--� ��������� ���� �������� ������, ��������� ����.� ������ XXX_t
create table XXX_t(x number(3) primary key, s varchar2 (50));

drop table XXX_t;

--INSERT (3 ������), + COMMIT
insert into xxx_t (x, s) values  (3, 'years');
insert into xxx_t (x, s) values  (4, 'month');
insert into xxx_t (x, s) values  (5, 'days');
commit;

select * from xxx_t;

--UPDATE(2) + commit
update xxx_t set x = 8, s = 'cars' where x=5;
update xxx_t set x = 7, s = 'bikes' where x=4;
commit;

select * from xxx_t;

--select (�� ���, �����.�-���)
select x, s from xxx_t where x = 8 or s = 'bikes';
select sum (x * 100) from xxx_t;  --(100*8 + 100*7 + 100*3) = 1800
select avg (x) from xxx_t;        --(7+8+3)/3 = 18/3 = 6

--delete(1) + commit
delete from XXX_t where x = 3;
commit;

select * from xxx_t;

--������� ���� xxx_t1, ����.�����.�����.����� � ����.���_t
create table xxx_t1 (z number(3), b varchar2(50) primary key, foreign key (z) references xxx_t(x));
insert  into xxx_t1(z, b) values (7, 'moto');
 
select * from xxx_t1;

drop table xxx_t1;
--select (����� � ������ ����)
--�����-> ��� ������, ���.�����.���.
select x, s, z , b
    from xxx_t inner join xxx_t1 on x = z;
    
--�����-> ��� ������ ����� �� ON � �� �� ������, ��� ���� �����
select x, s, z , b
    from xxx_t left outer join xxx_t1 on x = z;

--������ �����
select x, s, z , b
    from xxx_t right outer join xxx_t1 on x = z;
    
--������ �����
select x, s, z , b
    from xxx_t full outer join xxx_t1 on x = z;
    
--drop  ��� 2� ������
drop table xxx_t1;
drop table xxx_t;