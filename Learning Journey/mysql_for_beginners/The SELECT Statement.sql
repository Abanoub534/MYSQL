SELECT * 
FROM employee_demographics; # النجمة معناها انك محدد كل الاعمدة 

SELECT birth_date
FROM employee_demographics; # كدة احنا حددنا عمود واحد بس من الداتا بيس بتاعتنا 

SELECT *
FROM parks_and_recreation.employee_demographics; # في الأمرين اللي فاتوا الكود كان بيشتغل علشان احنا محددين الداتا بيس بتاعتنا علي انها ديفولت لكن لو كنا محددين داتا بيس تانية علي انها ديفولت مكانش الامر هيشتغل


SELECT employee_id,
gender,
birth_date,
age,
(((age + 10)^2) * 5 )^0.5
FROM parks_and_recreation.employee_demographics;
#P(الاقواس)E(الاسس والجذور)M(الضرب)D(القسمة)A(الجمع)S(الطرح) its PEMDAS role


SELECT DISTINCT gender
FROM employee_demographics;
# هذا الامر يظهر الشيئ المميز فقط ففي مثال الجنس لم يظهر سوا صفين فقط ذكر وانثي 
