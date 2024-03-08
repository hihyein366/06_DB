/* VIEW
 * 
 * 	- 논리적 가상 테이블
 * 	-> 테이블 모양을 하고는 있지만, 실제로 값을 저장하고 있진 않음.
 * 
 *  - SELECT문의 실행 결과(RESULT SET)를 저장하는 객체
 * 
 * 
 * ** VIEW 사용 목적 **
 *  1) 복잡한 SELECT문을 쉽게 재사용하기 위해.
 *  2) 테이블의 진짜 모습을 감출 수 있어 보안상 유리.
 * 
 * ** VIEW 사용 시 주의 사항 **
 * 	1) 가상의 테이블(실체 X)이기 때문에 ALTER 구문 사용 불가.
 * 	2) VIEW를 이용한 DML(INSERT,UPDATE,DELETE)이 가능한 경우도 있지만
 *     제약이 많이 따르기 때문에 조회(SELECT) 용도로 대부분 사용.
 * 
 * 
 *  ** VIEW 작성법 **
 *  CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰이름 [컬럼 별칭]
 *  AS 서브쿼리(SELECT문)
 *  [WITH CHECK OPTION]
 *  [WITH READ OLNY];
 * 
 * 
 *  1) OR REPLACE 옵션 : 
 * 		기존에 동일한 이름의 VIEW가 존재하면 이를 변경
 * 		없으면 새로 생성
 * 
 *  2) FORCE | NOFORCE 옵션 : 
 *    FORCE : 서브쿼리에 사용된 테이블이 존재하지 않아도 뷰 생성
 *    NOFORCE(기본값): 서브쿼리에 사용된 테이블이 존재해야만 뷰 생성
 *    
 *  3) 컬럼 별칭 옵션 : 조회되는 VIEW의 컬럼명을 지정
 * 
 *  4) WITH CHECK OPTION 옵션 : 
 * 		옵션을 지정한 컬럼의 값을 수정 불가능하게 함.
 * 
 *  5) WITH READ OLNY 옵션 :
 * 		뷰에 대해 SELECT만 가능하도록 지정.
 * */


/* VIEW를 생성하기 위해서는 권한이 필요하다 !!!!*/
-- (관리자 계정 접속) 상사가 밑사람에게 주는거기 때문에
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

GRANT CREATE VIEW TO KH_JHI;

CREATE VIEW V_EMP
AS SELECT EMP_ID 사번, EMP_NAME 이름, NVL(DEPT_TITLE, '없음') 부서명, JOB_NAME 직급명
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
ORDER BY 사번;

-- 생선한 VIEW 조회하기
SELECT * FROM V_EMP;

-- V_EMP 에서 대리직급 사원을 이름 오름차순으로 조회
SELECT * FROM V_EMP
WHERE 직급명 = '대리'
ORDER BY 이름;

----------------------------------------------------------------

/* OR REPLACE 옵션 사용하기 */
--> VIEW 생성 시 같은 이름의 VIEW가 있으면 변경

-- DROP VIEW V_EMP;

CREATE OR REPLACE VIEW V_EMP AS 
	SELECT EMP_ID 사번, EMP_NAME 이름, 
	NVL(DEPT_TITLE, '없음') 부서명, JOB_NAME 직급명, 
	NVL(LOCAL_NAME, '없음') 지역명
	FROM EMPLOYEE 
	NATURAL JOIN JOB
	LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
	LEFT JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
	ORDER BY EMP_ID;

SELECT * FROM V_EMP;

----------------------------------------------------------------

/* WITH READ ONLY 옵션 */

-- DEPARTMENT 테이블을 복사한 DEPT_COPY2 생성
CREATE TABLE DEPT_COPY2 
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY2;
--> DEPT_TITLE 컬럼만 NULL 허용상태

-- DEPT_COPY2 테이블의 DEPT_ID, LOCATION_ID 컬럼만을 이용해서
-- V_DCOPY2 VIEW 생성
CREATE VIEW V_DCOPY2
AS SELECT DEPT_ID, LOCATION_ID FROM DEPT_COPY2;

SELECT * FROM V_DCOPY2;

-- V_DCOPY2 VIEW를 이용해서 INSERT 하기
INSERT INTO V_DCOPY2 VALUES('D0', 'L2');

-- 원본 테이블 INSERT 확인
SELECT * FROM DEPT_COPY2;
--> 원본에 값 삽입되었음을 확인함
-- (가상 테이블뷰는 값 저장/수정/삭제 불가. 따라서 연결된 원본이 변함)

-- D0 / NULL / L2
--> NULL은 DB 무결성을 약하게 만드는 원인 가능하면 NULL 안생기게 해라

