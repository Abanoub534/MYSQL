# WHERE Statement

SELECT *
FROM employee_demographics;

SELECT * #علامة يساوي تدل علي انه لازم تكون شبه بعض بالظبط
FROM employee_demographics
WHERE first_name = "Tom";

SELECT * # علامة اكبر من لمقارنة الارقام والتواريخ لكن خلي بالك الارقام اللي بتساويها مش هتظهر
FROM employee_demographics
WHERE age > 60;

SELECT *
FROM employee_salary
WHERE salary = 50000;

SELECT *
FROM employee_salary
WHERE salary > 50000;

SELECT * #علامة الاكبر من او تساوي هتظهر الارقام الاكبر وكمان لو فية متغيرات بتساوي المتغير اللي بيتقارن بية
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM employee_demographics
WHERE gender = 'Male';

SELECT * #العلامة دي معناها لا تساوي ودي عكس علامة تساوي الاولي 
FROM employee_demographics
WHERE gender != 'Male';

SELECT * # زي مقولنا فوق ممكن نستخدم المقارنات مع التواريخ عادي 
FROM employee_demographics
WHERE birth_date > '1990-01-01';

# And Or Not ____ Logical Operators 

Select *
FROM employee_demographics
WHERE age > 60
AND gender = 'Male';

Select *
FROM employee_demographics
WHERE birth_date < '1979-01-01'
AND NOT gender = 'Male';

Select *
FROM employee_demographics
WHERE age > 40
OR first_name = 'Ann';

Select *
FROM employee_demographics
WHERE age > 40
OR NOT birth_date > '1985-01-01';



#LIKE Statement
#we follow the word with (%) if i want to say any thing 

SELECT *
FROM employee_demographics
WHERE first_name LIKE 'Do%' 
OR last_name LIKE 'Wy%';


SELECT *
FROM employee_demographics
WHERE first_name LIKE '%nn%'
OR last_name LIKE '%tt';

# Finally we can use it with birth date 

SELECT *
FROM employee_demographics
WHERE birth_date LIKE '1988%';

#and we use (_) if we need to say a number of carchters

SELECT *
FROM employee_demographics
WHERE first_name LIKE 'An_' 
OR last_name LIKE '________oo__';

# and actually we can mix it 

SELECT *
FROM employee_demographics
WHERE first_name LIKE '__ri%' 
OR last_name LIKE '_a%';

