-- 한 줄 주석 (ctrl+/)
/* 범위 주석 (ctrl+shift+/) */

/* SQL 실행 : ctrl + enter
 * 
 * SQL 여러 개 실행 : (블럭 후) alt+x
 * */

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER KH_JHI IDENTIFIED BY KH1234;

-- 생성된 계정에 접속 + 기본 자원 관리 권한
GRANT RESOURCE, CONNECT TO KH_JHI;
ALTER USER KH_JHI DEFAULT TABLESPACE SYSTEM
QUOTA UNLIMITED ON SYSTEM;
