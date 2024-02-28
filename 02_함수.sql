-- 함수 : 컬럼값 | 지정된값을 읽어 연산한 결과를 반환하는 것

-- 단일행 함수 : N개의 행의 컬럼 값을 전달하여 N개의 결과가 반환

-- 그룹 함수  : N개의 행의 컬럼 값을 전달하여 1개의 결과가 반환
--			  (그룹의 수가 늘어나면 그룹의 수 만큼 결과를 반환)

-- 함수는 SELECT절, WHERE절, ORDER BY절
--      GROUP BY절, HAVING절에서 사용 가능



/********************* 단일행 함수 *********************/

-- <문자열 관련 함수>

-- LENGTH(문자열|컬럼명) : 문자열의 길이 반환
SELECT 'HELLO WORLD', LENGTH('HELLO WORLD') FROM DUAL;

-- [EMPLOYEE]에서 사원명, 이메일, 이메일 길이 조회
-- 단, 이메일 길이가 12 이하인 행만 
-- 이메일 길이 오름차순 조회 
SELECT EMP_NAME, EMAIL, LENGTH(EMAIL) "이메일 길이"
FROM EMPLOYEE
WHERE LENGTH(EMAIL) <= 12
ORDER BY "이메일 길이";

----------------------------------------

-- INSTR(문자열|컬럼명, '찾을 문자열' [, 찾을 시작위치 [, 순번]])

-- 찾을 시작 위치부터 지정된 순번 째 찾은 문자열의 시작 위치를 반환

-- 문자열에서 맨 앞에있는 'B'의 위치를 조회
SELECT 'AABAACAABBAA', INSTR('AABAACAABBAA', 'B')
FROM DUAL; -- 3 (INDEX X, 몇번째에 위치해 있는가)

-- 문자열에서 5번 부터 검색 시작해서 처음 찾은 'B'의 위치 조회
SELECT 'AABAACAABBAA', INSTR('AABAACAABBAA', 'B', 5) 
FROM DUAL; -- 9

-- 문자열에서 5번 부터 검색 시작해서 2번째로 찾은 'B'의 위치 조회
SELECT 'AABAACAABBAA', INSTR('AABAACAABBAA', 'B', 5, 2) 
FROM DUAL; -- 10

----------------------------------------------------------

-- SUBSTR(문자열 | 컬럼명, 시작위치 [,길이])

-- 문자열을 시작 위치부터 지정된 길이 만큼 잘라내서 반환
-- 길이 미작성 시 시작 위치 부터 끝까지 잘라내서 반환

-- 시작 위치, 자를 길이 지정
SELECT SUBSTR('ABCDEFG', 2, 3) FROM DUAL; -- BCD

-- 시작 위치, 자를 길이 미지정
SELECT SUBSTR('ABCDEFG', 4) FROM DUAL; -- DEFG

-- [EMPLOYEE]에서 사원명, 이멜 아이디 (@ 앞까지 문자열)을
-- 이멜 아이디 오름차순으로 조회
-- INSTR(EMAIL, '@') -1 : @까지면 골뱅이 포함이라 -1해서 그 앞까지로 해줌
SELECT EMP_NAME, 
	SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') -1) "이메일 아이디"
FROM EMPLOYEE
ORDER BY "이메일 아이디";

-------------------------------------------------------------

-- TRIM([ [옵션] 문자열 | 컬럼명 FROM ] 문자열 | 컬럼명)
-- 주어진 문자열의 앞쪽|뒤쪽|양쪽에 존재하는 지정된 문자열을 제거

-- 옵션 : LEADING(앞쪽), TRAILING(뒤쪽), BOTH(양쪽, 기본값)

-- 문자열 공백 제거
SELECT '  기 준  ', 
	TRIM(LEADING ' ' FROM '  기 준  '), -- 앞쪽 공백 제거
	TRIM(TRAILING ' ' FROM '  기 준  '), -- 뒤쪽 공백 제거
	TRIM(BOTH ' ' FROM '  기 준  ') -- 양쪽 공백 제거
FROM DUAL;

-- 특정 문자열 제거
SELECT '###기 준###', 
	TRIM(LEADING  '#' FROM '###기 준###'), -- 앞쪽 # 제거
	TRIM(TRAILING '#' FROM '###기 준###'), -- 뒤쪽 # 제거
	TRIM(BOTH 		'#' FROM '###기 준###') -- 양쪽 # 제거
FROM DUAL;


-------------------------------------------------------

