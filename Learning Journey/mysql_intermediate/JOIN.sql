#INNER JOIN...
SELECT dem.employee_id, 
dem.first_name AS name, 
dem.age, 
sal.occupation, 
sal.salary
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.first_name = sal.first_name
;

#Outer JOIN..... Right and Lift

/* Right Join....
الرايت جوين بياخد التابل اللي في امر جوين وبعدين بياخد باقي البيانات من التابل اللي في امر فروم والصف اللي ملهوش بيانات بياخد نول
*/

SELECT dem.employee_id, 
dem.first_name AS name, 
dem.age, sal.occupation, 
sal.salary
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal
	ON dem.first_name = sal.first_name
;
# لاحظ هنا النتيجة كانت ان في الموظف رقم 2 كان  نول في بيانات الجدول اللي في امر فروم لأن الموظف رقم 2 مش موجود في الجدول لكن ظهر في الجدول الكلي وظهرت بيانته مع الجدول 2


/* Left Join....
بياخد بيانات الجدول اللي في امر فروم وبيكمل البيانات من الجدول التاني اللي في امر جوين 
*/
SELECT dem.employee_id,
dem.first_name AS name, 
dem.age, 
sal.occupation, 
sal.salary
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal
	ON dem.first_name = sal.first_name
;
# لاحظ هنا الموظف رقم 2 مظهرش خالص لأنه مش موجود في الجدول اللي في امر فروم 


/* SELF JOIN....
من الاسم واضح اننا هنا هنضيف نفس التابل لنفسها 
*/

SELECT amp1.employee_id AS id_santa, 
amp1.first_name AS Fname_santa, 
amp1.last_name AS Lname_santa,
amp2.employee_id AS id_amp, 
amp2.first_name AS Fname_amp, 
amp2.last_name AS Lname_amp
FROM employee_salary AS amp1
JOIN employee_salary AS amp2
	on amp1.employee_id + 1 = amp2.employee_id
;
/* وبكدة كل موظف هيدي لحد هدية وموظف تاني هيديله هدية بس هنا فية غلطة منطقية وهي ان الموظف رقم 1 هيدي هدية للموظف رقم 2 بس محدش هيديله هدية
 والمشكلة رقم 2 ان الموظف رقم 12 هياخد هدية لكن محدش هيديله هدية  
علي امل اني اعرف احل المشكلة دي في المستقبل 
*/


# Multible JOIN

SELECT sal.employee_id AS ID,
sal.first_name AS Fname,
sal.last_name AS Lname,
dem.gender, 
dem.age,
sal.salary,
par.department_name
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
RIGHT JOIN parks_departments as par
	ON sal.dept_id = par.department_id
ORDER BY sal.employee_id
    ;
# دة كدة مشروع نهائي لموضوع جوين , احييك 🫡





