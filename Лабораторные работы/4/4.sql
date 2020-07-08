--получ.список всех сущ-щих PDB в рамках ORA12W
select name,open_mode from v$pdbs; 

--получить перечень экземпл€ров
select INSTANCE_NAME from v$instance;

--перечень установл.компонент + версии и статус
select * from PRODUCT_COMPONENT_VERSION;

--создать собств.экземпл€р (KNV_PDB)
--ORACLE DATABASE CONFIGURATION ASSISTANT (screenshot)

--получ.список всех сущ-щих PDB в рамках ORA12W + наша сущ-ет
select name,open_mode from v$pdbs;
