--system_connection
GRANT CREATE DATABASE LINK TO KNV_USER;
GRANT CREATE PUBLIC DATABASE LINK TO KNV_USER;

drop database link con1;
CREATE DATABASE LINK con1
  CONNECT TO CJACORE 
  IDENTIFIED BY "12345678"
  USING 'USER-œ :1521/orcl.168.1.104';

select * from dba_db_links;

  select * from A@con1;
  insert into A@con1 values(9);
  update A@con1 set x=15 where x=9;
  delete A@con1 where x=15;

begin
  dbms_output.put_line(TEACHERS.FGET_NUM_TEACHERS@con1('»ƒËœ'));
end;


CREATE PUBLIC DATABASE LINK public_con 
  connect to CJACORE identified by "12345678"
  USING 'USER-œ :1521/orcl.168.1.104';

select * from A@public_con;
  insert into A@public_con values(20);
update A@public_con set x=555 where x=20;
delete A@public_con where x=555;

begin
  dbms_output.put_line(TEACHERS.FGET_NUM_TEACHERS@public_con('»ƒËœ'));
  dbms_output.put_line(TEACHERS.FGET_NUM_SUBJECTS@public_con('»—Ë“'));
end;


