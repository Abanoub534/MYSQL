SELECT *
FROM employee_demographics;

# GROUP BY # يستخرج الصفوف المميزة , المميز في هذة الفانكشن هي انه يمكنك عمل عمليات حسابية معها 

SELECT gender
FROM employee_demographics
GROUP BY gender;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;

#  ORDER BY # تستخدم للترتيب من الاعلي الي الاقل او العكس , رجال اولا ثم اناث , وما الي ذلك 

SELECT *
FROM employee_demographics
ORDER BY gender, age DESC
;