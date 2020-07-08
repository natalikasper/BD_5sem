-- L9

--1.разработать простейший анонимный блок, не сод-щий операторов
--не им.заголовка
begin
  null;
end;  

--2.разраб.АБ, выводящий "Hello World!"
BEGIN
  dbms_output.put_line('Hello world');
END;

--3.продемонстрир.работу исключ и встр.ф-ций sqlerrm, sqlcode
declare
  x number(3) := 3;
  y number(3) := 0;
  z number (10,2);
begin
  z:=x/y;
exception
  when others
    then dbms_output.put_line ('code = ' || sqlcode || '; error = ' || sqlerrm);
  end;
  
--4.разработать вложенный блок + исключения во вложенных блоках
declare
  x number(3) := 3;
  y number(3) := 0;
  z number (10,2);
begin
  dbms_output.put_line('x = ' || x || ', y = ' || y);
  begin
    z:=x/y;
    exception
      when others
      then dbms_output.put_line ('code = ' || sqlcode || '; error = ' || sqlerrm);
  end;
  dbms_output.put_line('z = ' || z);
end;

--5.выяснить какие типы предупр.компил.поддерж.в дан.момент
--show parameter plsql_warnings;
--select name, value from v$parameter where name = 'plsql_warnings';
--alter system set plsql_warnings = 'ENABLE:INFORMATIONAL';
select dbms_warning.get_warning_setting_string from dual;

--6.скрипт для просмотра спецсимволов pl/sql
select keyword from sys.v_$reserved_words where length=1 and keyword!='A';

--7.скрипт для просмотра всех ключевых слов pl/sql
select keyword from SYS.v_$reserved_words where length > 1 and keyword != 'A' order by keyword;
select count(keyword) from SYS.v_$reserved_words where length > 1 and keyword != 'A' order by keyword;

--8.скрипт для просмотра всех пар-ров oracle server, связ.с pl/sql
select name, value from v$parameter where name like 'plsql%';

--9.АБ, кот.демонстрир.
declare
--объявление и инициализ.целых number-пер-ных
  a NUMBER:=11;
  b NUMBER:=50;
begin
  dbms_output.put_line('целые числа:');
  dbms_output.put_line('a = ' || a);
  dbms_output.put_line('b = ' || b);
  --арифм.д-вия над 2 целыми number-пер-ными, включая деление с остатком
  dbms_output.put_line('арифметические операции с челыми числами:');
  dbms_output.put_line('11 + 50 = ' || (a+b));
  dbms_output.put_line('50 - 11 = ' || (b-a));
  dbms_output.put_line('50 * 11 = ' || (b*a));
  dbms_output.put_line('MOD(50,11) = ' || MOD(b,a));
end;

--объявл.и иниц.number-пер-ных с фикс.точкой
declare
  c number(5,3) := 24.457;
  pi number (9,8) := 3.14159265;
begin
  dbms_output.put_line('числа с фиксированной точкой:');
  dbms_output.put_line('c = ' || c);
  dbms_output.put_line('pi = ' || pi);
end;

--объявление и иниц.пер-ных с фикс.точкой и отриц.масштабом (округление)
declare
  d number(7, -2) := 1254567.89;
begin
  dbms_output.put_line('числа с фикс.точкой и отриц.масштабом(округление):');
  dbms_output.put_line('1234567.89(7,-2) = ' || d);
  dbms_output.put_line('round(35.58) = ' || ROUND(35.58));
end;

--объявление и иниц.BINARY_FLOAT-пер-ной
declare
  f1 binary_float:= 123456789.12345678911;
  f2 binary_float:= 123456.12345678911;
begin
  dbms_output.put_line('BINARY_FLOAT переменные');
  dbms_output.put_line('f1 = ' || f1);
  dbms_output.put_line('f2 = ' || f2);
end;

--обявление и иниц.BINARY_DOUBLE пер-ной
declare
  f1 binary_double:= 123456789.12345678911;
  f2 binary_double:= 123456.12345678911;
begin
  dbms_output.put_line('BINARY_DOUBLE переменные');
  dbms_output.put_line('f1 = ' || f1);
  dbms_output.put_line('f2 = ' || f2);
