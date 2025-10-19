# WHERE VS HAVING
SELECT first_name, occupation, AVG(salary) 
FROM employee_salary
WHERE occupation LIKE '%Recreation%'
GROUP BY occupation, first_name
HAVING AVG(salary) < 73000
;