-- REPLACE(문자열 | 컬럼명, 찾을 문자열, 바꿀 문자열)
SELECT * FROM NATIONAL;

SELECT NATIONAL_CODE, REPLACE(NATIONAL_NAME, '한국', '대한민국')
FROM "NATIONAL";

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------

-- <숫자 관련 함수>

-- MOD(숫자 | 컬럼명,  나눌 값) : 나머지
SELECT MOD(105, 100) FROM DUAL; -- 5

-- ABS(숫자 | 컬럼명) : 절대값
SELECT ABS(10), ABS(-10) FROM DUAL;

-- CEIL(숫자 | 컬럼명) : 올림
-- FLOOR(숫자 | 컬럼명) : 내림
SELECT CEIL(1.1), FLOOR(1.1) FROM DUAL; --2, 1


-- ROUND(숫자 | 컬럼명 [, 소수점 위치]) : 반올림
-- 소수점 위치 지정 x : 소수점 첫째 자리에서 반올림 -> 정수 표현
-- 소수점 위치 지정 O
 -- 1) 양수 : 지정된 위치의 소수점 자리까지 표현
 -- 2) 음수 : 지정된 위치의 정수 자리까지 표현

SELECT 123.456,
	ROUND(123.456), -- 123
	ROUND(123.456, 1), -- 123.5
	ROUND(123.456, 2), -- 123.46
	ROUND(123.456, -1), -- 120
	ROUND(123.456, -2) -- 100
FROM DUAL;

-- TRUNC(숫자 | 컬럼명 [,소수점 위치]) : 버림 (잘라내기)
SELECT -123.5,
	TRUNC(-123.5), -- -123
	FLOOR(-123.5) -- -124 (헛갈리지마!)
FROM DUAL;


-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------

-- <날짜 관련 함수>
-- SYSDATE : 현재 시간
-- SYSTIMESTAMP : 현재 시간 (ms 포함, 표준시간대)
SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;


-- MONTHS_BETWEEN(날짜, 날짜) : 두 날짜 사이의 개월 수 반환
--> 반환 값 중 정수 부분은 차이나는 개월 수
SELECT MONTHS_BETWEEN('2024-01-28', SYSDATE) FROM DUAL; 

-- ** ORACLE은 자료형이 맞지 않은 상황이라도 작성된 값의 형태가 
-- 요구하는 자료형의 형태를 띄고 있으면 자동으로 형변환(PARSING)을 진행함

-- ex) '2024-03-28' -> TO_DATE('2024-03-28', 'YYYY-MM-DD')


-- [EMPLOYEE]에서 모든 사원의 사번, 이름, 입사일, N년차 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE, 
	CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12) || '년차' "N년차"
FROM EMPLOYEE;


-- MONTHS_BETWEEN()은 윤년(2월 29일이 포함된 해) 계산이 자동으로 수행
--> YEAR, MONTH 단위 계산 시 더 정확한 값을 얻어낼 수 있다

-----------------------------------------------------------

-- ADD_MONTHS(날짜, 숫자) : 날짜를 숫자만큼의 개월 수를 더하여 반환
SELECT SYSDATE, -- 2/27
	SYSDATE + 29, -- 3/27
	SYSDATE + 29 + 31, -- 4/27
	
	ADD_MONTHS(SYSDATE, 1), -- 3/27
	ADD_MONTHS(SYSDATE, 2) -- 4/27
FROM DUAL;

-- LAST DAY(날짜) : 해당 월의 마지막 날짜 반환
SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- 다음 달 마지막 날짜
SELECT LAST_DAY(ADD_MONTHS(SYSDATE, 1)) FROM DUAL;

-- 다음 달 첫 번째, 마지막 날짜
SELECT LAST_DAY(SYSDATE) +1,
	LAST_DAY(ADD_MONTHS(SYSDATE, 1))
FROM DUAL;


-- EXTRACT(YEAR | MONTH | DAY FROM 날짜)
-- (EXTRACT : 뽑아내다, 추출하다)
-- 지정도니 날짜의 년 | 월 | 일을 추출하여 정수로 반환

SELECT EXTRACT(YEAR FROM SYSDATE)년,
	EXTRACT(MONTH FROM SYSDATE)월,
	EXTRACT(DAY FROM SYSDATE)일
FROM DUAL;


-- [EMPLOYEE]에서 2000년대 입사한 사원의
-- 사번, 이름, 입사일을 이름 오름차순으로 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE 
FROM EMPLOYEE 
WHERE EXTRACT(YEAR FROM HIRE_DATE) >= 2000 
ORDER BY EMP_NAME;