-- WITH READ ONLY 옵션 추가해서 읽기 전용으로
CREATE OR REPLACE VIEW V_DCOPY2
AS SELECT DEPT_ID, LOCATION_ID FROM DEPT_COPY2 
WITH READ ONLY;

INSERT INTO V_DCOPY2 VALUES('D0', 'L2');



----------------------------------------------------------------


/* SEQUENCE(순서, 연속)
 * - 순차적으로 일정한 간격의 숫자(번호)를 발생시키는 객체
 *   (번호 생성기)
 * 
 * *** SEQUENCE 왜 사용할까?? ***
 * PRIMARY KEY(기본키) : 테이블 내 각 행을 구별하는 식별자 역할
 * 						 NOT NULL + UNIQUE의 의미를 가짐
 * 
 * PK가 지정된 컬럼에 삽입될 값을 생성할 때 SEQUENCE를 이용하면 좋다!
 * 
 *   [작성법]
  CREATE SEQUENCE 시퀀스이름
  [STRAT WITH 숫자] -- 처음 발생시킬 시작값 지정, 생략하면 자동 1이 기본
  [INCREMENT BY 숫자] -- 다음 값에 대한 증가치, 생략하면 자동 1이 기본
  [MAXVALUE 숫자 | NOMAXVALUE] -- 발생시킬 최대값 지정 (10의 27승 -1)
  [MINVALUE 숫자 | NOMINVALUE] -- 최소값 지정 (-10의 26승)
  [CYCLE | NOCYCLE] -- 값 순환 여부 지정
  [CACHE 바이트크기 | NOCACHE] -- 캐쉬메모리 기본값은 20바이트, 최소값은 2바이트
	-- 시퀀스의 캐시 메모리는 할당된 크기만큼 미리 다음 값들을 생성해 저장해둠
	-- --> 시퀀스 호출 시 미리 저장되어진 값들을 가져와 반환하므로 
	--     매번 시퀀스를 생성해서 반환하는 것보다 DB속도가 향상됨.
 * 
 * 
 * ** 사용법 **
 * 
 * 1) 시퀀스명.NEXTVAL : 다음 시퀀스 번호를 얻어옴.
 * 						 (INCREMENT BY 만큼 증가된 수)
 * 						 단, 생성 후 처음 호출된 시퀀스인 경우
 * 						 START WITH에 작성된 값이 반환됨.
 * 
 * 2) 시퀀스명.CURRVAL : 현재 시퀀스 번호를 얻어옴.
 * 						 단, 시퀀스가 생성 되자마자 호출할 경우 오류 발생.
 * 						== 마지막으로 호출한 NEXTVAL 값을 반환
 * */

-- 테스트용 테이블 생성
CREATE TABLE TB_TEST(
	TEST_NO NUMBER PRIMARY KEY,
	TEST_NAME VARCHAR2(30) NOT NULL
);

-- 시퀀스 생성
CREATE SEQUENCE SEQ_TEST_NO
START WITH 100 -- 시작 번호 100
INCREMENT BY 5 -- NEXTVAL 호출 마다 5씩 증가
MAXVALUE 150 -- 증가 가능한 최대값 
NOMINVALUE -- 최소값 없음
NOCYCLE -- 반복없음 
NOCACHE -- 미리 생성해두는 시퀀스 번호 없음
;

-- 현재 시퀀스 번호 확인
SELECT SEQ_TEST_NO.CURRVAL FROM DUAL;
-- ORA-08002: 시퀀스 SEQ_TEST_NO.CURRVAL은 이 세션에서는 정의 되어 있지 않습니다
-- NEXTVAL로 호출 전 현재 시퀀스 번호 가져오려 하니까 오류남

SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL; -- 100
SELECT SEQ_TEST_NO.CURRVAL FROM DUAL; -- 100 (오류 X)

-- NEXTVAL 호출 시 마다 INCREMENT BY 에 작성된 값 만큼 증가
SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL; -- +5
SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL; -- +5
SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL; -- +5

-- TB_TEST 테이블 INSERT 시 시퀀스 사용하기
INSERT INTO TB_TEST VALUES(SEQ_TEST_NO.NEXTVAL, '홍길동'); -- +5
INSERT INTO TB_TEST VALUES(SEQ_TEST_NO.NEXTVAL, '김영희'); -- +10
INSERT INTO TB_TEST VALUES(SEQ_TEST_NO.NEXTVAL, '김종수'); -- +15

SELECT * FROM TB_TEST;

-- TB_TEST 테이블 UPDATE 시 시퀀스 사용하기

