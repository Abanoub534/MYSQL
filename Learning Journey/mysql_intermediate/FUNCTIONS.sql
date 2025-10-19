# String Functions 

/* 1- Length....
بتقيس طول الكلمة او الجملة
تستخدم في الحياة الواقعية من اجل التأكد من ان كل ارقام التليفونات بنفس الطول وانها صحيحة 
*/
SELECT first_name, LENGTH(first_name) AS Length
FROM employee_demographics
ORDER BY employee_id
;

/* 2- Upper and Lower....
UPPER command make all the letters upper cases
LOWER command make all the letters lower cases
*/

SELECT UPPER(first_name) Fname, LOWER(last_name) Lname 
FROM employee_demographics
ORDER BY employee_id
;

/* 3- Trim Command
TRIM
بتشيل اي مسافة موجودة في البداية والنهاية ,
LTRIM
بتشيل اي مسافة موجودة علي اليسار ,
RTRIM
بتشيل اي مسافة موجودة علي اليمين ,
TRIM('', FROM '')
بتشيل اللي مكتوب بين علاميتن التنصيص اللي في الاول من اللي داخل علامتين التنصيص اللي في الاخر 
*/
SELECT TRIM('x' FROM 'xxxxABANOUBx') AS Result;

/* SUBSTRING....
SUBSTRING('vsrible', start_point, how many charcters)
*/
SELECT employee_id ID, 
first_name Fname, 
birth_date BDate,
SUBSTRING(birth_date, 6, 2) AS BMonth
FROM employee_demographics;

/* REPLACE....
REPLACE(varible, carc that will be reblaced, the new carc)
*/

SELECT first_name, REPLACE(first_name, 'A', 'X') AS Xodia
FROM employee_salary;
#لاحظ بتفرق ما بين الحروق الكابيتال والحروف السمووول


SELECT locate('a', first_name)
FROM employee_demographics;
#بتقولك اللي انت اخترته موجود في الخانة رقم كام من الشمال لليمين


SELECT CONCAT(first_name, ' ', last_name) NAME
FROM employee_demographics;

#بتدمج بين عمودين تحطهم في عمود واحد