-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------

-- <형변환(Parsing) 함수>

-- 문자열(CHAR, VARCHAR2) <-> 숫자(NUMBER)
-- 문자열(CHAR, VARCHAR2) <-> 날짜(DATE)
-- 숫자(NUMBER) --> 날짜(DATE)


/* TO_CHAR(날짜 | 숫자 [, 포맷]) : 문자열로 변환
 * 
 * 숫자 -> 문자열
 * 포맷 
 * 1) 9 : 숫자 한 칸을 의미, 오른쪽 정렬
 * 2) 0 : 숫자 한 칸을 의미, 오른쪽 정렬, 빈 칸에 0을 추가
 * 3) L : 현재 시스템이나 DB에 설정된 나라의 화폐 기호
 * 4) , : 숫자의 자릿수 구분
 * */

SELECT 1234, TO_CHAR(1234) FROM DUAL; -- 데이터 타입이 변경됨

SELECT 1234, TO_CHAR(1234, '99999999') FROM DUAL;
SELECT 1234, TO_CHAR(1234, '00000000') FROM DUAL;

/* 숫자 -> 문자열 변환시 문제 상황 */
--> 포맷에 지정된 칸 수가 숫자 길이보다 적으면 전부 #으로 변환되서 출력
SELECT 1234, TO_CHAR(1234, '000') FROM DUAL;  

-- 화폐기호 + 자릿수 구분
SELECT 
	TO_CHAR(123456789, 'L999999999'),
	TO_CHAR(123456789, '$999999999'),
	TO_CHAR(123456789, '$999,999,999')
FROM DUAL;


-- 모든 사원의 연봉 조회
SELECT EMP_NAME, TO_CHAR(SALARY * 12, 'L999,999,999') 연봉
FROM EMPLOYEE;

------------------------

/* 날짜 -> 문자열
 * 
 * YY    : 년도(짧게) EX) 23
 * YYYY  : 년도(길게) EX) 2023
 * 
 * RR    : 년도(짧게) EX) 23
 * RRRR  : 년도(길게) EX) 2023
 * 
 * MM : 월
 * DD : 일
 * 
 * AM/PM : 오전/오후 (뭘 써도 상관없음 그 시간대로 표현)
 * 
 * HH   : 시간 (12시간)
 * HH24 : 시간 (24시간)
 * MI   : 분
 * SS   : 초
 * 
 * DAY : 요일(전체) EX) 월요일, MONDAY
 * DY  : 요일(짧게) EX) 월, MON
 * */

-- 현재 날짜 -> '2024-02-27'
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD')
FROM DUAL;

-- 현재 날짜 -> '2024-02-27 화요일'
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY')
FROM DUAL;

-- 현재 날짜 -> '24/02/27 (화) 오후 12:11:40' 
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YY/MM/DD (DY) PM HH:MI:SS')
FROM DUAL;

-- /, (), :, - 는 일반적으로 날짜 표기시 사용하는 기호.
--> 패턴으로 인식되어 오류가 발생하지 않음

-- 년,월,일 같은 한글 또는 날짜와 관련 없는 문자는 패턴x
--> 이런 관련 없는 문자들 "" 감싸면 사용 가능 ("" 의미 : 있는 그대로 인식)

-- 현재 날짜 -> 2024년 02월 27일 오후 12시 15분 30초
SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" PM HH"시" MI"분" SS"초"')
FROM DUAL;

---------------------------------------------------------------------

-- TO_DATE(문자열 | 숫자 [, 포맷])

-- 문자열 또는 숫자를 날짜 형식으로 변환

SELECT TO_DATE('2024-03-04')
FROM DUAL;
-- 문자열이 날짜를 표현하는 형식이면 포맷 지정없이 바로 변경 가능

SELECT TO_DATE('04-03-2024', 'DD-MM-YYYY')
FROM DUAL; -- 지정해줘야 날짜로 변환됨

SELECT TO_DATE('02월 27일 화요일 12시 24분', 
							 'MM"월" DD"일" DAY HH"시" MI"분"') 
FROM DUAL; 

-- 숫자 -> 날짜
SELECT TO_DATE(20240227, 'YYYYMMDD') FROM DUAL;


/*** 연도 패턴  Y, R 차이점 ***/

-- 연도가 두자리만 작성되어있는 경우
-- 50 미만 : Y,R 둘 다 누락된 연도 앞부분에 현재 세기(21C == 2000년대) 추가
-- 50 이상 : Y : 현재 세기(2000년대) 추가
--		   	  R : 이전 세기(1900년대) 추가

