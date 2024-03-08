/* 계정(사용자)

* 관리자 계정 : 데이터베이스의 생성과 관리를 담당하는 계정.
                모든 권한과 책임을 가지는 계정.
                ex) sys(최고관리자), system(sys에서 권한 몇개 제외된 관리자)


* 사용자 계정 : 데이터베이스에 대하여 질의, 갱신, 보고서 작성 등의
                작업을 수행할 수 있는 계정으로
                업무에 필요한 최소한의 권한만을 가지는 것을 원칙으로 한다.
                ex) JHI계정(각자 이니셜 계정), workbook 등
*/

/* DCL(Data Control Language) : 

 계정에 DB, DB객체에 대한 접근 권한을 부여하고 회수하는 언어
 
- GRANT  : 권한 부여
- REVOKE : 권한 회수

* 권한의 종류

1) 시스템 권한 : DB접속, 객체 생성 권한

CRETAE SESSION   : 데이터베이스 접속 권한
CREATE TABLE     : 테이블 생성 권한
CREATE VIEW      : 뷰 생성 권한
CREATE SEQUENCE  : 시퀀스 생성 권한
CREATE PROCEDURE : 함수(프로시져) 생성 권한
CREATE USER      : 사용자(계정) 생성 권한
DROP USER        : 사용자(계정) 삭제 권한
DROP ANY TABLE   : 임의 테이블 삭제 권한


2) 객체 권한 : 특정 객체를 조작할 수 있는 권한

  권한 종류                 설정 객체
    SELECT              TABLE, VIEW, SEQUENCE
    INSERT              TABLE, VIEW
    UPDATE              TABLE, VIEW
    DELETE              TABLE, VIEW
    ALTER               TABLE, SEQUENCE
    REFERENCES          TABLE
    INDEX               TABLE
    EXECUTE             PROCEDURE

*/

/* 관리자 계정 접속 */
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
--> 오라클 SQL을 예전 방식 처럼 사용하겠다
 --> 계정명 작성 시 원하는대로 작성 가능

-- [사용자 계정 생성하기]
CREATE USER TEST_USER IDENTIFIED BY TEST1234;
-- ORA-01045: 사용자 TEST_USER는 CREATE SESSION 권한을 가지고있지 않음; 로그온이 거절되었습니다
--> 접속 권한이 없어서 로그인 불가능

-- [생성한 사용자 계정에 접속 권한 부여하기]
GRANT CREATE SESSION TO TEST_USER;


/* ~TEST_USER로 접속~ */

-- 테이블 생성
CREATE TABLE TB_MEMBER(
	MEMBER_NO NUMBER PRIMARY KEY,
	MEMBER_ID VARCHAR2(30) NOT NULL,
	MEMBER_PW VARCHAR2(30) NOT NULL
);

-- ORA-01031: 권한이 불충분합니다 (테이블 만들 권한이 없음)
-- + TABLESPACE (테이블 생성 공간) 도 없어서 생성 불가

/* ~다시 관리자 계정 접속~ */

-- 테이블 생성 권한 부여
GRANT CREATE TABLE TO TEST_USER;

-- TABLESPACE(객체 생성 공간) 할당
ALTER USER TEST_USER
DEFAULT TABLESPACE USERS
QUOTA 10M ON USERS; -- (USERS란 공간에 10M 공간 할당해줌)

/* ~ 다시 TEST_USER 계정으로 ~ */

-- 테이블 생성
CREATE TABLE TB_MEMBER(
	MEMBER_NO NUMBER PRIMARY KEY,
	MEMBER_ID VARCHAR2(30) NOT NULL,
	MEMBER_PW VARCHAR2(30) NOT NULL
);

----------------------------------------------------
/* ROLE(역할 == 권한의 묶음, 권한명 단순화)
 * 
 * CONNECT(접속) : DB 접속 권한 (CREATE SESSION)
 * 
 * RESOURCE(자원) : DB 기본 객체 8개 생성 권한
 */

/* ~다시 관리자 계정 접속~ */

-- ROLE에 묶여있는 확인하기
SELECT * FROM ROLE_SYS_PRIVS
WHERE ROLE = 'CONNECT';

-- RESOURCE에 있는 권한 확인
SELECT * FROM ROLE_SYS_PRIVS
WHERE ROLE = 'RESOURCE';

-- TEST_USER 계정에 CONNECT, RESOURCE 롤 부여하기
GRANT CONNECT, RESOURCE TO TEST_USER;

-------------------------------------------------------

-- 객체 권한 테스트 --

/* ~TEST_USER 계정 접속~ */
-- KH계정의 EMPLOYEE 테이블 조회하기
SELECT * FROM KH_JHI.EMPLOYEE;
-- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
--> 접근 권한이 없어서 보이지 않음

/* ~KH 계정으로 접속~ */
-- TEST_USER 계정에 EMPLOYEE 테이블 조회 권한 부여
GRANT SELECT ON EMPLOYEE TO TEST_USER;

/* ~TEST_USER로 접속~ */
SELECT * FROM KH_JHI.EMPLOYEE;

/* ~KH 계정으로 접속~ */
-- TEST_USER 의 EMPLOYEE 테이블 조회 권한 회수
REVOKE SELECT ON EMPLOYEE FROM TEST_USER;

/* ~TEST_USER로 접속~ */
SELECT * FROM KH_JHI.EMPLOYEE;













