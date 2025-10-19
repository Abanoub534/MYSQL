DELIMITER $$
CREATE Procedure get_department_employees_by_id (dept_id0 INT)
BEGIN 
	SELECT 
    s.employee_id,
    CONCAT(s.first_name, ' ', s.last_name),
    s.salary,
    s.occupation, 
    p.department_name
    FROM employee_salary s
    JOIN parks_departments p
		ON s.dept_id = p.department_id
	WHERE s.dept_id = dept_id0 ;
END $$
DELIMITER ;

 CALL get_department_employees_by_id(1);
    
    
    
    