-- 50 미만 확인
SELECT 
	TO_DATE('49-11-25', 'YY-MM-DD') "YY", -- 2049
	TO_DATE('49-11-25', 'RR-MM-DD') "RR"  -- 2049
FROM DUAL;

-- 50 이상 확인
SELECT 
	TO_DATE('59-11-25', 'YY-MM-DD') "YY", -- 2059
	TO_DATE('59-11-25', 'RR-MM-DD') "RR"  -- 1959
FROM DUAL;


-------------------------------------------------

-- TO_NUMBER(문자열 [,패턴]) : 문자열 -> 숫자 변환

SELECT TO_NUMBER('$1,500', '$9,999') -- 1500
FROM DUAL;

-------------------------------------------------
-------------------------------------------------
-------------------------------------------------

-- <NULL 처리 연산> : IS NULL / IS NOT NULL


-- <NULL 처리 함수>

-- NVL(컬럼명, 컬럼 값이 NULL일 경우 변경할 값)

-- EMPLOYEE 테이블에서 
-- 사번, 이름, 전화번호 조회
-- 단, 전화번호가 없으면(NULL) '없음' 으로 조회
SELECT EMP_ID, EMP_NAME, NVL(PHONE, '없음') 전화번호
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서
-- 이름, 급여, 보너스 조회
-- 보너스가 없으면 0으로 조회
SELECT EMP_NAME, SALARY, NVL(BONUS, 0) 
FROM EMPLOYEE;

/* NULL과 산술연산 수행 시 결과 무조건 NULL */

-- [EMPLOYEE]에서 이름, 급여, 성과급(급여*보너스)
-- 단, 성과금 없으면 0으로 표시
SELECT EMP_NAME, SALARY, SALARY * NVL(BONUS, 0) 성과급
FROM EMPLOYEE;


-------------------------------------------------

-- NVL2(컬럼명, NULL이 아닌 경우 변경할 값  , NULL인 경우 변경할 값)

-- EMPLOYEE 테이블에서
-- 사번, 이름, 전화번호 조회
-- 전화 번호가 없으면 '없음'
-- 전화 번호가 있으면 '010********' 형식으로 변경해서 조회
SELECT EMP_ID, EMP_NAME, 
	NVL2(PHONE, 
			 RPAD(SUBSTR(PHONE,1,3), LENGTH(PHONE), '*'),
			 '없음') 전화번호
FROM EMPLOYEE;


---------------------------------------------------------

-- <선택 함수>
-- 여러 가지 경우에 따라 알맞은 결과를 선택하는 함수
-- (if, switch문과 비슷)

-- DECODE(컬럼명 | 계산식, 조건1, 결과1, 조건2, 결과2, ... [,아무것도 만족 X])

-- 컬럼명 | 계산식의 값이 일치하는 조건이 있으면
-- 해당 조건 오른쪽에 작성된 결과가 반환된다.

-- [EMPLOYEE]에서 모든 사원의 이름, 민증번호, 성별 조회
SELECT EMP_NAME, EMP_NO, 
	DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남자', '2', '여자') 성별
FROM EMPLOYEE ;

-- EMPLOYEE 테이블에서
-- 직급코드가 'J7'인 직원은 급여 + 급여의 10%
-- 직급코드가 'J6'인 직원은 급여 + 급여의 15%
-- 직급코드가 'J5'인 직원은 급여 + 급여의 20%
-- 나머지 직급코드의 직원은 급여 + 급여의 5%  지급
-- 사원명, 직급코드, 기존급여, 지급급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY, 
	DECODE(JOB_CODE, 
				 'J7', SALARY * 1.1, 
				 'J6', SALARY * 1.15,
				 'J5', SALARY * 1.2,
				 			 SALARY*1.05) 지급급여
FROM EMPLOYEE ;

---------------

-- CASE 
--	  WHEN 조건1 THEN 결과1
--	  WHEN 조건2 THEN 결과2
--	  WHEN 조건3 THEN 결과3
--	  ELSE 결과
-- END

-- DECODE는 계산식|컬럼 값이 딱 떨어지는 경우에만 사용 가능.
-- CASE는 계산식|컬럼 값을 범위로 지정할 수 있다. 


