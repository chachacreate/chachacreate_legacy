WHENEVER SQLERROR EXIT SQL.SQLCODE
-- 시퀀스 존재 시 삭제
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE audses$';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN  -- 시퀀스가 없을 경우는 무시
            RAISE;
        END IF;
END;
/
-- Drop sequence audses$;
Create sequence audses$ start with 1 increment by 1 minvalue 1 maxvalue 32000 cycle cache 20 noorder;
CREATE USER chacha IDENTIFIED BY 1234;
GRANT CONNECT, RESOURCE TO chacha;
EXIT