SELECT employee_id,
CONCAT(first_name, ' ', last_name) AS full_name,
salary,
(SELECT avg(salary)
FROM employee_salary) AS avg_salary
FROM employee_salary
WHERE salary > (SELECT AVG(salary) FROM employee_salary)
;

/*بس هنا فية مشكلة كبيرة وهي ان هو كدة في كل مرة بيروح علشان يظهر سطر بيحسب الافريتج سالاري من اول وجديد ويضيفه في اخر عمود اللي هو الافريتج سالاري
فلو قاعدة البيانات كبيرة دة هيزود وقت كبير جدا 
الحل ان احنا نشوف طريقة نخلي بيها الافريتج سالاري يتحسب مرة واحدة واللوب مهمتها انها تضيفه في عمود جديد بس 
بدل متكون محتاجة تحسبه الاول في كل مرة */ 

SELECT e.employee_id, 
CONCAT(e.first_name, ' ', e.last_name) AS full_name, 
e.salary,
a.avg_salary
FROM employee_salary e
CROSS JOIN 
( SELECT avg(salary) AS avg_salary
FROM employee_salary 
) a
WHERE e.salary > a.avg_salary
;