-- EMPLOYEE 테이블에서 사번, 이름, 급여, 구분을 조회
-- 구분은 받는 급여에 따라 초급, 중급, 고급으로 조회
-- 급여 500만 이상 = '고급'
-- 급여 300만 이상 ~ 500만 미만 = '중급'
-- 급여 300미만 = '초급'
-- 단, 부서코드가 D6, D9인 사원만 직급코드 오름차순으로 조회
SELECT EMP_ID, EMP_NAME, SALARY,
	CASE 
		WHEN SALARY >= 5000000 THEN '고급'
		WHEN SALARY >= 3000000 THEN '중급'
		ELSE '초급'
	END 구분
	
FROM EMPLOYEE 
WHERE DEPT_CODE IN ('D6', 'D9')
ORDER BY JOB_CODE ;

--> SELECT절에 작성된 컬럼이 아니라고해서 ORDER BY에 사용 못하는거 아님
--> FROM절에서 해석되서 사용 가능한상태

-------------------------------------------------------------

/************* 그룹 함수 *************/

--  N개의 행의 컬럼 값을 전달하여 1개의 결과가 반환
--	(그룹의 수가 늘어나면 그룹의 수 만큼 결과를 반환)

-- 모든 사원의 급여 합
SELECT SUM(SALARY) FROM EMPLOYEE;

-- 부서 코드가 'D6'인 사원들 급여 합
SELECT SUM(SALARY)
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D6';

-- 2000년 이후(포함) 입사자들의 급여 합 조회
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE) >= 2000;

---------------------------

-- 모든 사원 평균 급여 조회
SELECT AVG(SALARY) FROM EMPLOYEE;

-- 평균 급여 조회(소수점 내림)
SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE;

/* 그룹 함수는 여러 개를 동시에 조회할 수 있다 */
-- (조회 결과가 사각형 형태의 테이블 모양이면 조회 가능하다)

SELECT SALARY , FLOOR(AVG(SALARY)) FROM EMPLOYEE;
-- 단일 그룹의 그룹 함수가 아닙니다 오류 뜸

---------------------------
-- MAX(컬럼명) : 최대값
-- MIN(컬럼명) : 최소값

-- 날짜 대소 비교 : 과거 < 미래
-- 문자열 대소 비교 : 유니코드순서  (문자열 순서  A < Z)

-- 모든 사원 중 가장 빠른 입사일, 최근 입사일
-- 이름 오름차순에서 제일 먼저 작성되는 이름, 마지막에 작성되는 이름
SELECT 
	MIN(HIRE_DATE), MAX(HIRE_DATE),
	MIN(EMP_NAME), MAX(EMP_NAME)
FROM EMPLOYEE ;

--------------------------------------------

-- COUNT(* | [DISTINCT] 컬럼명) : 조회된 행의 개수를 반환

-- COUNT(*) : 조회된 모든 행의 개수를 반환

-- COUNT(컬럼명) : 지정된 컬럼 값이 NULL이 아닌 행의 개수를 반환
-- 					(NULL인 행 미포함)

-- COUNT(DISTINCT 컬럼명) : 
	-- 지정된 컬럼에서 중복 값을 제외한 행의 개수를 반환
	-- EX) A A B C D D D E : 5개 (중복은 한 번만 카운트)

-- EMPLOYEE 전체 행 개수
SELECT COUNT(*) FROM EMPLOYEE;

-- [EMPLOYEE]에서 부서 코드가 'D5'인 사원 수
SELECT COUNT(*) FROM EMPLOYEE WHERE DEPT_CODE = 'D5';

-- 전화번호가 있는 사원 수 (NULL 아닌 행의 수만 카운트)
SELECT COUNT(PHONE) FROM EMPLOYEE;

-- 부서코드의 수를 조회
SELECT COUNT(DISTINCT DEPT_CODE) FROM EMPLOYEE;

-- EMPLOYEE 테이블에 존재하는 여자 사원의 수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 2; 

-- EMPLOYEE 테이블에 존재하는 남자 사원의 수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '1';

-- [EMPLOYEE]에 존재하는 여, 남 사원의 수
SELECT COUNT(DECODE(SUBSTR(EMP_NO, 8, 1), '2', '여자', NULL)) 여자,
			 COUNT(DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남자', NULL)) 남자
FROM EMPLOYEE;

-- [EMPLOYEE]에 존재하는 여, 남 사원의 수(SUM 버전)
SELECT 
	SUM(DECODE(SUBSTR(EMP_NO, 8, 1), '2', 1, 0)) 여자,
	SUM(DECODE(SUBSTR(EMP_NO, 8, 1), '1', 1, 0)) 남자
FROM EMPLOYEE;









