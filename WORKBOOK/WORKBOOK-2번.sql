-- 1번
-- 영어영문학과(002) 학생들의 학번과 이름, 입학년도 조회
-- 입학 년도 빠른 순으로 표시
SELECT STUDENT_NO 학번, STUDENT_NAME 이름, ENTRANCE_DATE 입학년도
FROM TB_STUDENT 
WHERE DEPARTMENT_NO = '002'
ORDER BY ENTRANCE_DATE;

-- 2번
-- 이름이 세 글자가 아닌 교수의 이름과 주민번호 찾기
SELECT PROFESSOR_NAME, PROFESSOR_SSN 
FROM TB_PROFESSOR 
WHERE LENGTH(PROFESSOR_NAME) != 3;

-- 3번
-- 남자 교수들의 이름과 나이를 나이 오름차순으로 조회 (나이는 '만'으로 계산)
SELECT PROFESSOR_NAME 교수이름, 
			 FLOOR(MONTHS_BETWEEN( SYSDATE, 
			 								 TO_DATE(19||SUBSTR(PROFESSOR_SSN, 1, 6)) ) / 12) 나이
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) = '1'
ORDER BY 나이;

-- 4번
-- 교수 이름 성 빼고 조회
SELECT SUBSTR(PROFESSOR_NAME, 2) 이름

/* 이름 4글자는 3번째부터 자르는 경우 */
--CASE 
--	WHEN LENGTH(PROFESSOR_NAME) = 3
--	THEN SUBSTR(PROFESSOR_NAME, 2)
--	
--	WHEN LENGTH(PROFESSOR_NAME) = 4
--	THEN SUBSTR(PROFESSOR_NAME, 3)
--END 이름

FROM TB_PROFESSOR;

-- 5번
-- 재수생 입학자 조회. (입학 19살에 하면 재수아님)
SELECT STUDENT_NO, STUDENT_NAME 
FROM TB_STUDENT 
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE)
		- TO_NUMBER(19||SUBSTR(STUDENT_SSN, 1, 2)) > 19;


-- 6번
-- 2000년도 이후 입학자들은 학번이 A로 시작하는데 
-- 2000년도 이전 학번 받은 학생들의 학번과 이름 조회하기
SELECT STUDENT_NO, STUDENT_NAME 
FROM TB_STUDENT 
WHERE STUDENT_NO NOT LIKE 'A%';

-- 7번
-- 학번이 A517178인 한아름 학생의 학점 총 평점 구하기
-- 점수는 반올림하여 소수점 한자리까지 표시
SELECT ROUND(AVG(POINT), 1) 평점
FROM TB_GRADE
WHERE STUDENT_NO = 'A517178';


-- 8번
-- 학과별 학생 수를 구하여 '학과번호', '학생수(명)'의 형태로 조회
SELECT DEPARTMENT_NO 학과번호, COUNT(*) "학생수(명)"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO 
ORDER BY DEPARTMENT_NO ;

-- 9번
-- 지도 교수를 배정받지 못한 학생의 수를 조회
SELECT COUNT(*)
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;

-- 10번
-- 학번이 A112113인 김고운 학생의 년도 별 평점 구하기
SELECT SUBSTR(TERM_NO, 1, 4) 년도, ROUND(AVG(POINT), 1) "년도 별 평점"
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY SUBSTR(TERM_NO, 1, 4)
ORDER BY 년도;

-- 11번
-- 학과 별 휴학생 수를 파악하기. 학과 번호와 휴학생 수 조회
SELECT DEPARTMENT_NO 학과코드명,  COUNT(*) "휴학생 수"
FROM TB_STUDENT 
WHERE ABSENCE_YN = 'Y'

UNION ALL

SELECT DEPARTMENT_NO 학과코드명,  DECODE(ABSENCE_YN, 'N', 0) "휴학생 수"
FROM TB_STUDENT 
GROUP BY DEPARTMENT_NO 
ORDER BY DEPARTMENT_NO ;

-- 12번
-- 동명이인인 학생들 이름, 동명인 수 조회
SELECT STUDENT_NAME, COUNT(*)
FROM TB_STUDENT 
WHERE STUDENT_NAME ;

SELECT STUDENT_ADDRESS 
FROM TB_STUDENT ts ;

-- 13번
-- 학번이 A112113인 학생 학점 조회.
-- 년도, 학기 별 평점과 년도별 누적 평점, 총 평점 구하기
SELECT SUBSTR(TERM_NO, 1, 4) 년도, NVL(SUBSTR(TERM_NO, 5, 6), '') 학기,
			 ROUND(AVG(POINT), 1) "년도 별 평점"
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY ROLLUP(SUBSTR(TERM_NO, 1, 4), SUBSTR(TERM_NO, 5, 6));
ORDER BY 년도, 학기;






