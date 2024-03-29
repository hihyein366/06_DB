-- 1. 전지연이 속해있는 부서원들 조회 (단, 전지연 제외)
-- 사번, 사원명, 전화번호, 고용일, 부서명
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE DEPT_ID = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '전지연')
AND EMP_NAME != '전지연';

-- 2. 고용일이 2000년도 이후인 사원들 중 급여가 가장 높은 사원
-- 사번, 사원명, 전화번호, 급여, 직급명
SELECT EMP_ID, EMP_NAME, PHONE, SALARY, JOB_NAME
FROM EMPLOYEE 
JOIN JOB USING(JOB_CODE)
WHERE SALARY = (SELECT MAX(SALARY) 
								FROM EMPLOYEE
								WHERE EXTRACT(YEAR FROM HIRE_DATE) > 2000);

-- 3. 노옹철과 같은 부서, 같은 직급인 사원 조회 (단, 노옹철 제외)
-- 사번, 이름, 부서코드, 직급코드, 부서명, 직급명
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE 
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE (DEPT_ID, JOB_CODE) = (SELECT DEPT_ID, JOB_CODE FROM EMPLOYEE WHERE EMP_NAME='노옹철')
AND EMP_NAME != '노옹철';

-- 4. 2000년도에 입사한 사원과 부서와 직급이 같은 사원 조회
-- 사번, 이름, 부서코드, 직급코드, 고용일
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE 
FROM EMPLOYEE 
WHERE (DEPT_CODE, JOB_CODE) = (
	SELECT DEPT_CODE, JOB_CODE 
	FROM EMPLOYEE 
	WHERE (EXTRACT(YEAR FROM HIRE_DATE)) = 2000
);

-- 5. 77년생 여자 사원과 동일한 부서면서 동일한 사수 가지고 있는 사원 조회
-- 사번, 이름, 부서코드, 사수번호, 주민번호, 고용일
SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID, EMP_NO, HIRE_DATE 
FROM EMPLOYEE 
WHERE (DEPT_CODE, MANAGER_ID) = (
	SELECT DEPT_CODE, MANAGER_ID 
	FROM EMPLOYEE 
	WHERE SUBSTR(EMP_NO, 1, 2) = '77'
	AND SUBSTR(EMP_NO, 8, 1) = '2'
);

-- 6. 부서별 입사일 가장 빠른 사원
-- 사번, 이름, 부서명(NULL '소속없음'), 직급명, 입사일 조회
-- 입사일 빠른 순, 퇴사한 직원은 제외
SELECT EMP_ID, EMP_NAME, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE 
FROM EMPLOYEE MAIN
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN JOB USING(JOB_CODE)
WHERE HIRE_DATE = (
	SELECT MIN(HIRE_DATE) 
	FROM EMPLOYEE SUB
	WHERE NVL(SUB.DEPT_CODE, '소속없음') = NVL(MAIN.DEPT_CODE, '소속없음')
	AND ENT_YN != 'Y'
)
ORDER BY HIRE_DATE;

-- 7. 직급별 나이가 가장 어린 직원
-- 사번, 이름, 직급명, 나이, 보너스 포함 연봉
-- 나이순 내림차순, 연봉은 \000,000,000 원 단위로 출력되게
SELECT EMP_ID, EMP_NAME, JOB_NAME, 
	FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE(19||SUBSTR(EMP_NO, 1,6)))/12) "만 나이",
	TRUNC(SALARY * 12 + SALARY * 12 * NVL(BONUS, 0), -4) "보너스 포함 연봉"
FROM EMPLOYEE MAIN
JOIN JOB ON(JOB.JOB_CODE = MAIN.JOB_CODE)
WHERE EMP_NO = (
	SELECT MAX(EMP_NO)
	FROM EMPLOYEE SUB
	WHERE SUB.JOB_CODE = MAIN.JOB_CODE
) 
ORDER BY "만 나이" DESC;

							
							