--���������� �������
--1. �������� � ������� teachers 2 ������� (BIRTHDAY � SALARY)
--��������� �� ����������
SELECT * FROM TEACHER;

--2.�������� ������ �������� � ���� ������� �.�.
--select * from TEACHER 
SELECT  regexp_substr(TEACHER_NAME,'(\S+)',1, 1)||' '||
        SUBSTR(regexp_substr(TEACHER_NAME,'(\S+)',1, 2),1, 1)||'. '||
        SUBSTR(regexp_substr(TEACHER_NAME,'(\S+)',1, 3),1, 1)||'. ' as name
  FROM TEACHER;

--3.�������� ������ ��������������, ���.�������� � �����������
SELECT * FROM TEACHER WHERE TO_CHAR((BIRTHDAY), 'DAY')='�����������';

--4.view, � ���.������ �������� ���.�������� � ����.������
CREATE VIEW birth AS SELECT * FROM TEACHER
    WHERE TO_CHAR(sysdate,'mm')+1 = TO_CHAR(BIRTHDAY, 'mm');

SELECT * FROM birth;

--5.view, � ���. ���-�� ��������, ���.�������� � ������ ������
CREATE VIEW months AS
SELECT  to_char(BIRTHDAY, 'Month') �����,
        count(*) ��������������
  FROM TEACHER
  GROUP BY to_char(birthday, 'Month')
  having count(*)>=1;

SELECT * FROM months;
drop view months;

--6. ������ � ������� ������ ��������, � ������� � ����.���� ������
CURSOR TeacherBirtday(TEACHER%ROWTYPE) 
    RETURN TEACHER%ROWTYPE IS
    SELECT * FROM TEACHER WHERE MOD((TO_CHAR(sysdate,'yyyy') - TO_CHAR(BIRTHDAY, 'yyyy')+1), 10)=0;

--7.������ � ������� �� �� �������� � ����������� ���� �� �����, ������ ������� ����.����
-- ��� ������� �-�� � ���� �-��� � �����
CURSOR tAvgSalary(TEACHER.SALARY%TYPE,TEACHER.PULPIT%TYPE) 
  RETURN TEACHER.SALARY%TYPE,TEACHER.PULPIT%TYPE  IS
    SELECT FLOOR(AVG(SALARY)), PULPIT
    FROM TEACHER
    GROUP BY PULPIT;
  
select decode(grouping( T.PULPIT),0,to_char(T .PULPIT),'��������� ���') PULPIT , FLOOR(AVG(SALARY))
  FROM TEACHER T, PULPIT P,FACULTY F
    WHERE T.PULPIT = P.PULPIT AND P.FACULTY='���'
  group by rollup(T.PULPIT); 

--8.�������� ������.��� PL/SQL-������
--���-�� ������ ����.�� �����
--������ � ����.��������
--�������� ����������-----  
DECLARE
  TYPE PERSON IS RECORD
    (
      PULP NVARCHAR2(50),
      NAME NVARCHAR2(50)
    );
  rec2 PERSON;
BEGIN
  SELECT  TEACHER_NAME, PULPIT INTO rec2
  FROM TEACHER
  WHERE TEACHER='���';
  DBMS_OUTPUT.PUT_LINE(rec2.PULP||' '||rec2.NAME);
END;

DECLARE
    TYPE ADDRESS IS RECORD
    (
      TOWN NVARCHAR2(20),
      COUNTRY NVARCHAR2(20)
    );
    TYPE PERSON IS RECORD
    (
      NAME TEACHER.TEACHER_NAME%TYPE,
      PULP TEACHER.PULPIT%TYPE,
      homeAddress ADDRESS
    );
  per1 PERSON;
  per2 PERSON;
BEGIN
  SELECT TEACHER_NAME, PULPIT INTO per1.NAME, per1.PULP
  FROM TEACHER
  WHERE TEACHER='����';
  per1.homeAddress.TOWN := 'Polotsk';
  per1.homeAddress.COUNTRY := 'Belarus';
  per2 := per1;
  DBMS_OUTPUT.PUT_LINE(per2.NAME||' '||per2.PULP||' �� '||per2.homeAddress.TOWN||' '||per2.homeAddress.COUNTRY);
END;