end;

--объявл.и иниц.пер-ных с точкой и примен.символа E(степ 10)
declare
  e1 number := 0.95e-7;
  e2 number := 0.4e-2;
begin
  dbms_output.put_line('переменная с точкой и применением символа E');
  dbms_output.put_line('0.95e-7 = ' || e1);
  dbms_output.put_line('0.4e-2 = ' || e2);
end;

--обявл.и иницилиз. BOOLEAN пер-ных
declare
  b1 boolean := true;
  b2 boolean := false;
begin
  if b1     then dbms_output.put_line('b1 = ' || 'true'); end if;
  if not b1 then dbms_output.put_line ('b1 = ' || 'false'); end if;
  if b2     then dbms_output.put_line('b2 = ' || 'true'); end if;
  if not b2 then dbms_output.put_line ('b2 = ' || 'false'); end if; 
end;

--10.АБ, кот.содерж.объявление констант (varchar2, char, number)
--продемонстр.возм.оп-ции константами
declare
  c1 constant number(5):= 5;
  c2 constant varchar2 (15):= 'Hello World';
  c3 constant char (5) := 'hello';
begin
  dbms_output.put_line('constatnt number: ' || c1);
  dbms_output.put_line('constant varchar2: ' || c2);
  dbms_output.put_line('constant char: ' || c3);
end;

--11.АБ, сод-щий объявление с опцией %TYPE и %rowtype
declare
  b char(5) := 'hello';
  g b%TYPE := 'world';    --на основе др пер-ной/строки в таблице
  q DUAL%ROWTYPE;         --стр-ра записи на основе таблицы/курсора
  x DUAL%ROWTYPE;
begin
  dbms_output.put_line('g = ' || g);
  SELECT 2*3 INTO q FROM DUAL;
  select 'a' into x from dual;
  dbms_output.put_line('q = ' || q.DUMMY); 
  dbms_output.put_line('x = ' || x.DUMMY);
end;

--12.АБ, кот.демонстр.все возм.конструкции оператора IF
declare
  n number:= 10;
begin
  dbms_output.put_line('оператор if');
  if 11 > n then dbms_output.put_line ('11 > ' || n);  end if;

  if 8 > n  then dbms_output.put_line ('8 > ' || n);  
            else dbms_output.put_line ('8 < ' || n); end if;
  
  if 12 > n  then dbms_output.put_line ('12 > ' || n);  
  elsif 12 = n then dbms_output.put_line ('12 = ' || n);   
            else dbms_output.put_line ('12 < ' || n); end if;
 end; 
 
 --13.АБ, демонстр.работу CASE
declare
  n number:= 17;
begin
  dbms_output.put_line('оператор case');
  case n
    when 1 then dbms_output.put_line ('1'); 
    when 2 then dbms_output.put_line ('2'); 
    when 3 then dbms_output.put_line ('3');
    else dbms_output.put_line ('else');
  end case;
  
  case
    when 8 > n  then dbms_output.put_line ('8 > ' || n);  
    when 8 = n  then dbms_output.put_line ('8 = ' || n);
    when 12 = n then dbms_output.put_line ('12 = ' || n);   
    when n between 13 and 20 then dbms_output.put_line ('13 <= ' || n || ' <= 20'); 
      else dbms_output.put_line ('else');
  end case;
 end;  
 
 --14.АБ, демонстр.работу LOOP
declare
  x number:= 0;
begin
  dbms_output.put_line('цикл loop');
  loop
    x := x + 1;
      dbms_output.put_line(x);
    exit when x >= 5;
  end loop;
end;
 
 --15.АБ, демонстр.работу WHILE
declare
  x number:= 5;
begin
  dbms_output.put_line('цикл while');
  while (x > 0)
  loop
    x := x - 1;
      dbms_output.put_line(x);
  end loop;
end;
 
 --16.АБ, демонстр.работу FOR
begin
  dbms_output.put_line('цикл for');
  for k in 1..5
  loop
      dbms_output.put_line(k);
  end loop;
end;