--1.����������� ���.���������, ���.������ �������� ������ ��������, ���.���.��
--������� �������� ����� � ���������

CREATE OR REPLACE PROCEDURE GET_TEACHER (PCODE TEACHER.PULPIT%TYPE) IS
  CURSOR my_curs IS SELECT TEACHER_NAME, TEACHER FROM TEACHER WHERE PULPIT = PCODE;
  t_name TEACHER.TEACHER_NAME%type;
  t_code TEACHER.TEACHER%type;
BEGIN
  OPEN my_curs;
  LOOP
      DBMS_OUTPUT.PUT_LINE(t_code||' '||t_name);
    FETCH my_curs INTO t_name, t_code;
    EXIT WHEN my_curs%notfound;
  END LOOP;
  CLOSE my_curs;
END;

ACCEPT PCODE CHAR PROMPT "������� �������� ��� �������: "
exec GET_TEACHER('&&PCODE' );
--����

DECLARE
  PCODE TEACHER.PULPIT%type;
BEGIN
  PCODE := '����';
  GET_TEACHER(PCODE);
END;

--2.������.���.�-��� ��� ������� ���-�� ��������, ���������� �� �������, ���.����� � ���-��

CREATE OR REPLACE FUNCTION GET_NUM_TEACHERS(PCODE TEACHER.PULPIT%TYPE)
  RETURN NUMBER IS
    tCount NUMBER;
BEGIN
  SELECT COUNT(*) INTO tCount FROM TEACHER WHERE PULPIT = PCODE;
  RETURN tCount;
  EXCEPTION
    WHEN OTHERS THEN
    return -1;
END;

BEGIN
  DBMS_OUTPUT.PUT_LINE(GET_NUM_TEACHERS('����'));
END;

--3.����������� ���������
--get_teachers - ������ �������� �� ������� � ����� � ����������

CREATE OR REPLACE PROCEDURE GET_TEACHERS(FCODE FACULTY.FACULTY%TYPE) IS
  CURSOR my_curs IS
    SELECT T.TEACHER_NAME, T.TEACHER, P.FACULTY
    FROM TEACHER T
    INNER JOIN PULPIT P
    ON T.PULPIT = P.PULPIT
    WHERE P.FACULTY = FCODE;
  t_name TEACHER.TEACHER_NAME%type;
  t_code TEACHER.TEACHER%type;
  t_faculty PULPIT.FACULTY%type;
BEGIN
  OPEN my_curs;
  LOOP
    DBMS_OUTPUT.PUT_LINE(t_name||' '||t_code||' '||t_faculty);
    FETCH my_curs INTO t_name, t_code, t_faculty;
    EXIT WHEN my_curs%notfound;
  END LOOP;
  CLOSE my_curs;
END;

ACCEPT FCODE CHAR PROMPT "������� �������� ��� FCODE: "
exec GET_TEACHERS('&&FCODE' );

BEGIN
GET_TEACHERS('����');
END;

--get_subject - ������ ���������, �������.�� �������� (��� � ���-���)
CREATE OR REPLACE PROCEDURE GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) IS
  CURSOR my_curs IS
      SELECT SUBJECT, SUBJECT_NAME, S.PULPIT
        FROM SUBJECT S
        WHERE S.PULPIT = PCODE;
  s_subject SUBJECT.SUBJECT%TYPE;
  s_subject_name SUBJECT.SUBJECT_NAME%TYPE;
  s_pulpit SUBJECT.PULPIT%TYPE;
BEGIN
  OPEN my_curs;
  LOOP
    DBMS_OUTPUT.PUT_LINE(s_subject||' '||s_subject_name||' '||s_pulpit);
    FETCH my_curs INTO s_subject, s_subject_name, s_pulpit;
    EXIT WHEN my_curs%notfound;
  END LOOP;
  CLOSE my_curs;
END;

BEGIN
  GET_SUBJECTS('����');
END;

--4.���.�-��� ������� ���-�� �������� �� �-��
CREATE OR REPLACE FUNCTION GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE)
  RETURN NUMBER IS
    tCount NUMBER;
BEGIN
  SELECT COUNT(*) INTO tCount FROM TEACHER T
  INNER JOIN PULPIT P
  ON T.PULPIT = P.PULPIT
  WHERE P.FACULTY = FCODE;
    RETURN tCount;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN -1;
END;

BEGIN
  DBMS_OUTPUT.PUT_LINE(GET_NUM_TEACHERS('����'));
END;

--���.�-��� ������� ���-�� ��������� ������������ �� ��������
CREATE OR REPLACE FUNCTION GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
  RETURN NUMBER IS
    tCount NUMBER:=0;
BEGIN
    SELECT COUNT(*) INTO tCount
      FROM SUBJECT
      WHERE SUBJECT.PULPIT = PCODE;
    RETURN tCount;
    EXCEPTION
      WHEN OTHERS THEN
      tCount := -1;
      RETURN tCount;
END;

BEGIN
  DBMS_OUTPUT.PUT_LINE(GET_NUM_SUBJECTS('����'));
END;

--5.����������� �����, ���.�������� ������� � ���������
--��������� �������� pl/sql,�������.������ 
CREATE OR REPLACE PACKAGE TEACHERSS AS
  TYPE TEACHER_R IS RECORD
  (
    FCODE FACULTY.FACULTY%TYPE,
    PCODE SUBJECT.PULPIT%TYPE
  );
  EXC_GET_NUM_TEACHERS EXCEPTION;
  EXC_GET_NUM_SUBJECTS EXCEPTION;
  FUNCTION GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER;
  FUNCTION GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER;
END TEACHERSS;

CREATE OR REPLACE PACKAGE BODY TEACHERSS AS

FUNCTION GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER
    IS
        tCount NUMBER;
    BEGIN
      SELECT COUNT(*) INTO tCount FROM TEACHER T
      INNER JOIN PULPIT P
      ON T.PULPIT = P.PULPIT
      WHERE P.FACULTY = FCODE;
        RETURN tCount;
      EXCEPTION
        WHEN OTHERS THEN RAISE EXC_GET_NUM_TEACHERS;
      END GET_NUM_TEACHERS;
      
FUNCTION GET_NUM_SUBJECTS(PCODE subject.pulpit%TYPE) RETURN NUMBER
    IS
      tCount NUMBER :=0;
    BEGIN
      SELECT COUNT(*) INTO tCount
      FROM SUBJECT
      WHERE SUBJECT.PULPIT = PCODE;
      RETURN tCount;
  EXCEPTION
    WHEN OTHERS THEN RAISE EXC_GET_NUM_SUBJECTS;
  END GET_NUM_SUBJECTS;
 
END TEACHERSS;
  
--6.����������������� ������ ������
DECLARE
  rec TEACHERSS.TEACHER_R;
BEGIN
  rec.FCODE := '����';
  rec.PCODE := '����';
  DBMS_OUTPUT.PUT_LINE(teacherss.GET_NUM_TEACHERS(rec.FCODE));
  DBMS_OUTPUT.PUT_LINE(teacherss.GET_NUM_SUBJECTS(rec.PCODE));
END;