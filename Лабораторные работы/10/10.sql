-- L9

--1.����������� ���������� ��������� ����, �� ���-��� ����������
--�� ��.���������
begin
  null;
end;  

--2.������.��, ��������� "Hello World!"
BEGIN
  dbms_output.put_line('Hello world');
END;

--3.�������������.������ ������ � ����.�-��� sqlerrm, sqlcode
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
  
--4.����������� ��������� ���� + ���������� �� ��������� ������
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

--5.�������� ����� ���� �������.������.�������.� ���.������
--show parameter plsql_warnings;
--select name, value from v$parameter where name = 'plsql_warnings';
--alter system set plsql_warnings = 'ENABLE:INFORMATIONAL';
select dbms_warning.get_warning_setting_string from dual;

--6.������ ��� ��������� ������������ pl/sql
select keyword from sys.v_$reserved_words where length=1 and keyword!='A';

--7.������ ��� ��������� ���� �������� ���� pl/sql
select keyword from SYS.v_$reserved_words where length > 1 and keyword != 'A' order by keyword;
select count(keyword) from SYS.v_$reserved_words where length > 1 and keyword != 'A' order by keyword;

--8.������ ��� ��������� ���� ���-��� oracle server, ����.� pl/sql
select name, value from v$parameter where name like 'plsql%';

--9.��, ���.����������.
declare
--���������� � ���������.����� number-���-���
  a NUMBER:=11;
  b NUMBER:=50;
begin
  dbms_output.put_line('����� �����:');
  dbms_output.put_line('a = ' || a);
  dbms_output.put_line('b = ' || b);
  --�����.�-��� ��� 2 ������ number-���-����, ������� ������� � ��������
  dbms_output.put_line('�������������� �������� � ������ �������:');
  dbms_output.put_line('11 + 50 = ' || (a+b));
  dbms_output.put_line('50 - 11 = ' || (b-a));
  dbms_output.put_line('50 * 11 = ' || (b*a));
  dbms_output.put_line('MOD(50,11) = ' || MOD(b,a));
end;

--������.� ����.number-���-��� � ����.������
declare
  c number(5,3) := 24.457;
  pi number (9,8) := 3.14159265;
begin
  dbms_output.put_line('����� � ������������� ������:');
  dbms_output.put_line('c = ' || c);
  dbms_output.put_line('pi = ' || pi);
end;

--���������� � ����.���-��� � ����.������ � �����.��������� (����������)
declare
  d number(7, -2) := 1254567.89;
begin
  dbms_output.put_line('����� � ����.������ � �����.���������(����������):');
  dbms_output.put_line('1234567.89(7,-2) = ' || d);
  dbms_output.put_line('round(35.58) = ' || ROUND(35.58));
end;

--���������� � ����.BINARY_FLOAT-���-���
declare
  f1 binary_float:= 123456789.12345678911;
  f2 binary_float:= 123456.12345678911;
begin
  dbms_output.put_line('BINARY_FLOAT ����������');
  dbms_output.put_line('f1 = ' || f1);
  dbms_output.put_line('f2 = ' || f2);
end;

--��������� � ����.BINARY_DOUBLE ���-���
declare
  f1 binary_double:= 123456789.12345678911;
  f2 binary_double:= 123456.12345678911;
begin
  dbms_output.put_line('BINARY_DOUBLE ����������');
  dbms_output.put_line('f1 = ' || f1);
  dbms_output.put_line('f2 = ' || f2);
end;

--������.� ����.���-��� � ������ � ������.������� E(���� 10)
declare
  e1 number := 0.95e-7;
  e2 number := 0.4e-2;
begin
  dbms_output.put_line('���������� � ������ � ����������� ������� E');
  dbms_output.put_line('0.95e-7 = ' || e1);
  dbms_output.put_line('0.4e-2 = ' || e2);
end;

--�����.� ��������. BOOLEAN ���-���
declare
  b1 boolean := true;
  b2 boolean := false;
begin
  if b1     then dbms_output.put_line('b1 = ' || 'true'); end if;
  if not b1 then dbms_output.put_line ('b1 = ' || 'false'); end if;
  if b2     then dbms_output.put_line('b2 = ' || 'true'); end if;
  if not b2 then dbms_output.put_line ('b2 = ' || 'false'); end if; 
end;

--10.��, ���.������.���������� �������� (varchar2, char, number)
--�����������.����.��-��� �����������
declare
  c1 constant number(5):= 5;
  c2 constant varchar2 (15):= 'Hello World';
  c3 constant char (5) := 'hello';
begin
  dbms_output.put_line('constatnt number: ' || c1);
  dbms_output.put_line('constant varchar2: ' || c2);
  dbms_output.put_line('constant char: ' || c3);
end;

--11.��, ���-��� ���������� � ������ %TYPE � %rowtype
declare
  b char(5) := 'hello';
  g b%TYPE := 'world';    --�� ������ �� ���-���/������ � �������
  q DUAL%ROWTYPE;         --���-�� ������ �� ������ �������/�������
  x DUAL%ROWTYPE;
begin
  dbms_output.put_line('g = ' || g);
  SELECT 2*3 INTO q FROM DUAL;
  select 'a' into x from dual;
  dbms_output.put_line('q = ' || q.DUMMY); 
  dbms_output.put_line('x = ' || x.DUMMY);
end;

--12.��, ���.��������.��� ����.����������� ��������� IF
declare
  n number:= 10;
begin
  dbms_output.put_line('�������� if');
  if 11 > n then dbms_output.put_line ('11 > ' || n);  end if;

  if 8 > n  then dbms_output.put_line ('8 > ' || n);  
            else dbms_output.put_line ('8 < ' || n); end if;
  
  if 12 > n  then dbms_output.put_line ('12 > ' || n);  
  elsif 12 = n then dbms_output.put_line ('12 = ' || n);   
            else dbms_output.put_line ('12 < ' || n); end if;
 end; 
 
 --13.��, ��������.������ CASE
declare
  n number:= 17;
begin
  dbms_output.put_line('�������� case');
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
 
 --14.��, ��������.������ LOOP
declare
  x number:= 0;
begin
  dbms_output.put_line('���� loop');
  loop
    x := x + 1;
      dbms_output.put_line(x);
    exit when x >= 5;
  end loop;
end;
 
 --15.��, ��������.������ WHILE
declare
  x number:= 5;
begin
  dbms_output.put_line('���� while');
  while (x > 0)
  loop
    x := x - 1;
      dbms_output.put_line(x);
  end loop;
end;
 
 --16.��, ��������.������ FOR
begin
  dbms_output.put_line('���� for');
  for k in 1..5
  loop
      dbms_output.put_line(k);
  end loop;
end;