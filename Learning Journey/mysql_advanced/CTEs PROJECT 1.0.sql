WITH dept_avg AS (
SELECT dept_id,
AVG(salary) AS avg_salary
FROM employee_salary
GROUP BY dept_id
)
SELECT s.employee_id,
CONCAT(s.first_name, ' ', last_name) full_name,
s.occupation,
p.department_name,
p.department_id,
salary,
a.avg_salary,
CONCAT(ROUND((s.salary / a.avg_salary) * 100, 2), '%') AS relative_average_wages
FROM employee_salary AS s
JOIN parks_departments AS p
	ON s.dept_id = p.department_id
JOIN dept_avg AS a
	ON s.dept_id = a.dept_id
WHERE s.salary > a.avg_salary

UNION ALL 

SELECT s.employee_id,
CONCAT(s.first_name, ' ', last_name) full_name,
s.occupation,
p.department_name,
p.department_id,
salary,
a.avg_salary,
CONCAT(ROUND((s.salary / a.avg_salary) * 100, 2), '%') AS relative_average_wages
FROM employee_salary AS s
JOIN parks_departments AS p
	ON s.dept_id = p.department_id
JOIN dept_avg AS a
	ON s.dept_id = a.dept_id
WHERE s.salary < a.avg_salary
ORDER BY employee_id
;
