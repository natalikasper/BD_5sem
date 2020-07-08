--в созданный файл запишите скрипт, создающий табл.с именем XXX_t
create table XXX_t(x number(3) primary key, s varchar2 (50));

drop table XXX_t;

--INSERT (3 строки), + COMMIT
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

--select (по усл, агрег.ф-ции)
select x, s from xxx_t where x = 8 or s = 'bikes';
select sum (x * 100) from xxx_t;  --(100*8 + 100*7 + 100*3) = 1800
select avg (x) from xxx_t;        --(7+8+3)/3 = 18/3 = 6

--delete(1) + commit
delete from XXX_t where x = 3;
commit;

select * from xxx_t;

--создать табл xxx_t1, связ.отнош.внешн.ключа с табл.ххх_t
create table xxx_t1 (z number(3), b varchar2(50) primary key, foreign key (z) references xxx_t(x));
insert  into xxx_t1(z, b) values (7, 'moto');
 
select * from xxx_t1;

drop table xxx_t1;
--select (левое и правое соед)
--внутр-> все строки, кот.удовл.усл.
select x, s, z , b
    from xxx_t inner join xxx_t1 on x = z;
    
--левое-> все строки слева от ON и те из другой, где поля равны
select x, s, z , b
    from xxx_t left outer join xxx_t1 on x = z;

--правое внешн
select x, s, z , b
    from xxx_t right outer join xxx_t1 on x = z;
    
--полное внешн
select x, s, z , b
    from xxx_t full outer join xxx_t1 on x = z;
    
--drop  для 2х таблиц
drop table xxx_t1;
drop table xxx_t;