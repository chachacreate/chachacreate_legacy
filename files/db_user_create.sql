WHENEVER SQLERROR EXIT SQL.SQLCODE
Drop sequence audses$;
Create sequence audses$ start with 1 increment by 1 minvalue 1 maxvalue 32000 cycle cache 20 noorder;
CREATE USER chacha IDENTIFIED BY 1234;
GRANT CONNECT, RESOURCE TO chacha;
EXIT