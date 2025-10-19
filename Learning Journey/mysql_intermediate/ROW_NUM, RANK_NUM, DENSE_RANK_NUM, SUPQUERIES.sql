SELECT e.employee_id, 
CONCAT(e.first_name, ' ',e.last_name) AS full_name, 
s. salary,
p.department_name,
ROW_NUMBER() OVER(PARTITION BY p.department_name ORDER BY s.salary) AS row_num,
RANK() OVER(PARTITION BY p.department_name ORDER BY s.salary) AS rank_num,
DENSE_RANK() OVER (PARTITION BY p.department_name ORDER BY s.salary) AS dense_rank_num,
AVG(s.salary) OVER(PARTITION BY p.department_name) AS avg_salary_by_dept
FROM employee_demographics e
JOIN employee_salary s
	on e.employee_id = s.employee_id
JOIN parks_departments p
	ON s.dept_id = p.department_id
ORDER BY e.employee_id
;
