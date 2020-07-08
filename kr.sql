--variant 9

--создать пакет, в котором есть процедуры и функции:
create or replace package my_office as
  fordernum ORDERS.ORDER_NUM%type;
  N number;
  fage SALESREPS.AGE%type;
  
  function delete_order(fordernum ORDERS.ORDER_NUM%type) return number;
  procedure find_office (N number);
  function find_by_age (fage SALESREPS.AGE%type) return number;
  procedure find_by_time(N number);
end my_office;  

------------ТЕЛО ПАКЕТА---------------
create or replace package body my_office as  

--функция для удаления д-х о заказе.
function delete_order(fordernum ORDERS.ORDER_NUM%type)
  return number is order_row number:=0;
begin
  delete from ORDERS where fordernum = ORDERS.ORDER_NUM;
  select count(order_num) into order_row from ORDERS;
  return order_row;
exception
  when others
    then dbms_output.put_line (sqlerrm);
  return -1;  
end delete_order;

--прцоедура нахождения офисов, у которых есть заказы стоимость более N
procedure find_office (N number) is
  cursor mycurs is select CUST, AMOUNT from ORDERS
    where amount >= N;
    pcust ORDERS.CUST%type;
    pamount ORDERS.AMOUNT%type;
  begin
    open mycurs;
    loop
      dbms_output.put_line (pcust || ' ' || pamount);
      fetch mycurs into pcust, pamount;
      exit when mycurs%notfound;
    end loop;
    close mycurs;
    exception 
      when others
        then dbms_output.put_line(sqlerrm);
end find_office;

--function: найти сотрубников старше опред.возраста
function find_by_age (fage SALESREPS.AGE%type)
  return number is row_count number:=0;
begin
  select count(EMPL_NUM) into row_count
    from SALESREPS
      where AGE >= fage;
  return row_count;
exception
  when others
    then dbms_output.put_line (sqlerrm);
  return -1;
end find_by_age;

--procedure: товары, которые покупались реже всего
procedure find_by_time(N number) is
  cursor myc is select PRODUCT_ID, DESCRIPTION, QTY_ON_HAND from PRODUCTS
    where ROWNUM < N order by QTY_ON_HAND asc;
    pproduct_id PRODUCTS.PRODUCT_ID%type;
    pdesc PRODUCTS.DESCRIPTION%type;
    pcount PRODUCTS.QTY_ON_HAND%type;
  begin
    open myc;
    loop
      dbms_output.put_line (pproduct_id || ' ' || pdesc || ' ' || pcount);
      fetch myc into pproduct_id, pdesc, pcount;
      exit when myc%notfound;
    end loop;
    close myc;
  exception 
      when others
        then dbms_output.put_line(sqlerrm);    
end find_by_time;

end my_office;


----------АНОНИМНЫЙ БЛОК------------
select * from orders;
select count(*) from orders;

begin
  DBMS_OUTPUT.PUT_LINE('Задание 1');
  DBMS_OUTPUT.PUT_LINE(MY_OFFICE.DELETE_ORDER(112961));
  DBMS_OUTPUT.PUT_LINE('Задание 2');
  MY_OFFICE.FIND_OFFICE(1500);
  DBMS_OUTPUT.PUT_LINE('Задание 3');
  DBMS_OUTPUT.PUT_LINE(MY_OFFICE.FIND_BY_AGE(42));
  DBMS_OUTPUT.PUT_LINE('Задание 4');
  MY_OFFICE.FIND_BY_TIME(5);
end;


select * from offices;
select * from orders;
select * from customers;
select * from products;
select * from SALESREPS; 
