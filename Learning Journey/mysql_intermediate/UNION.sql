# Union Statement.....

SELECT first_name, 
last_name, 
'The old man' AS gender
FROM employee_demographics
WHERE age > 40 
AND gender = 'Male'
UNION
SELECT first_name, 
last_name, 
'The old woman' AS gender
FROM employee_demographics
WHERE age > 40 
AND gender = 'Female'
UNION
SELECT first_name, 
last_name, 
'Haighly paid' AS Encome
FROM employee_salary
WHERE salary > 70000
;
/* كدة الفرق بين يونيون وجوين ان جوين بيضيف الجداول علي بعض بالعرض يعني بيزود الاعمدة 
انما يونيون بتضيف صفوف علي بعض يعني بتذود الطووول
*/