-- TB_TEST에서 TEST_NO 컬럼 값이 가장 작은 컬럼 값을 다음 시퀀스 번호로 변경

UPDATE TB_TEST
SET TEST_NO = SEQ_TEST_NO.NEXTVAL
WHERE TEST_NO = (SELECT MIN(TEST_NO) FROM TB_TEST);

SELECT * FROM TB_TEST; -- 길동이가 +20의 NO을 가지게 됨.


--------------------------------

-- SEQUENCE 변경(ALTER)

--> CREATE 구문과 비슷하지만 START WITH 옵션만 제외됨

/*
 [작성법]
  ALTER SEQUENCE 시퀀스이름
  [INCREMENT BY 숫자] -- 다음 값에 대한 증가치, 생략하면 자동 1이 기본
  [MAXVALUE 숫자 | NOMAXVALUE] -- 발생시킬 최대값 지정 (10의 27승 -1)
  [MINVALUE 숫자 | NOMINVALUE] -- 최소값 지정 (-10의 26승)
  [CYCLE | NOCYCLE] -- 값 순환 여부 지정
  [CACHE 바이트크기 | NOCACHE] -- 캐쉬메모리 기본값은 20바이트, 최소값은 2바이트
*/	

-- SEQ_TEST_NO 시퀀드의 최대값을 200으로 변경
ALTER SEQUENCE SEQ_TEST_NO
MAXVALUE 200;

SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL;


-----------------------------------------------------

-- VIEW, SEQUENCE 삭제

DROP VIEW V_DCOPY2;

DROP SEQUENCE SEQ_TEST_NO;

------------------------------------------------------------------------

/* INDEX(색인)
 * - SQL 구문 중 SELECT 처리 속도를 향상 시키기 위해 
 *   컬럼에 대하여 생성하는 객체
 * 
 * - 인덱스 내부 구조는 B* 트리 형식으로 되어있음.
 * 
 * 
 * ** INDEX의 장점 **
 * - 이진 트리 형식으로 구성되어 자동 정렬 및 검색 속도 증가.
 * 
 * - 조회 시 테이블의 전체 내용을 확인하며 조회하는 것이 아닌
 *   인덱스가 지정된 컬럼만을 이용해서 조회하기 때문에
 *   시스템의 부하가 낮아짐.
 * 
 * ** 인덱스의 단점 **
 * - 데이터 변경(INSERT,UPDATE,DELETE) 작업 시 
 * 	 이진 트리 구조에 변형이 일어남
 *    -> DML 작업이 빈번한 경우 시스템 부하가 늘어 성능이 저하됨.
 * 
 * - 인덱스도 하나의 객체이다 보니 별도 저장공간이 필요(메모리 소비)
 * 
 * - 인덱스 생성 시간이 필요함.
 * 
 * 
 * 
 *  [작성법]
 *  CREATE [UNIQUE] INDEX 인덱스명
 *  ON 테이블명 (컬럼명[, 컬럼명 | 함수명]);
 * 
 *  DROP INDEX 인덱스명;
 * 
 * 
 *  ** 인덱스가 자동 생성되는 경우 **
 *  -> PK 또는 UNIQUE 제약조건이 설정된 컬럼에 대해 
 *    UNIQUE INDEX가 자동 생성된다. 
 * */

-- 인덱스 사용 방법 : WHERE절에 INDEX가 지정된 컬럼 언급하기

SELECT * FROM EMPLOYEE; -- 인덱스 사용 x

SELECT * FROM EMPLOYEE -- 인덱스 사용 o
WHERE EMP_ID != 0;

--> 인덱스 사용했으나 데이터가 적어서 구분이 안됨.

-- 인덱스 확인용 테이블 생성
CREATE TABLE TB_IDX_TEST(
    TEST_NO NUMBER PRIMARY KEY, -- 자동으로 인덱스가 생성됨.
    TEST_ID VARCHAR2(20) NOT NULL
);

-- TB_IDX_TEST 테이블에 샘플데이터 100만개 삽입 (PL/SQL 사용)
BEGIN
    FOR I IN 1..1000000
    LOOP
        INSERT INTO TB_IDX_TEST VALUES( I , 'TEST' || I );
    END LOOP;
    
    COMMIT;
END;

SELECT COUNT(*) FROM TB_IDX_TEST;

-- 인덱스 사용 X
SELECT * FROM TB_IDX_TEST
WHERE TEST_ID = 'TEST500000'; -- 0.014s

-- 인덱스 사용 O
SELECT * FROM TB_IDX_TEST 
WHERE TEST_NO = 500000; -- 0.002s

SELECT * FROM TB_IDX_TEST;





