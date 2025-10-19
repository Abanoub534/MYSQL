SELECT CONCAT(first_name, ' ', last_name) AS full_name, salary,  
CASE
	WHEN salary < 30000 THEN salary * 1.05
    WHEN salary < 70000 THEN salary * 1.07
    WHEN salary >= 70000 THEN salary * 1.1
END AS new_salary,
CASE 
	WHEN employee_id = 5 THEN salary * 5
END AS retired_pouns
FROM employee_salary
;