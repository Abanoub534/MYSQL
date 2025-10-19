WITH salary_info AS(
SELECT 
employee_id,
CONCAT(first_name, ' ', last_name) full_name,
salary,
AVG(salary) OVER(PARTITION BY dept_id) AS  avg_salary_per_dept,
CONCAT(ROUND((salary / AVG(salary) OVER(PARTItiON BY dept_id)) * 100, 2), '%') AS relative_salary_percentage
FROM employee_salary
),
above_avg AS(
SELECT *
FROM salary_info
WHERE salary >  avg_salary_per_dept
),
below_avg AS(
SELECT *
FROM salary_info
WHERE salary <  avg_salary_per_dept
)

SELECT *,
 'Above AVG' AS status
FROM above_avg

UNION ALL

SELECT *,
 'below AVG' AS status
FROM below_avg
ORDER BY employee_id
;






