SELECT * 
FROM employee_salary;

CREATE TEMPORARY TABLE emp_below_50K_per_month
SELECT *
FROM employee_salary
WHERE salary < 50000
;



SELECT * 
FROM emp_below_50K_per_month;