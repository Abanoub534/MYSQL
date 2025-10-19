#LIMIT
SELECT first_name AS name, age
FROM employee_demographics
ORDER BY age DESC
LIMIT 3, 4
;
/* لاحظ ان هناك طريقتين لأستخدام ليميت
1- LIMIT 3, 4
دي معناها هاتلي 4 صفوف اول صف الصف اللي بعد رقم 3 يعني الصف رقم 4
ودي كأني كتبت الكود بالشكل دة 
LIMIT 4, OFFSET 3

2- LIMIT 3 OFFSET 4
دي معناها هاتلي 3 صفوف من بعد الصف الرابع يعني تبدأ من الصف الخامس*/




# Aliasing... (AS)
SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40
;